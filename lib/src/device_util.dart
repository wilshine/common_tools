import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;

/// 设备相关工具类
///
///
class DeviceUtil {



  /// 单例模式
  factory DeviceUtil() => _getInstance();
  static DeviceUtil get instance => _getInstance();
  static DeviceUtil? _instance;
  DeviceUtil._internal();
  static DeviceUtil _getInstance() {
    _instance ??= DeviceUtil._internal();
    return _instance!;
  }

  late String deviceId;
  late AndroidDeviceInfo androidDeviceInfo;
  late IosDeviceInfo iosInfo;
  late PackageInfo packageInfo;

  Future<void> init() async {
    packageInfo = await PackageInfo.fromPlatform();
    var deviceInfo = DeviceInfoPlugin();
    if(Platform.isAndroid) {
      androidDeviceInfo = await deviceInfo.androidInfo;
    } else {
      iosInfo = await deviceInfo.iosInfo;
    }
    if (Platform.isIOS) { // import 'dart:io'
      deviceId = iosInfo.identifierForVendor ?? ''; // unique ID on iOS
    } else if(Platform.isAndroid) {
      deviceId = androidDeviceInfo.id!; // unique ID on Android
    }
  }

  String getLanguageCode() {
    return ui.window.locale.languageCode;
  }

  /// 沉浸式设置
  static void immersionSetting() {
    if (Platform.isAndroid) {
      // 白色沉浸式状态栏颜色  白色文字
      // SystemUiOverlayStyle light = const SystemUiOverlayStyle(
      //   systemNavigationBarColor: Color(0xFF000000),
      //   systemNavigationBarDividerColor: null,
      //
      //   /// 注意安卓要想实现沉浸式的状态栏 需要底部设置透明色
      //   statusBarColor: Colors.transparent,
      //   systemNavigationBarIconBrightness: Brightness.light,
      //   statusBarIconBrightness: Brightness.light,
      //   statusBarBrightness: Brightness.dark,
      // );

      // 黑色沉浸式状态栏颜色 黑色文字
      SystemUiOverlayStyle dark = const SystemUiOverlayStyle(
        // systemNavigationBarColor: Color(0xFF000000),
        systemNavigationBarDividerColor: null,

        /// 注意安卓要想实现沉浸式的状态栏 需要底部设置透明色
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      );

      SystemChrome.setSystemUIOverlayStyle(dark);
    } else {
      SystemUiOverlayStyle dark = const SystemUiOverlayStyle(
        // systemNavigationBarColor: Color(0xFF000000),
        systemNavigationBarDividerColor: null,

        /// 注意安卓要想实现沉浸式的状态栏 需要底部设置透明色
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      );

      SystemChrome.setSystemUIOverlayStyle(dark);
    }
  }

  static bool isSystemStatusBarShowing = true;

  static void showSystemTitlebarUI() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    // isSystemStatusBarShowing = true;
  }

  static void hideSystemTitlebarUI() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);//隐藏状态栏，底部按钮栏
    // isSystemStatusBarShowing = false;
  }

  /// 设置横屏
  static void setLandscape() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  /// 设置竖屏
  static void setPortrait() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  /// 是不是ipad
  Future<bool> isIpad() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo info = await deviceInfo.iosInfo;
    return Future(() => info.utsname.machine?.toLowerCase().contains("ipad") ?? false);
  }

  /// 返回设备唯一ID 支持Android、iOS
  Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      return Future.value(androidDeviceInfo.id);
    } else if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      return Future.value(iosDeviceInfo.identifierForVendor);
    }
    return Future.value('');
  }

  /// 临时目录
  /// /data/user/9/com.ws.scepter/cache
  /// Android为getCacheDir
  /// iOS为NSCachesDirectory
  static Future<String> getTempDir() async {
    var directory = await getTemporaryDirectory();
    return Future.value(directory.path);
  }

  /// 支持文件目录
  /// /data/user/0/com.ws.scepter/files
  /// Android为getFilesDir
  /// iOS为NSApplicationSupportDirectory
  static Future<String> getAppSupportDir() async {
    var directory = await getApplicationSupportDirectory();
    return Future(() => directory.path);
  }

  /// 应用程序可以访问定级存储的目录路径
  /// 只在Android中可用，iOS会抛出异常
  /// 对应为getExternalFilesDir
  /// /storage/emulated/0/Android/data/com.ws/files
  static Future<String> getExternalStorageDir() async {
    var directory = await getExternalStorageDirectory();
    return Future.value(directory?.path);
  }

  /// 外部缓存目录集合，仅用于Android
  /// 对应 getExternalCacheDirs或getExternalCacheDir(sdk<19)
  /// [Directory: '/storage/emulated/0/Android/data/com.ws/cache']
  static Future<List> getExternalCacheDirs() async {
    var directory = await getExternalCacheDirectories();
    return Future.value(directory?.toList());
  }

  /// 可以存储应用程序特定数据的目录的路径。 这些路径通常位于外部存储（如单独的分区或SD卡）上。
  /// 由于此功能仅在Android上可用
  /// [Directory: '/storage/emulated/0/Android/data/com.ws/files']
  static Future<List> getExternalStorageDirs() async {
    if (Platform.isAndroid) {
      var directory = await getExternalStorageDirectories();
      return Future.value(directory?.toList());
    } else {
      throw 'error';
    }
  }

  /// 获取可存储的本地地址
  static Future<String> getLocalPath() async {
    final Directory dir = Platform.isAndroid
        ? await getExternalStorageDirectory() ?? await getTemporaryDirectory()
        : await getTemporaryDirectory();
    return dir.path;
  }

  /// 获取下载文件的地址
  static Future<String> getDownloadPath() async {
    final downloadPath = (await getLocalPath()) + '/Download';
    final dir = Directory(downloadPath);
    final exists = await dir.exists();
    if (!exists) {
      dir.create();
    }
    return dir.path;
  }

  static void test() {
    // getTempDir().then((value) => print(value));
    // getAppSupportDir().then((value) => print(value));
    // getExternalStorageDir().then((value) => print(value));
    // getExternalCacheDirs().then((value) => print(value));
    // getExternalStorageDirs().then((value) => print(value));
  }


  /// 白色文字
  static void lightStatusTheme() {
    SystemUiOverlayStyle dark = const SystemUiOverlayStyle(
      // systemNavigationBarColor: Color(0xFF000000),
      systemNavigationBarDividerColor: null,
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    );
    SystemChrome.setSystemUIOverlayStyle(dark);
  }

  /// 黑色文字
  static void dartStatusTheme() {
    SystemUiOverlayStyle dark = const SystemUiOverlayStyle(
      // systemNavigationBarColor: Color(0xFF000000),
      systemNavigationBarDividerColor: null,
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(dark);
  }
}
