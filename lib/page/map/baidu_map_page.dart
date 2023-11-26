import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loar_flutter/common/ex/ex_im.dart';
import 'package:loar_flutter/common/im_data.dart';
import 'package:loar_flutter/page/home/provider/im_message_provider.dart';

import '../../common/ex/ex_userInfo.dart';
import '../../common/routers/RouteNames.dart';
import '../../common/util/images.dart';
import '../../widget/common.dart';

final baiduMapProvider =
    ChangeNotifierProvider<BaiduMapNotifier>((ref) => BaiduMapNotifier());

class BaiduMapNotifier extends ChangeNotifier {
  final Map<String, BMFMarker> _makerList = {};

  clearMaker() {
    _makerList.clear();
  }

  BMFMarker? getMaker(String id) {
    return _makerList[id];
  }

  addMakerList(
      BMFMapController controller, Map<String, OnlineUser> allOnlineUsers) {
    var mePosition = GlobeDataManager.instance.getPosition();
    if (mePosition != null) {
      BMFMarker marker = BMFMarker.icon(
          position: mePosition,
          title: GlobeDataManager.instance.me?.name,
          identifier: GlobeDataManager.instance.me?.userId,
          icon: AssetsImages.iconMe);
      _makerList[marker.id] = marker;
    }

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
    controller.addMarkers(_makerList.values.toList());
  }
}

class BaiduMapPage extends ConsumerStatefulWidget {
  const BaiduMapPage({super.key});

  @override
  ConsumerState<BaiduMapPage> createState() => _BodyState();
}

class _BodyState extends ConsumerState<BaiduMapPage> {
  late BMFMapController _controller;

  @override
  void initState() {
    super.initState();
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
      ref
          .read(baiduMapProvider)
          .addMakerList(_controller, ref.read(imProvider).allOnlineUsers);
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

  @override
  void dispose() {
    super.dispose();
  }
}
