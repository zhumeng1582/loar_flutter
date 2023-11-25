import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/ex/ex_im.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../common/im_data.dart';
import '../../common/colors.dart';
import '../../common/image.dart';
import '../../common/loading.dart';
import '../../common/proto/qr_code_data.dart';
import '../../common/routers/RouteNames.dart';
import '../../common/util/images.dart';
import '../../widget/edit_remark_sheet.dart';

final aboutProvider = ChangeNotifierProvider<AboutNotifier>((ref) => AboutNotifier());

class AboutNotifier extends ChangeNotifier {
  
}

class AboutDetailPage extends ConsumerStatefulWidget {
  const AboutDetailPage({super.key});

  @override
  ConsumerState<AboutDetailPage> createState() => _AboutDetailPageState();
}

class _AboutDetailPageState extends ConsumerState<AboutDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: AppColors.bottomBackground,
        title: Text("关于"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageWidget(
              url: AssetsImages.iconLauncher,
              width: 280.w,
              height: 280.h,
              type: ImageWidgetType.asset,
            ).paddingTop(160.h),
            Text("蜂信",style: TextStyle(
              fontSize: 48.sp,
              fontWeight: FontWeight.w600
            ),),
            Text("Version 1.0.0",style: TextStyle(
                fontSize: 38.sp,
            )).paddingTop(10.h),
            Text("版本更新",style: TextStyle(
                fontSize: 38.sp,
            )).padding(horizontal:30.w,vertical: 5.h).roundedBorder(radius: 3.r).paddingTop(10.h),
            Expanded(child: Container()),
          ],
        ).paddingHorizontal(30.w),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

extension _Action on _AboutDetailPageState {

}

extension _UI on _AboutDetailPageState {


}
