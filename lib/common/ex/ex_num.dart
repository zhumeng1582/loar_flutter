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
