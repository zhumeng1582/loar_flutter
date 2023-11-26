
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';

import '../../common/colors.dart';
import '../../common/routers/RouteNames.dart';

final locationProvider =
    ChangeNotifierProvider<LocationNotifier>((ref) => LocationNotifier());

class LocationNotifier extends ChangeNotifier {

}

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
        title: Text("定位"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Divider(
              height: 0.1.h,
            ).paddingTop(200.h),
            _getItem("蜂窝", "我的位置", false).onTap(() {
              Navigator.pushNamed(context, RouteNames.baiduMapPage);
            }),
            _getItem("蜂邻", "周围都有谁", false).onTap(() {
              Navigator.pushNamed(context, RouteNames.baiduMapPage);
            }),
            _getItem("蜂距", "两者距离", false),
            _getItem("蜂行", "导航", false),
            _getItem("星图", "卫星星图", false).onTap(() {
              Navigator.pushNamed(context, RouteNames.satelliteMapPage);
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
}

extension _UI on _LocationPageState {
  Widget _getItem(String title, String? value, bool isNewPage) {
    return Column(
      children: [
        Row(
          children: [
            Text(title,style: TextStyle(fontSize: 38.sp,fontWeight: FontWeight.w400),),
            Expanded(child: Container()),
            Text(
              value ?? "",
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 30.sp,fontWeight: FontWeight.w400),
            ),
            isNewPage
                ? Icon(
              Icons.keyboard_arrow_right,
              size: 43.w,
            )
                : Container()
          ],
        ).paddingHorizontal(30.w).paddingVertical(50.h),
        Divider(
          height: 0.1.h,
        ),
      ],
    );
  }
}
