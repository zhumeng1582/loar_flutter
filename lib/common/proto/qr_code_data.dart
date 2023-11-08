import 'package:im_flutter_sdk/im_flutter_sdk.dart';

class QrCodeData {
  EMUserInfo? userInfo;
  EMChatRoom? room;

  QrCodeData({this.userInfo, this.room});

  QrCodeData.fromJson(dynamic json) {
    if (json["userInfo"] != null) {
      userInfo = EMUserInfo.fromJson(json["userInfo"]);
    }
    if (json["room"] != null) {
      room = EMChatRoom.fromJson(json["room"]);
    }
  }

  toJson() {
    return {
      'userInfo': userInfo?.toJson(),
      'room': room?.toJson(),
    };
  }
}
