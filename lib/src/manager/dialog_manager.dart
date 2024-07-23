import 'package:flutter/material.dart';

/// 弹窗管理器
///
/// 所有的弹窗入口
abstract class DialogManager {
  static DialogManager _instance = _XPDialogManager();

  static DialogManager get instance => _instance;

  static set instance(DialogManager instance) {
    debugPrint('set DialogManager $instance');
    _instance = instance;
  }

  /// 展示弹窗
  ///
  /// [context] 指定context，则在其最近的navigator弹窗
  /// [closeCallback] 关闭弹窗后的回调
  Future<void> show({
    required Widget child,
    BuildContext? context,
    Function()? closeCallback,
  }) async {}

}

class _XPDialogManager extends DialogManager {
  /// 当前所有弹窗
  List currentDialogList = [];

  void removeAllDialog() {}

}
