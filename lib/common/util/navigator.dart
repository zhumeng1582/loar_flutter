import 'package:flutter/material.dart';

class NavigatorHelper {
  /// 当页面位于Flutter栈顶的时候，自动退出Flutter页面，不再依赖外部参数标记
  static void autoPop(BuildContext context) {
    final nav = Navigator.of(context);
    return nav.pop();
  }
}
