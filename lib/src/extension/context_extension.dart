import 'package:flutter/widgets.dart';

extension BuildContextExt on BuildContext {

  Size get mediaQuerySize => MediaQuery.of(this).size;

  double get height => mediaQuerySize.height;

  double get width => mediaQuerySize.width;

  /// 当前路由是否是最上面的
  bool get isCurrent => ModalRoute.of(this)?.isCurrent ?? false;
}