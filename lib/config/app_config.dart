import 'package:flutter/material.dart';
import 'package:trybapp/utils/enum_utils.dart';

enum AppFlavor {
  local,
  dev,
  qa,
  prod,
}

class AppConfig {
  final AppFlavor appFlavor;
  final String appFlavorName;
  final bool enableDebug;

  static AppConfig _instance;

  AppConfig._internal(
    this.appFlavor,
    this.appFlavorName,
    this.enableDebug,
  );

  factory AppConfig({
    @required AppFlavor appFlavor,
    @required bool enableDebug,
  }) {
    _instance ??= AppConfig._internal(
      appFlavor,
      Enums.toEnumName(appFlavor.toString()),
      enableDebug,
    );

    return _instance;
  }

  static AppConfig get instance => _instance;

  static bool isProduction() => _instance.appFlavor == AppFlavor.prod;

  static bool isDevelopment() => _instance.appFlavor == AppFlavor.dev;

  static bool isLocal() => _instance.appFlavor == AppFlavor.local;
}
