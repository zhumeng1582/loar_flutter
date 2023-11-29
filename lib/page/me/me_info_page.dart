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
import '../../widget/common.dart';
import '../../widget/edit_remark_sheet.dart';
import '../home/provider/network_provider.dart';

final meDetailProvider =
    ChangeNotifierProvider<MeInfoNotifier>((ref) => MeInfoNotifier());

class MeInfoNotifier extends ChangeNotifier {
  EMUserInfo me = GlobeDataManager.instance.me!;

  updateUserAvatar(String avatarUrl) async {
    try {
      Loading.show();
      await EMClient.getInstance.userInfoManager
          .updateUserInfo(avatarUrl: avatarUrl);
      await GlobeDataManager.instance.getUserInfo();
      me = GlobeDataManager.instance.me!;
      notifyListeners();
      Loading.dismiss();
      Loading.show("修改头像成功");
    } on EMError catch (e) {
      Loading.dismiss();
    }
  }

  changeUserName(String name) async {
    try {
      Loading.show();
      await EMClient.getInstance.userInfoManager.updateUserInfo(nickname: name);
      await GlobeDataManager.instance.getUserInfo();
      me = GlobeDataManager.instance.me!;
      Loading.dismiss();
      Loading.show("修改名称成功");
      notifyListeners();
    } on EMError catch (e) {
      Loading.dismiss();
    }
  }
}

class MeInfoPage extends ConsumerStatefulWidget {
  const MeInfoPage({super.key});

  @override
  ConsumerState<MeInfoPage> createState() => _MeInfoPageState();
}

class _MeInfoPageState extends ConsumerState<MeInfoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EMUserInfo me = ref.watch(meDetailProvider).me;
    return Scaffold(
      appBar: getAppBar(context, "蜂讯"),
      body: SafeArea(
        child: Column(
          children: [
            _getTopItem("头像", me),
            _getMeItem("名字", me.name).onTap(() {
              changeName(me.name);
            }),
            _getMeItem("蜂蜂号", me.userId),
            _getQrItem("我的二维码", me),
            _getMeItem("性别", "男"),
            _getMeItem("签名", "人生，去去就来"),
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

extension _Action on _MeInfoPageState {
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
      Loading.toastError("离线模式不支持修改名字");
      return;
    }

    EditRemarkBottomSheet.show(
      context: context,
      maxLength: 18,
      data: name,
      onConfirm: (value) => {ref.read(meDetailProvider).changeUserName(value)},
    );
  }
}

extension _UI on _MeInfoPageState {
  Widget _getMeItem(String title, String? value) {
    return Column(
      children: [
        Row(
          children: [
            Text(title,
                style: TextStyle(fontSize: 38.sp, fontWeight: FontWeight.w400)),
            Expanded(child: Container()),
            Text(
              value ?? "",
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ).paddingHorizontal(30.w).paddingVertical(40.h),
        Divider(
          height: 0.1.h,
        ),
      ],
    );
  }

  Widget _getTopItem(String title, EMUserInfo me) {
    return Column(
      children: [
        Row(
          children: [
            Text(title,
                style: TextStyle(fontSize: 38.sp, fontWeight: FontWeight.w400)),
            Expanded(child: Container()),
            _topItem(me),
          ],
        ).paddingHorizontal(30.w).paddingVertical(40.h),
        Divider(
          height: 0.1.h,
        ),
      ],
    );
  }

  Widget _getQrItem(String title, EMUserInfo me) {
    return Column(
      children: [
        Row(
          children: [
            Text(title,
                style: TextStyle(fontSize: 38.sp, fontWeight: FontWeight.w400)),
            Expanded(child: Container()),
            Stack(
              children: [
                QrImageView(
                  data: jsonEncode(me.toJson()),
                  version: QrVersions.auto,
                  gapless: false,
                  size: 180.w,
                ),
              ],
            ),
          ],
        ).paddingHorizontal(30.w),
        Divider(
          height: 0.1.h,
        ),
      ],
    );
  }

  Widget _topItem(EMUserInfo me) {
    return Column(
      children: [
        ClipRect(
          child: ImageWidget(
            url: me.avatarName,
            width: 80.w,
            height: 80.h,
            type: ImageWidgetType.asset,
          ),
        ).onTap(selectAvatar),
      ],
    );
  }
}
