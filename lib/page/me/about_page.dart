import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';

import '../../common/image.dart';
import '../../common/util/images.dart';
import '../../widget/common.dart';
import 'package:package_info_plus/package_info_plus.dart';

final aboutProvider =
    ChangeNotifierProvider<AboutNotifier>((ref) => AboutNotifier());

class AboutNotifier extends ChangeNotifier {
  String version = "";

  getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    notifyListeners();
  }
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
    Future(() {
      ref.read(aboutProvider).getVersion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, "关于"),
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
            Text(
              "蜂信",
              style: TextStyle(fontSize: 48.sp, fontWeight: FontWeight.w600),
            ),
            Text(ref.watch(aboutProvider).version,
                style: TextStyle(
                  fontSize: 38.sp,
                )).paddingTop(10.h),
            Text("版本更新",
                    style: TextStyle(
                      fontSize: 38.sp,
                    ))
                .padding(horizontal: 30.w, vertical: 5.h)
                .roundedBorder(radius: 3.r)
                .paddingTop(10.h),
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

extension _Action on _AboutDetailPageState {}

extension _UI on _AboutDetailPageState {}
