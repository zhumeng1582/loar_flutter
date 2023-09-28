
import 'dart:ui';

import 'ex_color.dart';

extension ExString on String {
  /// 16进制颜色
  Color get toColor {
    return HexColor(this);
  }
}
