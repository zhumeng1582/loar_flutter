import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/ex/ex_im.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';
import 'package:loar_flutter/page/home/provider/network_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../common/im_data.dart';
import '../../common/colors.dart';
import '../../common/image.dart';
import '../../common/loading.dart';
import '../../common/proto/qr_code_data.dart';
import '../../common/routers/RouteNames.dart';
import '../../common/util/images.dart';
import '../../widget/common.dart';
import '../../widget/edit_remark_sheet.dart';

final meDetailProvider =
    ChangeNotifierProvider<MeDetailNotifier>((ref) => MeDetailNotifier());

class MeDetailNotifier extends ChangeNotifier {
  EMUserInfo me = GlobeDataManager.instance.me!;

  updateUserAvatar(String avatarUrl) async {
    await GlobeDataManager.instance.updateUserInfo(avatarUrl: avatarUrl);
    me = GlobeDataManager.instance.me!;
    notifyListeners();
  }

  changeUserName(String name) async {
    await GlobeDataManager.instance.updateUserInfo(nickname: name);
    me = GlobeDataManager.instance.me!;
    notifyListeners();
  }
}

class MeDetailPage extends ConsumerStatefulWidget {
  const MeDetailPage({super.key});

  @override
  ConsumerState<MeDetailPage> createState() => _MeDetailPageState();
}

class _MeDetailPageState extends ConsumerState<MeDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EMUserInfo me = ref.watch(meDetailProvider).me;
    return Scaffold(
      appBar: getAppBar(context, "蜂蜂号"),
      body: SafeArea(
        child: Column(
          children: [
            _topItem(me),
            Text(
              me.name,
              style: TextStyle(fontSize: 60.sp, fontWeight: FontWeight.w500),
            ).paddingTop(20.h).onTap(() {
              changeName(me.name);
            }),
            Text(
              "蜂蜂号：${me.userId}",
              style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.w400),
            ).paddingTop(20.h),
            Stack(
              children: [
                QrImageView(
                  data: jsonEncode(QrCodeData(userInfo: me).toJson()),
                  version: QrVersions.auto,
                  gapless: false,
                  size: 280.w,
                ),
                getImage()
              ],
            ).paddingTop(10.h),
            const Row(),
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

extension _Action on _MeDetailPageState {
  selectAvatar() async {
    if (!ref.read(networkProvider).isNetwork()) {
      Loading.toastError("离线模式不支持修改头像");
      return;
    }

    Navigator.pushNamed(context, RouteNames.selectAvatar).then((value) =>
        {ref.read(meDetailProvider).updateUserAvatar(value as String)});
  }

  changeName(String name) {
    if (!ref.read(networkProvider).isNetwork()) {
      Loading.toastError("离线模式不支持修改用户名");
      return;
    }
    EditRemarkBottomSheet.show(
      context: context,
      maxLength: 18,
      data: name,
      onConfirm: (value) => {
        if (value.isEmpty)
          Loading.toast("用户昵称不能为空")
        else
          ref.read(meDetailProvider).changeUserName(value)
      },
    );
  }
}

extension _UI on _MeDetailPageState {
  Widget getImage() {
    return Positioned(
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        child: Center(
          child: Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            child: ImageWidget(
              url: ref.watch(meDetailProvider).me.avatarName,
              width: 80.w,
              height: 80.h,
              radius: 6.r,
              type: ImageWidgetType.asset,
            ),
          ),
        ));
  }

  Widget _topItem(EMUserInfo me) {
    return Column(
      children: [
        ClipRect(
          child: ImageWidget(
            url: me.avatarName,
            width: 400.w,
            height: 400.h,
            radius: 6.r,
            type: ImageWidgetType.asset,
          ),
        ).onTap(selectAvatar).paddingTop(80.h),
      ],
    );
  }
}
