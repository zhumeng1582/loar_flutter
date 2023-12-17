import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_bmflocation/flutter_bmflocation.dart';
import 'package:loar_flutter/common/im_data.dart';

final locationMapProvider =
    ChangeNotifierProvider<LocationMapNotifier>((ref) => LocationMapNotifier());

class LocationMapNotifier extends ChangeNotifier {
  final LocationFlutterPlugin _locationPlugin = LocationFlutterPlugin();
  final BaiduLocationIOSOption _iosOption =
      BaiduLocationIOSOption(coordType: BMFLocationCoordType.bd09ll);
  final BaiduLocationAndroidOption _androidOption =
      BaiduLocationAndroidOption(coordType: BMFLocationCoordType.bd09ll);
  final LocationFlutterPlugin _myLocPlugin = LocationFlutterPlugin();

  void _setLocOption() {
    _androidOption.setScanspan(1000); // 设置发起定位请求时间间隔
    Map androidMap = _androidOption.getMap();
    Map iosMap = _iosOption.getMap();
    _locationPlugin.prepareLoc(androidMap, iosMap); //ios和安卓定位设置
  }

  void location() {
    _myLocPlugin.setAgreePrivacy(true);

    _myLocPlugin.singleLocationCallback(callback: (BaiduLocation result) {

      GlobeDataManager.instance
          .setBaiduPosition(result.latitude!, result.longitude!);
    });
    _setLocOption();
    _myLocPlugin.startLocation();
  }
}
