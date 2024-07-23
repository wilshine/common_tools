import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'common_tools_method_channel.dart';

abstract class XpToolPlatform extends PlatformInterface {
  /// Constructs a XpToolPlatform.
  XpToolPlatform() : super(token: _token);

  static final Object _token = Object();

  static XpToolPlatform _instance = MethodChannelXpTool();

  /// The default instance of [XpToolPlatform] to use.
  ///
  /// Defaults to [MethodChannelXpTool].
  static XpToolPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [XpToolPlatform] when
  /// they register themselves.
  static set instance(XpToolPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  /// 必须先进行初始化
  ///
  /// [languageCode] 初始化语言
  Future<void> init({
    String languageCode = 'zh',
  }) async {}

  /// 设置值 data可以为任意类型
  bool setValueWithKey(String key, dynamic data) {
    throw UnimplementedError();
  }

  /// 取值
  dynamic getValueWithKey(String key) {
    throw UnimplementedError();
  }

  /// 删除值
  void deleteValueWithKey(String key) {
    throw UnimplementedError();
  }
}
