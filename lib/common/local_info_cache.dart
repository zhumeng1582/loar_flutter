import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../page/contacts/contacts_list.dart';

class LocalInfoCache{
  LocalInfoCache._();

  static LocalInfoCache get instance => _getInstance();
  static LocalInfoCache? _instance;

  static LocalInfoCache _getInstance() {
    _instance ??= LocalInfoCache._();
    return _instance!;
  }

  late MyUserInfo userInfo;

}