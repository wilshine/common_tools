import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:open_file_plus/open_file_plus.dart';

/// 文件工具类
class FileUtil {
  /// 保存文件
  static void saveFile(dynamic data, String savePath) async {
    File file = File(savePath);
    if (!file.existsSync()) {
      file.createSync();
    }

    //写入文件
    File file1 = await file.writeAsString(data);
    if (file1.existsSync()) {
    }
  }

  static Future<String?> readFile(String savePath) async {
    File file = File(savePath);
    if (await file.exists()) {
      return await file.readAsString();
    }
    return null;
  }

  /// 加载应用内的文本文件
  static Future<String> loadAssetText(String path) async {
    return await rootBundle.loadString(path);
  }

  /// 打开文件
  ///
  /// 使用https://github.com/crazecoder/open_file
  static Future<OpenResult> openFile(String filePath) {
    return OpenFile.open(filePath);
  }

  /// 判断文件是否存在，只能判断系统中的文件目录，应用内的assets/xxx等
  static Future<bool> exists(String path) async {
    return await File(path).exists();
  }

  /// 删除文件
  ///
  /// [filePath] 文件路径
  static Future<bool> deleteFile(String filePath) async {
    File file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
    return await file.exists();
  }

  /// 删除文件夹
  static Future<void> deleteDirectory(FileSystemEntity file) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await deleteDirectory(child);
        await child.delete();
      }
    }
  }

  /// 获取文件大小
  /// todo
  static double getFileSize(String filePath) {
    return 0.0;
  }

  /// 重命名
  static File rename(String oldPath, String newPath) {
    return File(oldPath).renameSync(newPath);
  }

  static String getFileName(String filePath) {
    return filePath.split('.')[-1];
  }
}
