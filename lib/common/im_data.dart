import 'dart:async';

import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'dart:io' show InternetAddress, SocketException;

import 'package:loar_flutter/common/util/im_cache.dart';

class ImDataManager {
  ImDataManager._();

  static ImDataManager get instance => _getInstance();
  static ImDataManager? _instance;

  var isConnectionSuccessful = false;

  static ImDataManager _getInstance() {
    _instance ??= ImDataManager._();
    _instance?._getCacheMe();
    return _instance!;
  }

  EMUserInfo? me;

  _getCacheMe() async {
    var cache = await ImCache.getMe();
    if (cache != null) {
      me = cache;
    }
  }

  getUserInfo() async {
    if (isConnectionSuccessful) {
      try {
        var value = await EMClient.getInstance.userInfoManager.fetchOwnInfo();
        if (value != null) {
          me = value;
          ImCache.saveMe(value);
        }
      } on EMError catch (e) {
        // 获取当前用户属性失败，返回错误信息。
      }
    } else {
      _getCacheMe();
    }
  }

  tryConnection() {
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      try {
        final response = await InternetAddress.lookup('baidu.com');
        isConnectionSuccessful = response.isNotEmpty;
      } on SocketException catch (e) {
        isConnectionSuccessful = false;
      }
    });
  }
}
