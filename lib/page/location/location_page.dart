import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/common/blue_tooth.dart';
import 'package:loar_flutter/common/im_data.dart';
import 'package:loar_flutter/common/loading.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';

import '../../common/colors.dart';
import '../../common/image.dart';
import '../../common/routers/RouteNames.dart';
import '../../common/util/images.dart';
import '../home/provider/im_message_provider.dart';
import '../map/model/page_type.dart';

final locationProvider =
    ChangeNotifierProvider<LocationNotifier>((ref) => LocationNotifier());

class LocationNotifier extends ChangeNotifier {}

class LocationPage extends ConsumerStatefulWidget {
  const LocationPage({super.key});

  @override
  ConsumerState<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends ConsumerState<LocationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.bottomBackground,
        title: const Text("定位"),
        actions: [
          const Text("刷新用戶").paddingHorizontal(32.h).onTap(clearAllUser)
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Divider(
              height: 0.1.h,
            ).paddingTop(200.h),
            _getItem(AssetsImages.iconFengWo, "蜂窝", "我的位置").onTap(() {
              if (hasPosition()) {
                Navigator.pushNamed(context, RouteNames.baiduMapPage,
                    arguments: MapDataPara(PageType.me));
              }
            }),
            _getItem(AssetsImages.iconFenLin, "蜂邻", "周围都有谁").onTap(() {
              if (hasPosition()) {
                Navigator.pushNamed(context, RouteNames.baiduMapPage,
                    arguments: MapDataPara(PageType.nearBy));
              }
            }),
            _getItem(AssetsImages.iconFenJu, "蜂距", "两者距离").onTap(() {
              if (hasPosition()) {
                Navigator.pushNamed(context, RouteNames.baiduMapPage,
                    arguments: MapDataPara(PageType.distance));
              }
            }),
            _getItem(AssetsImages.iconFenXing, "蜂行", "导航").onTap(() {
              if (hasPosition()) {
                Navigator.pushNamed(context, RouteNames.baiduMapPage,
                    arguments: MapDataPara(PageType.navigation));
              }
            }),
            _getItem(AssetsImages.iconFengTu, "星图", "卫星星图").onTap(() {
              if (isConnect()) {
                Navigator.pushNamed(context, RouteNames.satelliteMapPage);
              }
            }),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

extension _Action on _LocationPageState {
  void clearAllUser() {
    ref.read(imProvider).clearAllOnlineUser();
    Loading.toast("刷新成功");
  }

  bool hasPosition() {
    if (!BlueToothConnect.instance.isConnect()) {
      Loading.toast("未连接设备");
      return false;
    }
    if (GlobeDataManager.instance.getPosition() == null) {
      Loading.toast("等待定位中...");
      return false;
    }

    return true;
  }

  bool isConnect() {
    if (!BlueToothConnect.instance.isConnect()) {
      Loading.toast("未连接设备");
      return false;
    }
    return true;
  }
}

extension _UI on _LocationPageState {
  Widget _getItem(String image, String title, String? value) {
    return Column(
      children: [
        Row(
          children: [
            if (image.isNotEmpty)
              ImageWidget(
                url: image,
                width: 60.w,
                height: 60.h,
                radius: 0,
                type: ImageWidgetType.asset,
              ).paddingRight(20.w),
            Text(
              title,
              style: TextStyle(fontSize: 38.sp, fontWeight: FontWeight.w400),
            ),
            Expanded(child: Container()),
            Text(
              value ?? "",
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w400),
            ),
          ],
        ).paddingHorizontal(30.w).paddingVertical(50.h),
        Divider(
          height: 0.1.h,
        ),
      ],
    );
  }
}
