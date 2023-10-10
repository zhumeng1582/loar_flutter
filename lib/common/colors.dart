import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:loar_flutter/common/ex/ex_string.dart';

class AppColors {
  static Color commonPrimary = "#FF2196F3".toColor;
  static Color inputBgColor = "#F8F8F8".toColor;
  static Color title = "#000000".toColor;
  static Color get background => "#FFFFFF".toColor;
  static Color get bottomBackground => Colors.grey.shade200;
  static Color disabledTextColor = "#000000".toColor.withOpacity(0.15);
  static Color disableButtonBackgroundColor = "#000000".toColor.withOpacity(0.07);
  static Color get buttonDisableColor => "#000000".toColor.withOpacity(0.08);
  static Color get buttonLoadingColor => "#000000".toColor.withOpacity(0.08);
  static Color get buttonDisableTextColor => "#000000".toColor.withOpacity(0.15);
  static Color get buttonHighlightColor => "#0176D3".toColor.withOpacity(0.3);
  static Color get line => "#000000".toColor.withOpacity(0.08);

}
