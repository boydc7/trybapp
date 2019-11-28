import 'package:permission_handler/permission_handler.dart';
import 'package:trybapp/services/log_manager.dart';
import 'package:trybapp/services/permission_service.dart';

class ContactSyncService {
  static final AppLog _log = LogManager.getLogger('ContactSyncService');
  static ContactSyncService _instance;

  ContactSyncService._internal();

  factory ContactSyncService.instance() {
    return _instance ??= ContactSyncService._internal();
  }

  Future<void> syncDeviceContacts() async {
    if (!(await PermissionService.instance().havePermission(permission: PermissionGroup.contacts))) {
      _log.logWarning('Call to syncDeviceContacts made without permission to access device contacts');
      return;
    }

    // TODO: Sync contacts...
    //var x = await ContactsService.getContacts();
  }
}
