import 'dart:async';

import 'package:flutter/services.dart';

import 'download_manager.dart';

/// 使用Android原生DownloadManager下载
class AndroidDownloadManager extends DownloadManager {
  static const _channel = MethodChannel('xp_tool_downloader');

  Map<String, Map<String, Function>> callbacks = {};

  @override
  Future<void> init() async {
    _channel.setMethodCallHandler((MethodCall call) async {
      String taskId = call.arguments['taskId'];
      switch (call.method) {
        case 'onComplete':
          callbacks[taskId]!['onComplete']!();
          break;
        case 'onProgress':
          callbacks[taskId]!['onProgress']!(call.arguments['progress']);
          break;
        case 'onFail':
          callbacks[taskId]!['onFail']!();
          break;
      }
    });
  }

  @override
  Future<int> download(
    String url,
    String path,
    String fileName, {
    Function(Object id)? onReady,
    Function(double percent)? onProgress,
    Function()? onFail,
    Function()? onSuccess,
  }) async {
    Object? taskId = await _channel.invokeMethod<String>('enqueue', {
      'url': url,
      'saved_dir': path,
      'file_name': fileName,
    });

    if (taskId == null) {
      onFail?.call();
      return DownloadManager.failed;
    }

    Completer<int> completer = Completer();

    callbacks[taskId!.toString()] = {};
    callbacks[taskId]!['onComplete'] = () {
      onSuccess?.call();

      if (!completer.isCompleted) {
        completer.complete(DownloadManager.completed);
      } else {
        print("completer has already been completed");
      }

      callbacks.remove(taskId);
    };

    callbacks[taskId]!['onFail'] = () {
      onFail?.call();

      if (!completer.isCompleted) {
        completer.completeError(DownloadManager.failed);
      }

      callbacks.remove(taskId);
    };

    callbacks[taskId]!['onProgress'] = (double progress) {
      onProgress?.call(progress);
    };

    return completer.future;
  }

  @override
  Future<void> cancelTaskById(Object id) async {
    Object? taskId = await _channel.invokeMethod<String>('cancel', {'id': id});
  }

  @override
  Future<void> removeAllTask() async {}
}
