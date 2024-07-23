import 'package:flutter/material.dart';

/// 国际化类
///
/// 使用:
/// 'hello'.t 字符串支持翻译
/// 'hello'.tParams({'month': 'xxxx'})  如果字符串中有占位符，你的翻译文件这样写：{'hello': '你好  @month',}
/// 'world'.tArgs(['yyyy'])   也可以使用这种方式 {'world': '世界 %s',}
///
class TranslationUtil {
  /// 国际化初始化
  ///
  /// [defaultLocale] 默认语言
  /// [keys]  翻译文本
  ///
  static void init(Locale defaultLocale, Map<String, Map<String, String>> keys) {
    _LocalesIntl.instance.locale = defaultLocale;
    // _LocalesIntl.instance.fallbackLocale = fallbackLocal;
    _LocalesIntl.instance.addTranslations(keys);
  }

  /// 返回当前选中的语言
  static Locale get defaultLocale => _LocalesIntl.instance.locale;

  /// 添加翻译文本
  static void appendTranslations(Map<String, Map<String, String>> keys) {
    _LocalesIntl.instance.appendTranslations(keys);
  }
  /// 支持的语言
  static List<Locale> get supportedLocales => const [
    Locale('zh', 'CN'),
    Locale('en', 'US'),
  ];

  /// 切换语言
  ///
  /// [languageCode] 语言代码
  /// [countryCode] 国家代码
  /// 比如：
  /// changeLanguage('zh', "CN") 切换到中文
  /// changeLanguage('en', "US") 切换到英文
  static void changeLanguage(String languageCode, String? countryCode) {
    var locale = Locale(languageCode, countryCode);
    _LocalesIntl.instance.locale = locale;
    WidgetsBinding.instance?.performReassemble();
  }
}


class _IntlHost {
  Locale? locale;

  Locale? fallbackLocale;

  Map<String, Map<String, String>> translations = {};
}

class _LocalesIntl {
  static final _intlHost = _IntlHost();

  Locale? get locale => _intlHost.locale;

  Locale? get fallbackLocale => _intlHost.fallbackLocale;

  set locale(Locale? newLocale) => _intlHost.locale = newLocale;

  set fallbackLocale(Locale? newLocale) => _intlHost.fallbackLocale = newLocale;

  Map<String, Map<String, String>> get translations => _intlHost.translations;

  static _LocalesIntl? _instance;

  static get instance {
    _instance ??= _LocalesIntl._();
    return _instance;
  }

  _LocalesIntl._();

  void addTranslations(Map<String, Map<String, String>> tr) {
    translations.addAll(tr);
  }

  void clearTranslations() {
    translations.clear();
  }

  void appendTranslations(Map<String, Map<String, String>> tr) {
    tr.forEach((key, map) {
      if (translations.containsKey(key)) {
        translations[key]!.addAll(map);
      } else {
        translations[key] = map;
      }
    });
  }
}

extension TransEx on String {
  bool get _fullLocaleAndKey {
    return _LocalesIntl.instance.translations
        .containsKey("${_LocalesIntl.instance.locale!.languageCode}_${_LocalesIntl.instance.locale!.countryCode}") &&
        _LocalesIntl.instance.translations["${_LocalesIntl.instance.locale!.languageCode}_${_LocalesIntl.instance.locale!.countryCode}"]!
            .containsKey(this);
  }

  Map<String, String>? get _getSimilarLanguageTranslation {
    final translationsWithNoCountry = _LocalesIntl.instance.translations.map((key, value) => MapEntry(key.split("_").first, value));
    final containsKey = translationsWithNoCountry.containsKey(_LocalesIntl.instance.locale!.languageCode.split("_").first);

    if (!containsKey) {
      return null;
    }

    return translationsWithNoCountry[_LocalesIntl.instance.locale!.languageCode.split("_").first];
  }

  String get t {
    if (_LocalesIntl.instance.locale?.languageCode == null) return this;
    if (_fullLocaleAndKey) {
      return _LocalesIntl
          .instance.translations["${_LocalesIntl.instance.locale!.languageCode}_${_LocalesIntl.instance.locale!.countryCode}"]![this]!;
    }
    final similarTranslation = _getSimilarLanguageTranslation;
    if (similarTranslation != null && similarTranslation.containsKey(this)) {
      return similarTranslation[this]!;
    } else if (_LocalesIntl.instance.fallbackLocale != null) {
      final fallback = _LocalesIntl.instance.fallbackLocale!;
      final key = "${fallback.languageCode}_${fallback.countryCode}";

      if (_LocalesIntl.instance.translations.containsKey(key) && _LocalesIntl.instance.translations[key]!.containsKey(this)) {
        return _LocalesIntl.instance.translations[key]![this]!;
      }
      if (_LocalesIntl.instance.translations.containsKey(fallback.languageCode) &&
          _LocalesIntl.instance.translations[fallback.languageCode]!.containsKey(this)) {
        return _LocalesIntl.instance.translations[fallback.languageCode]![this]!;
      }
      return this;
    } else {
      return this;
    }
  }

  String tArgs([List<String> args = const []]) {
    var key = t;
    if (args.isNotEmpty) {
      for (final arg in args) {
        key = key.replaceFirst(RegExp(r'%s'), arg.toString());
      }
    }
    return key;
  }


  String tParams([Map<String, String> params = const {}]) {
    var trans = t;
    if (params.isNotEmpty) {
      params.forEach((key, value) {
        trans = trans.replaceAll('@$key', value);
      });
    }
    return trans;
  }

}
