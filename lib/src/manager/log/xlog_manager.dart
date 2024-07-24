import 'package:flutter/foundation.dart';
import 'package:flutter_xlog/flutter_xlog.dart';

import 'log_manager.dart';

class XLogManager extends LogManager {
  @override
  Future<void> init({required String cacheDir,
    required String logDir,}) async {
    await XLog.open(XLogConfig(cacheDir: cacheDir, logDir: logDir));
  }

  @override
  void debug(String tag, dynamic msg) {
    if (kDebugMode) {
      print(msg.toString());
    } else {
      XLog.d(tag, msg);
    }
  }

  @override
  void info(String tag, dynamic msg) {
    if (kDebugMode) {
      print(msg.toString());
    } else {
      XLog.i(tag, msg);
    }
  }

  @override
  void warning(String tag, dynamic msg) {
    if (kDebugMode) {
      print(msg.toString());
    } else {
      XLog.w(tag, msg);
    }
  }

  @override
  void error(String tag, dynamic msg) {
    if (kDebugMode) {
      print(msg.toString());
    } else {
      XLog.e(tag, msg);
    }
  }
}
