import 'package:loar_flutter/common/proto/UserInfo.pb.dart';


class GlobalData{
  GlobalData._();

  static GlobalData get instance => _getInstance();
  static GlobalData? _instance;

  static GlobalData _getInstance() {
    _instance ??= GlobalData._();
    return _instance!;
  }
  UserInfo get me =>_userInfo.user;

  late LoginUserInfo _userInfo;

  set userInfo(loginUserInfo){
    _userInfo = loginUserInfo;
  }
}