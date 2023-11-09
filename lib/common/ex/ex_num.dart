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
    try {
      DateTime messageTime = DateTime.fromMillisecondsSinceEpoch(this);
      final currentTime = DateTime.now();
      final difference = currentTime.difference(messageTime);

      if (difference.inDays < 1) {
        String hourMinute = DateFormat('HH:mm').format(messageTime);
        String hour = hourMinute.split(':')[0];
        String minute = hourMinute.split(':')[1];

        if (int.parse(hour) < 12) {
          return '上午$hour:$minute';
        } else {
          int pmHour = int.parse(hour) - 12;
          return '下午$pmHour:$minute';
        }
      } else if (difference.inDays < 2) {
        return '昨天';
      } else {
        return DateFormat.yMMMd('zh_CN').format(messageTime);
      }
    } catch (e) {
      return "";
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
