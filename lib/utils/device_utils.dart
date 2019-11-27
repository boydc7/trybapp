import 'package:device_info/device_info.dart';

enum BuildMode {
  Debug,
  Profile,
  Release,
}

class DeviceUtils {
  static BuildMode currentBuildMode() {
    // SEE: https://github.com/flutter/flutter/issues/11392

    if (const bool.fromEnvironment('dart.vm.product')) {
      return BuildMode.Release;
    }

    var result = BuildMode.Profile;

    assert(() {
      result = BuildMode.Debug;
      return true;
    }());

    return result;
  }

  static Future<AndroidDeviceInfo> androidDeviceInfo() => DeviceInfoPlugin().androidInfo;

  static Future<IosDeviceInfo> iosDeviceInfo() => DeviceInfoPlugin().iosInfo;
}
