import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/common/ex/ex_im.dart';
import 'package:loar_flutter/common/ex/ex_num.dart';
import 'package:loar_flutter/common/im_data.dart';
import 'package:loar_flutter/common/loading.dart';
import 'package:loar_flutter/common/util/distance.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';
import 'package:loar_flutter/page/home/provider/im_message_provider.dart';
import 'package:map_launcher/map_launcher.dart';

import '../../common/colors.dart';
import '../../common/ex/ex_userInfo.dart';
import '../../common/routers/RouteNames.dart';
import '../../common/util/images.dart';
import '../../widget/common.dart';
import 'model/page_type.dart';

final baiduMapProvider =
    ChangeNotifierProvider<BaiduMapNotifier>((ref) => BaiduMapNotifier());

class BaiduMapNotifier extends ChangeNotifier {
  final Map<String, BMFMarker> _makerList = {};
  double distance = 0;

  clearMaker() {
    distance = 0;
    _makerList.clear();
  }

  BMFCoordinate getOther() {
    BMFCoordinate? other = GlobeDataManager.instance.getPosition();
    _makerList.forEach((key, value) {
      if (key != GlobeDataManager.instance.me?.userId) {
        other = value.position;
      }
    });
    return other ?? BMFCoordinate(30, 102);
  }

  BMFMarker? getMaker(String id) {
    return _makerList[id];
  }

  addMakerList(PageType pageType, BMFMapController controller,
      Map<String, OnlineUser> allOnlineUsers) {
    if (pageType != PageType.nearBy) {
      var mePosition = GlobeDataManager.instance.getPosition();
      if (mePosition != null) {
        BMFMarker marker = BMFMarker.icon(
            position: mePosition,
            title: GlobeDataManager.instance.me?.name,
            identifier: GlobeDataManager.instance.me?.userId,
            icon: AssetsImages.iconMe);
        _makerList[marker.id] = marker;
      }
    }

    if (pageType == PageType.nearBy) {
      for (var value in allOnlineUsers.values) {
        if (value.position != null) {
          BMFMarker marker = BMFMarker.icon(
              position: value.position!,
              title: value.userId,
              identifier: value.userId,
              icon: AssetsImages.iconPeople);
          _makerList[marker.id] = marker;
        }
      }
    } else if (pageType == PageType.distance ||
        pageType == PageType.navigation) {
      var user = allOnlineUsers.values.toList()[0];

      BMFMarker marker = BMFMarker.icon(
          position: user.position!,
          title: user.userId,
          identifier: user.userId,
          icon: AssetsImages.iconPeople);
      _makerList[marker.id] = marker;
      List<int> indexs = [0];

      List<Color> colors = [Colors.red];
      BMFPolyline colorsPolyline = BMFPolyline(
          coordinates: _makerList.values.map((e) => e.position).toList(),
          width: 2,
          indexs: indexs,
          colors: colors,
          lineDashType: BMFLineDashType.LineDashTypeNone,
          lineCapType: BMFLineCapType.LineCapButt,
          lineJoinType: BMFLineJoinType.LineJoinRound);
      var mePosition = GlobeDataManager.instance.getPosition();
      distance = Distance.getDistance(mePosition!, user.position!);
      notifyListeners();
      controller.addPolyline(colorsPolyline);
    }

    controller.addMarkers(_makerList.values.toList());
  }
}

class BaiduMapPage extends ConsumerStatefulWidget {
  PageType pageType;

  BaiduMapPage({super.key, required this.pageType});

  @override
  ConsumerState<BaiduMapPage> createState() => _BaiduMapState();
}

class _BaiduMapState extends ConsumerState<BaiduMapPage> {
  late BMFMapController _controller;

  @override
  void initState() {
    super.initState();
    //添加默认数据
    if (ref.read(imProvider).allOnlineUsers.isEmpty) {
      ref.read(imProvider).addOnlineUser();
    }

    ref.read(baiduMapProvider).clearMaker();
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
      ref.read(baiduMapProvider).addMakerList(
          widget.pageType, _controller, ref.read(imProvider).allOnlineUsers);
    });
    _controller.setMapDidFinishedRenderCallback(callback: (bool success) {
      print('1MapDidFinishedRenderd-地图绘制完成');
    });
    // _controller.setMapOnClickedMapBlankCallback(
    //     callback: (BMFCoordinate coordinate) {
    //       debugPrint("------------->setMapOnClickedMapBlankCallback");
    //   print('1${coordinate.toMap()}');
    // });
    _controller.setMapClickedMarkerCallback(callback: (marker) {
      var markerClick = ref.read(baiduMapProvider).getMaker(marker.id);
      if (markerClick != null) {
        var userInfo = ref.read(imProvider).getUserInfo(markerClick.identifier);
        Navigator.pushNamed(
          context,
          RouteNames.usesInfoPage,
          arguments: userInfo,
        );
      }
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
      appBar: getAppBar(context, "地图"),
      body: Stack(
        children: [
          Center(
            child: BMFMapWidget(
              onBMFMapCreated: (controller) {
                onBMFMapCreated(controller);
              },
              mapOptions: initMapOptions0(),
            ),
          ),
          if (widget.pageType == PageType.distance) getTopWidget().alignTop(),
          if (widget.pageType == PageType.navigation)
            getBottomWidget().alignBottom(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

extension _Action on _BaiduMapState {
  launcherMap() async {
    BMFCoordinate coordinate = ref.read(baiduMapProvider).getOther();
    final availableMaps = await MapLauncher.installedMaps;
    print(
        availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

    if (availableMaps.isEmpty) {
      Loading.toast("请先安装地图应用");
      return;
    }
    await availableMaps.first.showMarker(
      coords: Coords(coordinate.latitude, coordinate.longitude),
      title: "",
    );
  }
}

extension _UI on _BaiduMapState {
  Widget getTopWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          "距离：" + ref.watch(baiduMapProvider).distance.toDistance,
          style: TextStyle(
              color: Colors.red, fontSize: 38.sp, fontWeight: FontWeight.w500),
        ).paddingVertical(30.w)
      ],
    );
  }

  Widget getBottomWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          "去导航",
          style: TextStyle(
              color: AppColors.title,
              fontSize: 38.sp,
              fontWeight: FontWeight.w500),
        )
      ],
    )
        .padding(horizontal: 100.w, vertical: 30.w)
        .backgroundColor(AppColors.inputBgColor)
        .onTap(launcherMap);
  }
}
