import 'package:im_flutter_sdk/im_flutter_sdk.dart';


extension ExEMConversation on EMConversation {
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["type"] = conversationTypeToInt(type);
    data["convId"] = id;
    data["isThread"] = isChatThread;
    return data;
  }
}

int conversationTypeToInt(EMConversationType? type) {
  int ret = 0;
  if (type == null) return ret;
  switch (type) {
    case EMConversationType.Chat:
      ret = 0;
      break;
    case EMConversationType.GroupChat:
      ret = 1;
      break;
    case EMConversationType.ChatRoom:
      ret = 2;
      break;
  }
  return ret;
}