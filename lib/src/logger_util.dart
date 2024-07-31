import 'dart:io';

import 'package:common_tools/src/manager/log/log_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

/// 日志工具 xlog封装
class Logger {
  static const int levelInfo = 1;
  static const int levelDebug = 2;
  static const int levelWarning = 3;
  static const int levelError = 4;

  /// 输出日志级别
  static int level = levelDebug;

  static String? _cacheDir;
  static String? _logDir;

  static Future<void> init({
    String? cacheDir,
    String? logDir,
    int logLevel = levelDebug,
  }) async {
    level = logLevel;
    if (cacheDir == null) {
      cacheDir = join((await getApplicationDocumentsDirectory()).path, 'xlog/cache');
      final dir = Directory(cacheDir);
      if (!dir.existsSync()) {
        await dir.create(recursive: true);
      }
    }
    if (logDir == null) {
      logDir = join((await getApplicationDocumentsDirectory()).path, 'xlog/log');
      final dir = Directory(logDir);
      if (!dir.existsSync()) {
        await dir.create(recursive: true);
      }
    }
    _cacheDir = cacheDir;
    _logDir = logDir;
    await LogManager.instance.init(cacheDir: cacheDir, logDir: logDir);
  }

  static String? getCacheDir() {
    return _cacheDir;
  }

  static String? getLogDir() {
    return _logDir;
  }

  /// 调试输出
  /// [msg]  日志信息
  /// [module]  模块名
  static void debug(dynamic msg, {String tag = ''}) {
    LogManager.instance.debug(tag, msg);
  }

  static void info(dynamic msg, {String tag = ''}) {
    LogManager.instance.info(tag, msg);
  }

  static void _print(String msg, {String tag = ''}) {
    String txt = '[$tag] ${DateTime.now()}---> $msg';
    if (kDebugMode) {
      print(txt);
    }
  }

  static void warning(String msg, {String tag = ''}) {
    LogManager.instance.warning(tag, msg);
  }

  /// error级别的日志，需要做记录
  static void error(String msg, {String tag = ''}) {
    LogManager.instance.error(tag, msg);
  }
}
