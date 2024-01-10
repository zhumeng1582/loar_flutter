import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:loar_flutter/common/blue_tooth.dart';
import 'package:loar_flutter/common/proto/LoarProto.pb.dart';
import 'package:loar_flutter/common/util/im_cache.dart';

import 'loading.dart';

class GlobeDataManager {
  GlobeDataManager._();

  static GlobeDataManager get instance => _getInstance();
  static GlobeDataManager? _instance;

  var isEaseMob = false;
  BMFCoordinate? _position;
  BMFCoordinate? _baiduPosition;

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

  Future<bool> isNetworkAwait() async {
    try {
      ConnectivityResult result = await Connectivity().checkConnectivity();
      return result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet;
    } on PlatformException catch (e) {
      return false;
    }
  }

  updateUserInfo({
    String? nickname,
    String? avatarUrl,
    String? mail,
    int? gender,
    String? sign,
    String? birth,
    String? ext,
  }) async {
    try {
      Loading.show();
      me = await EMClient.getInstance.userInfoManager.updateUserInfo(
          nickname: nickname ?? me?.nickName,
          avatarUrl: avatarUrl ?? me?.avatarUrl,
          mail: mail ?? me?.mail,
          gender: gender ?? me?.gender,
          sign: sign ?? me?.sign,
          birth: birth ?? me?.birth,
          ext: ext ?? me?.ext);

      Loading.dismiss();
      Loading.success("修改成功");
      if (me != null) {
        ImCache.saveMe(me!);
      }
    } on EMError catch (e) {
      Loading.dismiss();

      Loading.error(e.description);
    }
  }

  Future<EMUserInfo?> getOnlineUserInfo() async {
    try {
      return await EMClient.getInstance.userInfoManager.fetchOwnInfo();
    } on EMError catch (e) {
      return null;
    }
  }

  getUserInfo() async {
    try {
      var value = await EMClient.getInstance.userInfoManager.fetchOwnInfo();
      if (value != null) {
        me = value;
        ImCache.saveMe(value);
      } else {
        _getCacheMe();
      }
    } on EMError catch (e) {
      _getCacheMe();
      // 获取当前用户属性失败，返回错误信息。
    }
  }

  tryConnection() async {
    Timer.periodic(const Duration(seconds: 30), (timer) {
      var position = getPosition();
      if (position != null &&
          me != null &&
          BlueToothConnect.instance.messageQueue.isEmpty) {
        LoarMessage value = LoarMessage(
            sender: me?.userId,
            longitude: position.longitude,
            latitude: position.latitude,
            msgType: MsgType.BROARDCAST_LOCATION);
        BlueToothConnect.instance.writeLoraMessage(value);
      }
    });
  }

  setLoarPosition(double latitude, double longitude) {
    _position = BMFCoordinate(latitude, longitude);
  }

  setBaiduPosition(double latitude, double longitude) {
    _baiduPosition = BMFCoordinate(latitude, longitude);
  }

  BMFCoordinate? getPosition() {
    if (_position != null) {
      return _position;
    }
    if (_baiduPosition != null) {
      return _baiduPosition;
    }
    return null;
  }
}
