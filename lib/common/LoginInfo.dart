import '../page/contacts/contacts_list.dart';

class LoginInfo{
  LoginInfo._();

  static LoginInfo get instance => _getInstance();
  static LoginInfo? _instance;

  static LoginInfo _getInstance() {
    _instance ??= LoginInfo._();
    return _instance!;
  }

  LoginUserInfo? userInfo;
}