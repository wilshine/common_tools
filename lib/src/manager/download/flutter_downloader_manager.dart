import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:common_tools/src/file_util.dart';
import 'package:common_tools/src/manager/download/download_manager.dart';
import 'package:common_tools/common_tools.dart';

/// flutter_downloader实现
///
/// 主页地址：https://pub.dev/packages/flutter_downloader
class FlutterDownloaderManager extends DownloadManager {
  static const String _portName = 'downloader_send_port';

  Map<String, Map<String, Function>> callbacks = {};
  final ReceivePort _receivePort = ReceivePort();

  static void callback(String id, int status, int progress) {
    final SendPort? sendPort = IsolateNameServer.lookupPortByName(_portName);
    sendPort?.send([id, status, progress]);
  }

  @override
  Future<void> init() async {
    await FlutterDownloader.initialize();
    FlutterDownloader.registerCallback(callback);
    return super.init();
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
    // final String path = await DeviceUtil.getDownloadPath();
    String? taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: path,
      fileName: fileName,
    );

    Completer<int> completer = Completer();

    if (taskId == null) {
      onFail?.call();
      return DownloadManager.failed;
    }

    onReady?.call(taskId!);

    callbacks[taskId!] = {};
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
    callbacks.remove(id.toString());
    return FlutterDownloader.remove(taskId: id.toString());
  }

  @override
  Future<void> removeAllTask() async {
    for (var element in callbacks.keys) {
      FlutterDownloader.remove(taskId: element);
    }
    callbacks.clear();
  }
}
