import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:loar_flutter/common/map_config.dart';

class MarkerAddAfterMapPage extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<MarkerAddAfterMapPage> {
  static const LatLng defaultPosition = LatLng(39.909187, 116.397451);

  //需要先设置一个空的map赋值给AMapWidget的markers，否则后续无法添加marker
  final Map<String, Marker> _markers = <String, Marker>{};
  LatLng _currentLatLng = defaultPosition;

  //添加一个marker
  void _addMarker() {
    final _markerPosition =
        LatLng(_currentLatLng.latitude, _currentLatLng.longitude + 2 / 1000);
    final Marker marker = Marker(
      position: _markerPosition,
      //使用默认hue的方式设置Marker的图标
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );
    //调用setState触发AMapWidget的更新，从而完成marker的添加
    setState(() {
      _currentLatLng = _markerPosition;
      //将新的marker添加到map里
      _markers[marker.id] = marker;
    });
  }

  void _onLocationChanged(AMapLocation location) {
    print('_onLocationChanged ${location.toJson()}');
  }

  TextButton _createMyFloatButton(String label, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        //文字颜色
        foregroundColor: MaterialStateProperty.all(Colors.white),
        //水波纹颜色
        overlayColor: MaterialStateProperty.all(Colors.blueAccent),
        //背景颜色
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          //设置按下时的背景颜色
          if (states.contains(MaterialState.pressed)) {
            return Colors.blueAccent;
          }
          //默认背景颜色
          return Colors.blue;
        }),
      ),
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AMapWidget amap = AMapWidget(
      apiKey: MapConfig.amapApiKeys,
      compassEnabled: true,
      rotateGesturesEnabled:true,
      tiltGesturesEnabled:true,
      onLocationChanged: _onLocationChanged,
      myLocationStyleOptions: MyLocationStyleOptions(false),

      ///必须正确设置的合规隐私声明，否则SDK不会工作，会造成地图白屏等问题。
      privacyStatement: MapConfig.amapPrivacyStatement,
      // //创建地图时，给marker属性赋值一个空的set，否则后续无法添加marker
      markers: Set<Marker>.of(_markers.values),
    );
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 10,
            child: amap,
          ),
          Expanded(
            flex: 1,
            child: _createMyFloatButton('添加marker', _addMarker),
          ),
        ],
      ),
    );
  }
}
