import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';

import '../../common/im_data.dart';
import '../../common/colors.dart';
import '../../common/image.dart';
import '../../common/proto/qr_code_data.dart';
import '../../common/routers/RouteNames.dart';
import '../../common/util/images.dart';

final meProvider = ChangeNotifierProvider<MeNotifier>((ref) => MeNotifier());

class MeNotifier extends ChangeNotifier {}

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
      appBar: AppBar(
        backgroundColor: AppColors.bottomBackground,
        title: Text("我的"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _topItem(),
            _getMeItem("账号", ImDataManager.instance.me.userId, false),
            _getMeItem("二维码名片", "", true).onTap(() {
              QrCodeData qrCodeData =
                  QrCodeData(userInfo: ImDataManager.instance.me);
              Navigator.pushNamed(context, RouteNames.qrGenerate,
                  arguments: qrCodeData);
            }),
            _getMeItem("蓝牙", "", true).onTap(() {
              Navigator.pushNamed(context, RouteNames.blueSearchList);
            }),
            _getMeItem("离线地址管理", "", true).onTap(() {
              Navigator.pushNamed(context, RouteNames.offlineMap);
            }),
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

extension _Action on _MePageState {}

extension _UI on _MePageState {
  Widget _topItem() {
    return Column(
      children: [
        ClipOval(
          child: ImageWidget(
            url: ImDataManager.instance.me.avatarUrl ??
                AssetsImages.getDefaultAvatar(),
            width: 100.w,
            height: 100.h,
            type: ImageWidgetType.asset,
          ),
        ).paddingTop(80.h),
        Text(ImDataManager.instance.me.nickName ?? ""),
        Text(
          ImDataManager.instance.me.userId,
        )
      ],
    );
  }

  Widget _getMeItem(String title, String? value, bool isNewPage) {
    return Column(
      children: [
        Row(
          children: [
            Text(title),
            Expanded(child: Container()),
            Text(
              value ?? "",
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
            isNewPage
                ? Icon(
                    Icons.keyboard_arrow_right,
                    size: 43.w,
                  )
                : Container()
          ],
        ).paddingVertical(29.h),
        Divider(
          height: 0.1.h,
        ),
      ],
    );
  }
}
