import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:xp_xlog/xp_xlog.dart';

import 'log_manager.dart';

class XLogManager extends LogManager {
  @override
  Future<void> init(String prefix) async {
    final logPath = join((await getApplicationDocumentsDirectory()).path, 'xlog');
    final file = Directory(logPath);
    bool isExists = await file.exists();
    if (!isExists) {
      await file.create();
    }
    XpXlog.initXlog(logPath, prefix, '');
    XpXlog.flush();
  }

  @override
  void debug(String tag, dynamic msg) {
    if (kDebugMode) {
      print(msg.toString());
    } else {
      XpXlog.debug(tag, msg);
    }
  }

  @override
  void info(String tag, dynamic msg) {
    if (kDebugMode) {
      print(msg.toString());
    } else {
      XpXlog.info(tag, msg);
    }
  }

  @override
  void warning(String tag, dynamic msg) {
    if (kDebugMode) {
      print(msg.toString());
    } else {
      XpXlog.warning(tag, msg);
    }
  }

  @override
  void error(String tag, dynamic msg) {
    if (kDebugMode) {
      print(msg.toString());
    } else {
      XpXlog.error(tag, msg);
    }
  }
}
