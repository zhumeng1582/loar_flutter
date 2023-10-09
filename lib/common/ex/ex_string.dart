
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
  String get toTimeHHmm {
    var date = DateTime.fromMillisecondsSinceEpoch(int.parse(this));
    return DateFormat('HH:mm').format(date);
  }
  String get formatChatTime{
    try{
      DateTime messageTime = DateTime.fromMillisecondsSinceEpoch(int.parse(this));
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
    }catch(e){
      return "未知时间:$this";
    }
  }
  bool get isGroup{
    return !contains("user");
  }
}
