import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_bmflocation/flutter_bmflocation.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/im_data.dart';

class BaiduMapPage extends StatefulWidget {
  const BaiduMapPage({super.key});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<BaiduMapPage> {
  late BMFMapController _controller;
  final LocationFlutterPlugin _myLocPlugin = LocationFlutterPlugin();
  final LocationFlutterPlugin _locationPlugin = LocationFlutterPlugin();

  //ios定位参数设置
  BaiduLocationIOSOption iosOption =
  BaiduLocationIOSOption(coordType: BMFLocationCoordType.bd09ll);
  BaiduLocationAndroidOption androidOption =
  BaiduLocationAndroidOption(coordType: BMFLocationCoordType.bd09ll);
  @override
  void initState() {
    initBaiDu();
    super.initState();
  }
  initBaiDu() {
    _myLocPlugin.setAgreePrivacy(true);
    /* 接受定位回调 */
    _myLocPlugin.singleLocationCallback(callback: (BaiduLocation result) {
      debugPrint("---------->setPhonePosition");
      GlobeDataManager.instance
          .setPhonePosition(result.latitude!, result.longitude!);
    });

    requestPermission()
        .then((value) => {_setLocOption(), _myLocPlugin.startLocation()});
  }
  //  申请权限
  Future<bool> requestPermission() async {
    // 申请权限
    final status = await Permission.location.request();
    if (status.isGranted) {
      print("定位权限申请通过");
      return true;
    } else {
      print("定位权限申请不通过");
      return false;
    }
  }

  void _setLocOption() {
    androidOption.setCoorType("bd09ll"); // 设置返回的位置坐标系类型
    androidOption.setIsNeedAltitude(true); // 设置是否需要返回海拔高度信息
    androidOption.setIsNeedAddress(true); // 设置是否需要返回地址信息
    androidOption.setIsNeedLocationPoiList(true); // 设置是否需要返回周边poi信息
    androidOption.setIsNeedNewVersionRgc(true); // 设置是否需要返回最新版本rgc信息
    androidOption.setIsNeedLocationDescribe(true); // 设置是否需要返回位置描述
    androidOption.setOpenGps(true); // 设置是否需要使用gps
    androidOption.setLocationMode(BMFLocationMode.hightAccuracy); // 设置定位模式
    androidOption.setScanspan(1000); // 设置发起定位请求时间间隔
    Map androidMap = androidOption.getMap();
    Map iosMap = iosOption.getMap();
    _locationPlugin.prepareLoc(androidMap, iosMap); //ios和安卓定位设置
    debugPrint("---------->_setLocOption");
  }


  void onBMFMapCreated(BMFMapController controller) {
    _controller = controller;
    _controller.showUserLocation(true);
    /// 设置移动结束回调
    _controller.setMapRegionDidChangeWithReasonCallback(
        callback: (status, reason) =>
            {print(('mapDidLoad-${status}-${reason}'))});

    /// 地图加载回调
    _controller.setMapDidLoadCallback(callback: () {
      print('1MapDidLoad-地图加载回调');
    });
    _controller.setMapDidFinishedRenderCallback(callback: (bool success) {
      print('1MapDidFinishedRenderd-地图绘制完成');
      // _controller.addMarker(marker1);
    });
    _controller.setMapOnClickedMapBlankCallback(
        callback: (BMFCoordinate coordinate) {
      print('1${coordinate.toMap()}');
    });
  }

  /// 设置地图0参数
  BMFMapOptions initMapOptions0() {
    BMFMapOptions mapOptions = BMFMapOptions(
        mapType: BMFMapType.Standard,
        zoomLevel: 15,
        maxZoomLevel: 21,
        minZoomLevel: 4,
        mapPadding: BMFEdgeInsets(top: 0, left: 50, right: 50, bottom: 0),
        logoPosition: BMFLogoPosition.LeftBottom,
        center: GlobeDataManager.instance.getPosition());
    return mapOptions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("蜂窝"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: BMFMapWidget(
          onBMFMapCreated: (controller) {
            onBMFMapCreated(controller);
          },
          mapOptions: initMapOptions0(),
        ),
      ),
    );
  }
}
