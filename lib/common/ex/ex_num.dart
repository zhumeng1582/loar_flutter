import 'package:intl/intl.dart';

extension ExInt on int {
  /// 格式化日期 - dd/MM/yyyy HH:mm:ss
  String get toDayMonthYearTimeDate {
    var date = DateTime.fromMillisecondsSinceEpoch(this);
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(date);
  }

  /// 格式化日期 -  yyyy-MM-dd HH:mm:ss
  String get toYearMonthDayTimeDate {
    var date = DateTime.fromMillisecondsSinceEpoch(this);
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  }

  /// 格式化日期 - dd/MM/yyyy
  String get toDayMonthYearDate {
    var date = DateTime.fromMillisecondsSinceEpoch(this);
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// 格式化日期 HH:mm:ss
  String get toHourMinSecondDate {
    var date = DateTime.fromMillisecondsSinceEpoch(this, isUtc: true);
    return DateFormat('HH:mm:ss').format(date);
  }

  String get toDayMonthDate {
    var date = DateTime.fromMillisecondsSinceEpoch(this);
    return DateFormat('M/dd').format(date);
  }

  String get toDayMonthTimeDate {
    var date = DateTime.fromMillisecondsSinceEpoch(this);
    return DateFormat('MM/dd HH:mm').format(date);
  }

  String get formatChatTime {
    var date = DateTime.fromMillisecondsSinceEpoch(this);
    var now = DateTime.now();
    var formatter = DateFormat('HH:mm');
    if (date.year == now.year && date.month == now.month) {
      if (date.day == now.day) {
        if (date.hour < 6) {
          return '凌晨 ${formatter.format(date)}';
        } else if (date.hour < 12) {
          return '上午 ${formatter.format(date)}';
        } else if (date.hour < 18) {
          return '下午 ${formatter.format(date)}';
        } else {
          return '晚上 ${formatter.format(date)}';
        }
      } else if (date.day == now.day - 1) {
        return '昨天 ${formatter.format(date)}';
      } else {
        formatter = DateFormat('MM月dd日 HH:mm');
        return formatter.format(date);
      }
    } else {
      formatter = DateFormat('YYYY年MM月dd日 HH:mm');
      return formatter.format(date);
    }
  }

  String get getMB {
    double value = toDouble() / 1000000;
    return value.toStringAsFixed(2);
  }
}

extension ExDouble on double {
  String get toFixedString {
    final txt = toString();
    if (txt == 'NaN') {
      return '0';
    }
    return txt;
  }

  static bool fuzzyCompare(double p1, double p2) {
    return (p1 - p2).abs() < 0.00001;
  }

  String get toDistance {
    if (this < 1000) {
      return "${toStringAsFixed(2)}米";
    } else {
      return "${(this / 1000).toStringAsFixed(2)}公里";
    }
  }
}

extension ShowAmountInt on int? {
  String toStringAmount() {
    if (this == null) {
      return "--";
    }
    if (this?.sign == 0) {
      return "--";
    }
    return toString();
  }
}
