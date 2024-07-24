import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'xlog_manager.dart';

/// 日志管理器
///
/// 可自定义具体实现 默认debug环境print，release环境xlog
///
/// 示例：
///
/// Logger logger = Logger.instance().init('XDragon');
/// logger.debug('drive', 'add test drive success');
///
///
abstract class LogManager {
  static LogManager _instance = XLogManager();

  static LogManager get instance => _instance;

  static set instance(LogManager instance) {
    debugPrint('set LogManager $instance');
    _instance = instance;
  }

  Future<void> init({required String cacheDir,
    required String logDir,}) async {
    throw UnimplementedError('init() has not been implemented.');
  }

  void debug(String tag, dynamic msg) {
    throw UnimplementedError('debug() has not been implemented.');
  }

  void info(String tag, dynamic msg) {
    throw UnimplementedError('info() has not been implemented.');
  }

  void warning(String tag, dynamic msg) {
    throw UnimplementedError('warning() has not been implemented.');
  }

  void error(String tag, dynamic msg) {
    throw UnimplementedError('error() has not been implemented.');
  }
}
