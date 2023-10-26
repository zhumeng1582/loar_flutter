import 'package:loar_flutter/common/ex/ex_userInfo.dart';
import 'package:loar_flutter/common/proto/index.dart';


class AccountData{
  AccountData._();

  static AccountData get instance => _getInstance();
  static AccountData? _instance;

  static AccountData _getInstance() {
    _instance ??= AccountData._();
    return _instance!;
  }
  UserInfo get me =>_userInfo.user;

  late LoginUserInfo _userInfo;

  set userInfo(loginUserInfo){
    _userInfo = loginUserInfo;
  }

  RoomInfo createRoom() {
    var time = DateTime.now().millisecondsSinceEpoch;
    var room = RoomInfo();
    room.name = "群聊";
    room.id = "room#$time";
    room.creator = AccountData.instance.me;
    room.createtime = "$time";
    return room;
  }

}