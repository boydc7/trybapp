import 'package:flutter/material.dart';
import 'package:trybapp/main.dart';
import 'package:trybapp/services/auth_service.dart';
import 'package:trybapp/services/core_service.dart';
import 'package:trybapp/services/log_manager.dart';
import 'package:trybapp/theme.dart';
import 'package:trybapp/views/redirect.dart';

class TrybApp extends StatefulWidget {
  @override
  _TrybAppState createState() => _TrybAppState();
}

class _TrybAppState extends State<TrybApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initApp();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> initApp() {
    return Future<void>(() async {
      return CoreService.instance.initCore().then((value) async {
        AuthService.instance.onAuthStateChanged.listen((changed) {
          navKey.currentState.pushReplacementNamed('/');
        });
      }).catchError((x) {
        LogManager.instance.logException(x);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //showPerformanceOverlay: true,
      color: Colors.white,
      title: 'Tryb',
      theme: AppTheme().buildTheme(),
      darkTheme: AppTheme().buildDartTheme(),
      navigatorKey: navKey,
      navigatorObservers: <NavigatorObserver>[
        LogManager.instance.analyticsObserver,
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => RedirectPage(),
      },
    );
  }
}
