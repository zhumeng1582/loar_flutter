import 'dart:math';
import 'dart:typed_data';

import '../proto/LoarProto.pb.dart';

extension ExLoarMessage on LoarMessage {
  bool get isText {
    return msgType == MsgType.CHAT_TEXT ||
        msgType == MsgType.GROUP_TEXT ||
        msgType == MsgType.BROARDCAST_TEXT;
  }

  bool get isLocation {
    return msgType == MsgType.CHAT_LOCATION ||
        msgType == MsgType.GROUP_LOCATION ||
        msgType == MsgType.BROARDCAST_LOCATION;
  }

  bool get isChat {
    return msgType == MsgType.CHAT_TEXT || msgType == MsgType.CHAT_LOCATION;
  }

  bool get isGroup {
    return msgType == MsgType.GROUP_TEXT || msgType == MsgType.GROUP_LOCATION;
  }

  String get senderPhone {
    return bytesToString(Uint8List.fromList(sender));
  }

  String get getConversationId {
    return bytesToString(Uint8List.fromList(conversationId));
  }

  String get repeaterPhone {
    return bytesToString(Uint8List.fromList(repeater));
  }

  // 将字符串转换为字节列表
  static Uint8List stringToBytes(String numberString) {
    int length = numberString.length;
    // 确保长度为偶数，如果不是，前面补一个'0'
    String adjustedString = length % 2 != 0 ? '0' + numberString : numberString;
    // 计算字节列表的长度
    int bytesLength = adjustedString.length ~/ 2;
    Uint8List bytes = Uint8List(bytesLength);
    for (int i = 0; i < bytesLength; i++) {
      // 每两个数字字符合并为一个字节
      int firstDigit = int.parse(adjustedString[i * 2]);
      int secondDigit = int.parse(adjustedString[i * 2 + 1]);
      bytes[i] = (firstDigit << 4) + secondDigit;
    }
    return bytes;
  }

// 将字节列表转换回字符串
  static String bytesToString(Uint8List bytes) {
    var buffer = StringBuffer();
    for (int byte in bytes) {
      // 分解每个字节回两个数字字符
      int firstDigit = (byte & 0xF0) >> 4;
      int secondDigit = byte & 0x0F;
      if (buffer.isEmpty && firstDigit == 0) {
        // 如果第一个数字字符是'0'，跳过它
        buffer.write(secondDigit.toString());
      } else {
        buffer.write(firstDigit.toString());
        buffer.write(secondDigit.toString());
      }
    }
    return buffer.toString();
  }
}
