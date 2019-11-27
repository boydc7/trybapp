import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'config/app_config.dart';

final GlobalKey<NavigatorState> navKey = GlobalKey();

Future main() async {
  /// fixes: https://stackoverflow.com/questions/57689492/flutter-unhandled-exception-servicesbinding-defaultbinarymessenger-was-accesse
  WidgetsFlutterBinding.ensureInitialized();

  const bool isReleaseBuild = bool.fromEnvironment('dart.vm.product');

  AppConfig(
    appFlavor: isReleaseBuild ? AppFlavor.prod : AppFlavor.dev,
    enableDebug: !isReleaseBuild,
  );

  // TODO: Add crashlytics...

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  ).then(
    (_) {
      runApp(
        TrybApp(),
      );
    },
  );
}
