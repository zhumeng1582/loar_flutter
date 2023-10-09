
import 'dart:ui';

import 'ex_color.dart';
import 'package:intl/intl.dart';

extension ExString on String {
  /// 16进制颜色
  Color get toColor {
    return HexColor(this);
  }

  String get toYearMonthDayTimeDate {
    var date = DateTime.fromMillisecondsSinceEpoch(int.parse(this));
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  }
}
