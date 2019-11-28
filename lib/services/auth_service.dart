import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trybapp/data/account_api.dart';
import 'package:trybapp/data/profile_api.dart';
import 'package:trybapp/enums/account_type.dart';
import 'package:trybapp/models/tryb_account.dart';
import 'package:trybapp/models/tryb_profile.dart';

import 'device_storage.dart';
import 'log_manager.dart';

enum AuthState {
  Unknown,
  Unauthenticated,
  Authenticating,
  Authenticated,
}

class AuthService {
  static final AppLog _log = LogManager.getLogger('AuthService');
  static final _authStateChangeSubject = BehaviorSubject<AuthState>();
  static final _firebaseAuth = FirebaseAuth.instance;
  static final AuthService _instance = AuthService._internal();

  TrybAccount _currentAccount;
  TrybProfile _currentProfile;
  List<TrybProfile> _profiles;
  FirebaseUser _currentGfbUser;
  AuthState _currentState = AuthState.Unknown;

  AuthService._internal();

  static AuthService get instance => _instance;

  TrybAccount get currentAccount => _currentAccount;

  TrybProfile get currentProfile => _currentProfile;

  FirebaseUser get currentGfbUser => _currentGfbUser;

  String get currentAccountId => _currentGfbUser?.uid;

  List<TrybProfile> get profiles => _profiles;
  Observable<FirebaseUser> _onFirebaseAuthStateChangedObservable;
  Observable<AuthState> get onAuthStateChanged => _authStateChangeSubject.stream;

  bool isAuthenticated() => _currentAccount != null && _currentGfbUser != null;

  void dispose() {
    _authStateChangeSubject.close();
    _onFirebaseAuthStateChangedObservable = null;
  }

  Future<void> init() async {
    try {
      _setAuthState(AuthState.Authenticating);

      await _initGfbUser();

      if (_currentGfbUser == null) {
        await signOut();
        return;
      }

      await _syncTrybAccount();

      if (_verifyCurrentConfig()) {
        _setAuthState(AuthState.Authenticated);
      } else {
        await signOut();
      }
    } catch (x) {
      _log.logException(x);

      await signOut();

      rethrow;
    } finally {
      // Do not start listening until the end of init purposely...
      _onFirebaseAuthStateChangedObservable = Observable(_firebaseAuth.onAuthStateChanged);
      _onFirebaseAuthStateChangedObservable.listen(_onFirebaseAuthStateChanged);
    }
  }

  void _onFirebaseAuthStateChanged(FirebaseUser gfbUser) {
    if (gfbUser == null) {
      if (_currentGfbUser != null) {
        signOut();
      }

      return;
    }

    if (_currentGfbUser == null) {
      _currentGfbUser = gfbUser;
    }

    if (gfbUser.uid != _currentGfbUser.uid) {
      signOut();
      return;
    }

    _setAuthState(AuthState.Authenticated);
  }

  Future<void> signOut([String errorReason]) async {
    _setAuthState(AuthState.Unauthenticated);

    _profiles = null;
    _currentAccount = null;
    _currentProfile = null;

    if (_currentGfbUser != null || await _firebaseAuth.currentUser() != null) {
      _currentGfbUser = null;
      await _firebaseAuth.signOut();
    }

    if (errorReason != null) {
      _log.logDebug(errorReason);
    }
  }

  Future<bool> checkEmail(String email) async {
    try {
      var providers = await _firebaseAuth.fetchSignInMethodsForEmail(email: email);
      return (providers != null && providers.isNotEmpty);
    } catch (x) {
      rethrow;
    }
  }

  Future<FirebaseUser> signInWithEmail(String email, String password) async {
    try {
      var fbResult = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      _currentGfbUser = fbResult.user;

      if (_currentGfbUser.isEmailVerified) {
        await connectFirebaseUser();
      }
      return _currentGfbUser;
    } catch (x) {
      await signOut();
      rethrow;
    }
  }

  Future<FirebaseUser> signUpWithEmail(String email, String password, String fullName) async {
    try {
      var fbResult = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      await fbResult.user.sendEmailVerification();

      //Update name
      UserUpdateInfo info = UserUpdateInfo();
      info.displayName = fullName;
      await fbResult.user.updateProfile(info);

      //Get updated user
      _currentGfbUser = await signInWithEmail(email, password);
      return _currentGfbUser;
    } catch (x) {
      await signOut();
      rethrow;
    }
  }

  Future<void> verifyEmail() async {
    try {
      if (_currentGfbUser != null) {
        var reloadedUser = await _firebaseAuth.currentUser();
        await reloadedUser.reload();
        _currentGfbUser = reloadedUser;
        if (_currentGfbUser.isEmailVerified) {
          await connectFirebaseUser();
        }
        _setAuthState(AuthState.Authenticated);
      }
    } catch (x) {
      await signOut();
      rethrow;
    }
  }

  Future<void> verifyPhoneNumber(String phone) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phone,
          timeout: Duration(seconds: 30),
          verificationCompleted: ((phoneCredentials) async {
            await onAuthenticate(phoneCredentials);
          }),
          verificationFailed: ((err) async {
            await signOut();
            throw (err);
          }),
          codeSent: ((verificationId, [forceResendingToken]) async {
            await DeviceStorage.setVerificationId(verificationId);
          }),
          codeAutoRetrievalTimeout: (String verificationId) async {
            await DeviceStorage.deleteVerificationId();
          });
    } catch (x) {
      await signOut();
      rethrow;
    }
  }

  Future<void> signInWithPhoneNumber(String code) async {
    try {
      if (code == null) {
        await signOut();
        return;
      }

      var verificationId = await DeviceStorage.getVerificationId();

      if (verificationId == null) {
        await signOut();
        return;
      }

      var phoneCredentials = await PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: code);
      await onAuthenticate(phoneCredentials);
    } catch (x) {
      await signOut();
      rethrow;
    }
  }

  void connectFirebaseUser({
    String authProviderToken,
    String authProviderId,
  }) async {
    if (_currentGfbUser == null) {
      await signOut('No valid GFB user');
      return;
    }

    try {
      var firstProviderData =
          (_currentGfbUser.providerData?.length ?? 0) <= 0 ? null : _currentGfbUser.providerData.first;

      if (authProviderId == null || authProviderId.isEmpty) {
        authProviderId = firstProviderData?.uid;
      }

      /// connect the account, creating or retrieving the master user id
      /// and account api key we'll use the continue on
      _currentAccount = await AccountApi.instance.connectAccount(
        TrybAccount(
          accountType: AccountType.user,
          id: _currentGfbUser.uid,
          name: _currentGfbUser.displayName ?? firstProviderData?.displayName,
          authProvider: firstProviderData?.providerId ?? _currentGfbUser.providerId,
          authProviderToken: authProviderToken,
          avatar: _currentGfbUser.photoUrl ?? firstProviderData?.photoUrl,
          email: _currentGfbUser.email ?? firstProviderData?.email,
          phoneNumber: _currentGfbUser.phoneNumber ?? firstProviderData?.phoneNumber,
          isEmailVerified: _currentGfbUser.isEmailVerified,
        ),
      );

      await _syncTrybAccount();

      _setAuthState(AuthState.Authenticated);
    } catch (x) {
      await signOut('Could not connect firebase user');
      rethrow;
    }
  }

  Future<void> onAuthenticate(AuthCredential credential, [bool isNewLogin = true]) async {
    if (_currentState == AuthState.Authenticating) {
      return;
    }

    try {
      _setAuthState(AuthState.Authenticating);

      await _firebaseAuth.signInWithCredential(credential);

      _currentGfbUser = await _firebaseAuth.currentUser();

      if (_currentGfbUser == null) {
        await signOut();
        return;
      }

      await connectFirebaseUser();
    } catch (x) {
      await signOut();
      rethrow;
    }

    if (isNewLogin) {
      unawaited(LogManager.analytics.logLogin());
    }
  }

  void _setAuthState(AuthState toState) {
    assert(_log.logDebug('Setting AuthState to [$toState]'));
    _currentState = toState;
    _authStateChangeSubject.add(toState);
  }

  bool _verifyCurrentConfig() {
    if (_currentGfbUser == null || _currentAccount == null || _profiles == null || _currentProfile == null) {
      return false;
    }

    // We have valid objects, do they match?
    if (_currentAccount.id != _currentGfbUser.uid) {
      _log.logWarning('Mismatch UID in auth verify - gfb:[${_currentGfbUser.uid}], tapi:[${_currentAccount.id}]');
      return false;
    }

    return true;
  }

  Future<void> _syncTrybAccount() async {
    // Go to the Tryb api and get the current account, profiles
    if (_currentAccount == null || _currentAccount.id != _currentGfbUser.uid) {
      _currentAccount = await AccountApi.instance.getMyAccount();
    }

    if (_currentAccount == null) {
      await signOut();
      return;
    }

    _profiles = await ProfileApi.instance.getMyProfiles();

    _currentProfile = _profiles?.firstWhere(
      (p) => p.isDefault,
      orElse: () => _profiles.first,
    );
  }

  Future<void> _initGfbUser() async {
    if (_currentGfbUser == null) {
      _currentGfbUser = await _firebaseAuth.currentUser();
    }

    if (_currentGfbUser == null) {
      await signOut();
    }
  }
}

class FacebookAuthService {
  static final FacebookLogin _facebookSignIn = FacebookLogin();
  static final AppLog _log = LogManager.getLogger('FacebookAuthService');

  static Future<void> signOut() async {
    await _facebookSignIn.logOut();
    await AuthService.instance.signOut();
  }

  static Future<void> tryAuthenticate() async {
    var fbLoginResult = await _facebookSignIn.logIn([
      'email',
      'public_profile',
    ]);

    switch (fbLoginResult.status) {
      case FacebookLoginStatus.loggedIn:
        {
          assert(_log.logDebug('Facebook token [${fbLoginResult.accessToken.token}]'));

          var authCredential = FacebookAuthProvider.getCredential(accessToken: fbLoginResult.accessToken.token);

          await AuthService.instance.onAuthenticate(authCredential);

          break;
        }
      case FacebookLoginStatus.cancelledByUser:
        {
          _log.logWarning('Login cancelledByUser');
          await signOut();
          break;
        }
      case FacebookLoginStatus.error:
        {
          _log.logError('Login failure [${fbLoginResult.errorMessage}]');
          await signOut();
          break;
        }
    }
  }
}

class GoogleAuthService {
  static final _googleSignIn = GoogleSignIn();

  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    await AuthService.instance.signOut();
  }

  static Future<void> tryAuthenticate() async {
    var isNewLogin = false;

    var googleUser = _googleSignIn.currentUser;

    if (googleUser == null) {
      googleUser = await _googleSignIn.signIn();
      isNewLogin = true;
    }

    if (googleUser == null) {
      await signOut();
      return;
    }

    var googleAuth = await googleUser.authentication;

    var authCredential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await AuthService.instance.onAuthenticate(authCredential, isNewLogin);
  }
}
