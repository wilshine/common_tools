library xp_tool;

import 'package:common_tools/src/manager/download/download_manager.dart';
import 'package:common_tools/common_tools_platform_interface.dart';

export 'src/manager/dialog_manager.dart';
export 'src/color_util.dart';

// export 'src/date_util.dart';
export 'src/device_util.dart';
export 'src/encrypt_util.dart';
export 'src/file_util.dart';
export 'src/list_util.dart';
export 'src/map_util.dart';
export 'src/md5_util.dart';
export 'src/screen_util.dart';
export 'src/string_util.dart';
export 'src/throttle_util.dart';
export 'src/validator_util.dart';
export 'src/extension/context_extension.dart';
export 'src/extension/iterable_extension.dart';
export 'src/extension/string_extension.dart';
export 'src/extension/list_extension.dart';
export 'src/i18n/translation_util.dart';
export 'src/url_util.dart';
export 'common_tools_platform_interface.dart';
export 'src/manager/download/download_manager.dart';
export 'src/manager/permission/permission_manager.dart';
export 'src/logger_util.dart';
export 'src/net/ws_dio_http.dart';

/// 工具库入口 必须先进行初始化
class XPToolManager {
  static XPToolManager get instance => _instance;

  static final XPToolManager _instance = XPToolManager();

  /// 初始化XP Tool库
  ///
  /// [languageCode] 运行语言，对当前库的文本进行国际化支持
  Future<void> init({String languageCode = 'zh'}) async {
    await XpToolPlatform.instance.init(languageCode: 'en');
    await DownloadManager.instance.init();

  }
}
