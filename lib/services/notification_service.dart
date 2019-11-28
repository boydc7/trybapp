import 'dart:io' show Platform;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:trybapp/services/auth_service.dart';
import 'package:trybapp/services/log_manager.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  static final AppLog _log = LogManager.getLogger('NotificationService');

  static final NotificationService _instance = NotificationService._internal();

  static NotificationService get instance => _instance;

  NotificationService._internal() {
    AuthService.instance.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  void _onAuthStateChanged(AuthState state) {
    if (state == AuthState.Authenticated) {
      // TODO: Get token
      // _firebaseMessaging.
    } else if (state == AuthState.Unauthenticated) {
      // TODO: Unregister...
    }
  }

  init() {
    // https://github.com/flutter/plugins/tree/master/packages/firebase_messaging#receiving-messages
    // onMessage = app is in foreground
    // onLaunch = app was terminated, user clicks notification
    // onResume = app was in background, user clicks notification
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     _processMessage(message, true, 'onMessage');
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     _processMessage(message, false, 'onLaunch');
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     _processMessage(message, false, 'onResume');
    //   },
    // );

    // listener that only fires on iOS and will tells of the users current or changing notification settings: e.g: {sound: false, alert: false, badge: false}
    // _firebaseMessaging.onIosSettingsRegistered.listen((
    //   IosNotificationSettings settings,
    // ) {
    //   // TO DO: store their settings in users prefs?
    // });
  }

  void requestNotificationPermissions() {
    if (Platform.isIOS) {
      _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
          sound: true,
          badge: true,
          alert: true,
        ),
      );
    }
  }

/*
  void _processMessage(
    Map<String, dynamic> message,
    bool isLocal,
    String fromCaller,
  ) async {
    assert(_log.logDebug('Push Notification received: [$message]'));

    _currentContext = _navKey.currentState.overlay.context;
    _appState = AppStateContainer.of(_currentContext).state;

    var _message = AppNotification.fromMessage(message);

    // if we have a message that is good to show then either process a local notification (from onMessage) or a native 'click'
    if (isLocal) {
      // next, process some logic which decides whether or not the message is even elligible to be shown to the user or should be supressed
      bool showMessage = await shouldShowLocalNotification(_message);

      if (showMessage) {
        processLocal(_message);
      }
    } else {
      processNative(_message);
    }
  }

  void processNative(
    AppNotification message,
  ) async {
    bool goodToNavigate = await switchToTargetUser(message);

    // the only time this would be false if we don't have the user
    // on the users device / were unable to switch to it...
    if (goodToNavigate) {
      navigate(message);
    }
  }

  void processLocal(
    AppNotification message, [
    bool showMissingUserError = false,
  ]) {
    final double width = MediaQuery.of(_currentContext).size.width;

    if (_notificationTimer != null) {
      _notificationTimer.cancel();
    }

    // if we still have a notification showing then we'll need to remove it from the navigator overlays
    if (_notificationShowing) {
      _notificationOverlay.remove();
    }

    // create the new notification passing in the current navigator context and message we received from app.dart
    _notificationOverlay = OverlayEntry(builder: (BuildContext context) {
      return _buildNotification(width: width, message: message, showError: showMissingUserError);
    });

    // add the overlay to the current navigator
    Navigator.of(_currentContext).overlay.insert(_notificationOverlay);
    _notificationShowing = true;

    // create a new timer that will trigger hiding the notification if its still shown
    // (wasn't dismised by the user or superceeded by another notification)
    _notificationTimer = Timer(const Duration(seconds: 7), () {
      if (_notificationShowing) {
        _notificationOverlay.remove();
        _notificationShowing = false;
      }
    });
  }

  void processLocalNavigateClick(AppNotification message) async {
    bool goodToNavigate = await switchToTargetUser(message);

    if (goodToNavigate) {
      navigate(message);
    } else {
      processLocal(message, true);
    }
  }

  void navigate(AppNotification message) {
    /// by the time we get here we are ready to navigate the user
    /// to the route that was identified when converting the message into a notification model
    /// at this point we've passed any errors and have switched to the target user if user
    /// had a different user active prior to navigation
    ///
    /// we'll push the named route and clear anything else on the stack
    /// this could be made more intelligent one day whereby checking if we're navigating from a local or native
    /// message and combined with whether or not we just got switched to a different user and based on that
    /// either clear the stack or add to it, but for now we'll clear all to have less logic
    Navigator.of(_currentContext).pushNamedAndRemoveUntil(message.route, (Route<dynamic> route) => false);
  }

  /// Here we'll figure out if the incoming local notification should even be shown
  /// to the user based on a few different logic points
  Future<bool> shouldShowLocalNotification(AppNotification message) async {
    /// if there are no users on this device then supress any messages
    /// this could happen if a message token on the server is still valid or in flight
    /// but the user has removed all users from the device (and would be on the start page again)
    if (_appState.currentUser == null) {
      appLog.log(AppLogEvent(
        className: runtimeType.toString(),
        origin: 'shouldShowLocalNotification',
        message: 'no users on device',
      ));
      return false;
    }

    /// if this message is inteded for a given publisher and the current user
    /// is that same publisher then we don't need to show it to the user him/herself
    if (message.toPublisherAccount != null && message.toPublisherAccount.id == _appState.currentUser.id) {
      appLog.log(AppLogEvent(
        className: runtimeType.toString(),
        origin: 'shouldShowLocalNotification',
        message: 'target user matches current user',
      ));

      return false;
    }

    /// next, if this message is intended for a user other than the currently active one
    /// then ensure that user exists on the device, check ONLY first, because we only will
    /// actually switch to the target user if the user chooses to click the notification
    if (message.toPublisherAccount != null && message.toPublisherAccount.id != _appState.currentUser.id) {
      bool hasUser = await AppStateContainer.of(_currentContext).hasUser(message.toPublisherAccount.id);

      if (!hasUser) {
        appLog.log(AppLogEvent(
          className: runtimeType.toString(),
          origin: 'shouldShowLocalNotification',
          message: 'target user not found on device',
        ));
        return false;
      }
    }

    /// this will pop the first route from our navigator without actually popping it (return true)
    /// this route name will essentially be the current 'page' we're on which we'll use to figure out
    /// if we should be navigating the user somewhere else based on where the message should route vs. where they are now
    String currentRouteName;
    Navigator.of(_currentContext).popUntil((route) {
      currentRouteName = route.settings.name;
      return true;
    });

    if (message.route != null && message.route == currentRouteName) {
      appLog.log(AppLogEvent(
        className: runtimeType.toString(),
        origin: 'shouldShowLocalNotification',
        message: 'target route: ${message.route} same as current route: $currentRouteName',
      ));

      return false;
    }

    return true;
  }

  Widget _buildNotification({
    @required double width,
    @required AppNotification message,
    @required bool showError,
  }) {
    return Positioned(
        top: 42,
        width: width,
        child: Dismissible(
          key: Key(message.hashCode.toString()),
          direction: DismissDirection.up,
          onDismissed: (_) {
            _notificationOverlay.remove();
            _notificationShowing = false;
          },
          child: Card(
              margin: EdgeInsets.only(
                left: 16,
                right: 16,
              ),
              child: Container(
                child: showError ? _buildErrorBody(message) : _buildMessageBody(message),
              )),
        ));
  }

  Widget _buildMessageBody(AppNotification message) {
    return ListTile(
      title: Text(message.title),
      subtitle: Text(
        message.body,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {
        _notificationOverlay.remove();
        _notificationShowing = false;
        processLocalNavigateClick(message);
      },
    );
  }

  Widget _buildErrorBody(AppNotification message) {
    return ListTile(
      title: Text("Target user not on device"),
      subtitle: Text(
        "This notification was intended for a user that is no longer connected on this device",
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {
        _notificationOverlay.remove();
        _notificationShowing = false;
      },
    );
  }
*/
}
