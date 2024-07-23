import 'package:permission_handler/permission_handler.dart';

import 'permission_handler_manager.dart';

/// 权限管理器
abstract class PermissionManager {
  static PermissionManager _instance = PermissionHandlerManager();

  static PermissionManager get instance => _instance;

  static set instance(PermissionManager instance) {
    print('');
    _instance = instance;
  }

  /// 请求权限
  /// [type] 权限码，参考#PermissionCode
  Future<bool> requestPermission(int permissionCode) async {
    throw UnimplementedError('requestPermission() has not been implemented.');
  }

  /// 是否拥有该权限
  Future<bool> isGranted(int permissionCode) async {
    throw UnimplementedError('isGranted() has not been implemented.');
  }

  ///打开设置面板
  ///
  /// 返回 [true] 如果设置页面可以打开, 否则 [false].
  Future<bool> openSettings() async {
    throw UnimplementedError('openSettings() has not been implemented.');
  }
}



/// 权限码
class PermissionCode {
  /// 日历
  /// Android: Calendar
  /// iOS: Calendar (Events)
  static int get calendar => Permission.calendar.value;

  /// 相机
  /// Android: Camera
  /// iOS: Photos (Camera Roll and Camera)
  static int get camera => Permission.camera.value;

  /// 通讯录
  /// Android: Contacts
  /// iOS: AddressBook
  static int get contacts => Permission.contacts.value;

  /// 麦克风
  /// Android: Microphone
  /// iOS: Microphone
  static int get microphone => Permission.microphone.value;

  /// 相册权限
  /// When running on Android T and above: Read image files from external storage
  /// When running on Android < T: Nothing
  /// iOS: Photos
  /// iOS 14+ read & write access level
  static int get photos => Permission.photos.value;

  /// 相册 只允许添加
  /// Android: Nothing
  /// iOS: Photos
  /// iOS 14+ read & write access level
  static int get photosAddOnly => Permission.photosAddOnly.value;

  /// 音乐与视频相关活动以及媒体资料库
  /// Android: None
  /// iOS: MPMediaLibrary
  static int get mediaLibrary => Permission.mediaLibrary.value;

  /// 提醒事项
  /// Android: Nothing
  /// iOS: Reminders
  static int get reminders => Permission.reminders.value;

  ///活动与体能训练记录
  /// Android: Body Sensors
  /// iOS: CoreMotion
  static int get sensors => Permission.sensors.value;

  /// 语音识别
  /// Android: Microphone
  /// iOS: Speech
  static int get speech => Permission.speech.value;

  /// 发送通知
  /// Android: Notification
  /// iOS: Notification
  static int get notification => Permission.notification.value;

  /// 蓝牙
  /// iOS 13 and above: The authorization state of Core Bluetooth manager.
  /// When running < iOS 13 or Android this is always allowed.
  static int get bluetooth => Permission.bluetooth.value;

  /// 跟踪您在其他公司的APP和网站上的活动
  ///Android: Nothing
  ///iOS: Allows user to accept that your app collects data about end users and
  ///shares it with other companies for purposes of tracking across apps and
  ///websites.
  static int get appTrackingTransparency => Permission.appTrackingTransparency.value;

  ///Android: Nothing
  ///iOS: Notifications that override your ringer
  static int get criticalAlerts => Permission.criticalAlerts.value;

  ///位置 可以选择使用App时允许
  /// Android: Fine and Coarse Location
  /// iOS: CoreLocation (Always and WhenInUse)
  static int get location => Permission.location.value;

  ///位置 总是允许
  /// Android:
  ///   When running on Android < Q: Fine and Coarse Location
  ///   When running on Android Q and above: Background Location Permission
  /// iOS: CoreLocation - Always
  ///   When requesting this permission the user needs to grant permission
  ///   for the `locationWhenInUse` permission first, clicking on
  ///   the `Àllow While Using App` option on the popup.
  ///   After allowing the permission the user can request the `locationAlways`
  ///   permission and can click on the `Change To Always Allow` option.
  static int get locationAlways => Permission.locationAlways.value;

  ///位置 使用时允许
  /// Android: Fine and Coarse Location
  /// iOS: CoreLocation - WhenInUse
  static int get locationWhenInUse => Permission.locationWhenInUse.value;

  ///
  /// Android: External Storage
  /// iOS: Access to folders like `Documents` or `Downloads`. Implicitly
  /// granted.
  static int get storage => Permission.storage.value;

  ///外部存储卡权限
  /// Android: Allows an application a broad access to external storage in
  /// scoped storage.
  /// iOS: Nothing
  ///
  /// You should request the Manage External Storage permission only when
  /// your app cannot effectively make use of the more privacy-friendly APIs.
  /// For more information: https://developer.android.com/training/data-storage/manage-all-files
  ///
  /// When the privacy-friendly APIs (i.e. [Storage Access Framework](https://developer.android.com/guide/topics/providers/document-provider)
  /// or the [MediaStore](https://developer.android.com/training/data-storage/shared/media) APIs) is all your app needs the
  /// [PermissionGroup.storage] are the only permissions you need to request.
  ///
  /// If the usage of the Manage External Storage permission is needed,
  /// you have to fill out the Permission Declaration Form upon submitting
  /// your app to the Google Play Store. More details can be found here:
  /// https://support.google.com/googleplay/android-developer/answer/9214102#zippy=
  static int get manageExternalStorage => Permission.manageExternalStorage.value;

  ////////////////////////////////Android
  ///允许显示在其他应用的上层
  static int get systemAlertWindow => Permission.systemAlertWindow.value;

  ///允许安装未知应用
  static int get requestInstallPackages => Permission.requestInstallPackages.value;

  ///勿扰权限
  static int get accessNotificationPolicy => Permission.accessNotificationPolicy.value;

  /// 拨打电话
  /// Android: Phone
  /// iOS: Nothing
  static int get phone => Permission.phone.value;

  ///短信
  /// Android: Sms
  /// iOS: Nothing
  static int get sms => Permission.sms.value;

  late Permission permission;

  /// [code】 对应的权限码
  PermissionCode(int code) {
    permission = Permission.byValue(code);
  }
}
