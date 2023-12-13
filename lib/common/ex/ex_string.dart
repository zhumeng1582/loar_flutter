
import 'dart:ui';

import 'package:loar_flutter/common/ex/ex_num.dart';

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

  String get toTimeHHmm {
    var date = DateTime.fromMillisecondsSinceEpoch(int.parse(this));
    return DateFormat('HH:mm').format(date);
  }

  String get formatChatTime {
    return int.parse(this).formatChatTime;
  }

  bool get isGroup {
    return !startsWith("user");
  }

  int get toInt {
    if (isEmpty) {
      return 0;
    }
    return int.parse(this);
  }

  double get toDouble {
    if (isEmpty) {
      return 0;
    }
    return double.parse(this);
  }
}
