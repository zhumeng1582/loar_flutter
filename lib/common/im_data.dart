import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'dart:io' show InternetAddress, SocketException;

import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:loar_flutter/common/util/im_cache.dart';

class GlobeDataManager {
  GlobeDataManager._();

  static GlobeDataManager get instance => _getInstance();
  static GlobeDataManager? _instance;

  var isConnectionSuccessful = false;
  BMFCoordinate? position;
  BMFCoordinate? phonePosition;

  static GlobeDataManager _getInstance() {
    _instance ??= GlobeDataManager._();
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

  setLoarPosition(double latitude, double longitude) {
    if (position == null) {
      position = BMFCoordinate(latitude, longitude);
    } else {
      position?.latitude = latitude;
      position?.longitude = longitude;
    }
  }
  setPhonePosition(double latitude, double longitude) {
    if (phonePosition == null) {
      phonePosition = BMFCoordinate(latitude, longitude);
    } else {
      phonePosition?.latitude = latitude;
      phonePosition?.longitude = longitude;
    }
  }
}
