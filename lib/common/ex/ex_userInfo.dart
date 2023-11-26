import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';

import '../proto/LoarProto.pb.dart';

class OnlineUser {
  String? userId = "";
  BMFCoordinate? position;
  int? lastTime;

  OnlineUser(this.userId, LoarMessage loarMessage) {
    if (loarMessage.longitude != 0 && loarMessage.latitude != 0) {
      position = BMFCoordinate(loarMessage.latitude, loarMessage.longitude);
    } else {
      position = null;
    }
    lastTime = DateTime.now().millisecondsSinceEpoch;
  }

  OnlineUser.create(this.userId, double latitude, double longitude) {
    position = BMFCoordinate(latitude, longitude);
    lastTime = DateTime.now().millisecondsSinceEpoch;
  }

  bool isOnline() {
    return (((lastTime ?? 0) + 6000) >= DateTime.now().millisecondsSinceEpoch);
  }
}

extension ExBMFCoordinate on BMFCoordinate {
  static String userId = "";
}

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
