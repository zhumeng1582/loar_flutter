import 'package:loar_flutter/common/proto/UserInfo.pb.dart';


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
}