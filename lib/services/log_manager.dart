import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'auth_service.dart';

class LogManager {
  static final _loggerMap = <String, AppLog>{};
  static final FirebaseAnalytics analytics = FirebaseAnalytics();
  static final LogManager _instance = LogManager._internal();

  final FirebaseAnalyticsObserver analyticsObserver = FirebaseAnalyticsObserver(analytics: analytics);

  final AppLog _log = getLogger('LogManager');

  LogManager._internal();

  static LogManager get instance => _instance;

  void logException(dynamic x) => _log.logError('Unknown service type exception', x);

  static AppLog getLogger(String name) {
    if (_loggerMap.containsKey(name)) {
      return _loggerMap[name];
    }

    final log = AppLog(name: name);
    _loggerMap[name] = log;
    return log;
  }
}

class AppLog {
  final _dateFormat = DateFormat('MMM dd HH:mm:ss');

  final String name;

  AppLog({@required this.name});

  bool logDebug(String msg) {
    assert(_assertPrintLogMessage(_getLogMessage('DEBUG', msg)));
    return true;
  }

  void logWarning(String msg) {
    var logMsg = _getLogMessage('WARN', msg);

    _doLogToFirebase(logMsg, 'log_warn');

    assert(_assertPrintLogMessage(logMsg));
  }

  void logException(dynamic x) => logError(null, x);

  void logError(String msg, [dynamic x]) {
    var errMsg = msg ?? (x?.toString()) ?? 'Unknown Error';

    var logMsg = x == null || msg == null
        ? _getLogMessage('ERROR', errMsg)
        : _getLogMessage('ERROR', 'EXCEPTION::[$x] - [$errMsg]');

    _doLogToFirebase(logMsg, 'log_error');

    assert(_assertPrintLogMessage(logMsg));
  }

  void logAnalytics(String msg, String analyticsEventName) =>
      _doLogToFirebase(_getLogMessage('FIRE', msg), analyticsEventName);

  String _getLogMessage(String level, String msg) =>
      '|${_dateFormat.format(DateTime.now())}| - |$name| - |$level| - |$msg|';

  bool _assertPrintLogMessage(String logMsg) {
    _doPrintMessage(logMsg);
    return true;
  }

  void _doPrintMessage(String logMsg) => print(logMsg);

  void _doLogToFirebase(String logMsg, String analyticsEventName) {
    var logParams = {
      "log_class": name,
      // "log_error": event.errorMessage.length > 100 ? event.errorMessage.substring(0, 99) : event.errorMessage,
      "log_message": logMsg.length > 100 ? logMsg.substring(0, 99) : logMsg,
    };

    var currentAccount = AuthService.instance.currentAccount;

    if (currentAccount != null) {
      logParams['account_id'] = currentAccount.id.toString();
      logParams['account_email'] = currentAccount.email;
    }

    LogManager.analytics.logEvent(
      name: analyticsEventName,
      parameters: logParams,
    );
  }
}
