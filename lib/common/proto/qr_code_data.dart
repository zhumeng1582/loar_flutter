import 'package:im_flutter_sdk/im_flutter_sdk.dart';

class QrCodeData {
  EMUserInfo? userInfo;
  EMChatRoom? room;

  QrCodeData({this.userInfo, this.room});

  toJson() {
    return {
      'userInfo': userInfo?.toJson(),
      'room': room?.toJson(),
    };
  }
}
