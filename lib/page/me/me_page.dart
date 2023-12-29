import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';

import '../../common/im_data.dart';
import '../../common/image.dart';
import '../../common/routers/RouteNames.dart';
import '../../common/util/images.dart';
import '../../widget/common.dart';

final meProvider = ChangeNotifierProvider<MeNotifier>((ref) => MeNotifier());

class MeNotifier extends ChangeNotifier {
  EMUserInfo me = GlobeDataManager.instance.me!;
}

class MePage extends ConsumerStatefulWidget {
  const MePage({super.key});

  @override
  ConsumerState<MePage> createState() => _MePageState();
}

class _MePageState extends ConsumerState<MePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, "我"),
      body: SafeArea(
        child: Column(
          children: [
            // _topItem(me),
            Divider(
              height: 0.1.h,
            ).paddingTop(200.h),
            // _getMeItem("蜂蜂号", "个人ID", AssetsImages.iconID).onTap(() {
            //   Navigator.pushNamed(context, RouteNames.meDetailPage);
            // }),
            _getMeItem("蜂蜂号", AssetsImages.iconGeRen).onTap(() {
              Navigator.pushNamed(context, RouteNames.meInfoPage);
            }),
            Divider(
              height: 0.1.h,
            ),
            _getMeItem("蜂圈", AssetsImages.iconPengYouQuan).onTap(() {
              Navigator.pushNamed(context, RouteNames.friendPage);
            }),
            Divider(
              height: 0.1.h,
            ),
            _getMeItem("设置", AssetsImages.iconSetting).onTap(() {
              Navigator.pushNamed(context, RouteNames.settingPage);
            }),
            Divider(
              height: 0.1.h,
            ),
            _getMeItem("关于微蜂", AssetsImages.iconAbout).onTap(() {
              Navigator.pushNamed(context, RouteNames.aboutPage);
            }),
            Divider(
              height: 0.1.h,
            ),
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

extension _Action on _MePageState {}

extension _UI on _MePageState {
  Widget _getMeItem(String title, String image) {
    return Row(
      children: [
        ImageWidget.asset(
          image,
          width: 48.w,
          height: 48.h,
        ).paddingRight(20.h),
        Text(title,
            style: TextStyle(fontSize: 38.sp, fontWeight: FontWeight.w400)),
        Expanded(child: Container()),
        Icon(
          Icons.keyboard_arrow_right,
          size: 43.w,
        )
      ],
    ).paddingHorizontal(30.w).paddingVertical(40.h);
  }
}
