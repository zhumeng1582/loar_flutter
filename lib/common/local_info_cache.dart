import 'package:loar_flutter/common/proto/UserInfo.pb.dart';


class LocalInfoCache{
  LocalInfoCache._();

  static LocalInfoCache get instance => _getInstance();
  static LocalInfoCache? _instance;

  static LocalInfoCache _getInstance() {
    _instance ??= LocalInfoCache._();
    return _instance!;
  }

  late LoginUserInfo? userInfo;

}