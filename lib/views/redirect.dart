import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trybapp/services/auth_service.dart';
import 'package:trybapp/services/device_storage.dart';
import 'package:trybapp/widgets/loading.dart';

class RedirectPage extends StatefulWidget {
  @override
  _RedirectPageState createState() => _RedirectPageState();
}

class _RedirectPageState extends State<RedirectPage> {
  @override
  void initState() {
    super.initState();
    checkCurrentUser();
  }

  @override
  void didUpdateWidget(RedirectPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    checkCurrentUser();
  }

  Future<void> checkCurrentUser() {
    return Future<void>(() async {
      FirebaseUser user = AuthService.instance.currentGfbUser;

      if (user != null) {
        if (user.providerData != null) {
          var providerIds = user.providerData.map((provider) {
            return provider.providerId;
          }).toList();

          if (providerIds.contains("facebook.com") || providerIds.contains("google.com") || user.isEmailVerified) {
            // Email verification is not required or is verified
            if (await DeviceStorage.getBool('tryb_onboard_complete')) {
              await Navigator.pushReplacementNamed(context, '/home');
            } else {
              await Navigator.pushReplacementNamed(context, '/onboarding');
            }
            return;
          } else {
            await Navigator.pushReplacementNamed(context, '/email/verify');
            return;
          }
        }
      }
      await Navigator.pushReplacementNamed(context, '/auth');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Loading(
        text: "Loading...",
      ),
    ));
  }
}
