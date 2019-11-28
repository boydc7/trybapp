import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trybapp/services/device_storage.dart';
import 'package:trybapp/utils/enum_utils.dart';

class PermissionService {
  static PermissionService _permissionService;

  PermissionService._internal();

  factory PermissionService.instance() {
    return _permissionService ??= PermissionService._internal();
  }

  Future<bool> havePermission({@required PermissionGroup permission}) async {
    var permissionStatus = await PermissionHandler().checkPermissionStatus(PermissionGroup.contacts);

    return permissionStatus == PermissionStatus.granted || permissionStatus == PermissionStatus.restricted;
  }

  Future<bool> requestPermission({@required PermissionGroup permission, bool force = false}) async {
    var storageKey = 'tryb_requested_${Enums.toEnumName(permission.toString())}';

    if (await havePermission(permission: permission)) {
      return true;
    }

    var haveRequestedPermission = await DeviceStorage.getBool(storageKey);

    if (haveRequestedPermission && !force) {
      return false;
    }

    var requestResults = await PermissionHandler().requestPermissions([permission]);

    if (requestResults == null || !requestResults.containsKey(permission)) {
      return false;
    }

    await DeviceStorage.setBool(storageKey, true);

    return requestResults[permission] == PermissionStatus.granted ||
        requestResults[permission] == PermissionStatus.restricted;
  }

  Future<bool> openAppSettings() async {
    return await PermissionHandler().openAppSettings();
  }
}
