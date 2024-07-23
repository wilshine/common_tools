import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mmkvflutter/mmkv.dart';
import 'src/i18n/lang/en_us.dart';
import 'src/i18n/lang/zh_cn.dart';
import 'package:common_tools/common_tools.dart';

import 'common_tools_platform_interface.dart';

/// An implementation of [XpToolPlatform] that uses method channels.
class MethodChannelXpTool extends XpToolPlatform {
  late MMKV mmkv;

  @override
  Future<void> init({
    String languageCode = 'zh',
  }) async {
    _initI18n(languageCode);
    await _initMMKV();
  }

  Future<void> _initMMKV() async {
    await MMKV.initialize();
    mmkv = MMKV.defaultMMKV();
  }

  Future<void> _initI18n(String languageCode) async {
    Map<String, Map<String, String>> keys = {
      'zh_CN': zhCN,
      'en_US': enUS,
    };
    TranslationUtil.appendTranslations(keys);
  }

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('xp_tool');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  // @override
  // void set(String key, value) {
  //   switch(value.runtimeType) {
  //     case int:
  //       mmkv.encodeInt(key, value);
  //       break;
  //     case double:
  //       mmkv.encodeDouble(key, value);
  //       break;
  //     case String:
  //       mmkv.encodeString(key, value);
  //       break;
  //     case bool:
  //       mmkv.encodeBool(key, value);
  //       break;
  //     case List:
  //       mmkv.encodeBytes(key, value);
  //       break;
  //   }
  // }
  //
  // @override
  // String? getString(String key) {
  //   return mmkv.decodeString(key);
  // }

  @override
  bool setValueWithKey(String key, dynamic data) {
    return mmkv.encodeString(key, jsonEncode(data));
  }

  /// 取值
  @override
  dynamic getValueWithKey(String key) {
    String? value = mmkv.decodeString(key);
    if (value != null) {
      return jsonDecode(value);
    }
    return null;
  }

  /// 删除值
  @override
  void deleteValueWithKey(String key) {
    if (mmkv.containsKey(key)) {
      mmkv.removeValue(key);
    }
  }
}
