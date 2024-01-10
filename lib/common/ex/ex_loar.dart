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
}
