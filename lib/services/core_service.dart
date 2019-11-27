import 'auth_service.dart';
import 'log_manager.dart';

class CoreService {
  static final AppLog _log = LogManager.getLogger('CoreService');
  static final CoreService _instance = CoreService._internal();

  CoreService._internal();

  static CoreService get instance => _instance;

  Future<void> initCore() async {
    try {
      _log.logDebug("Core Service Loaded");

      await AuthService.instance.init();
    } catch (x) {
      _log.logException(x);
      rethrow;
    }
  }
}
