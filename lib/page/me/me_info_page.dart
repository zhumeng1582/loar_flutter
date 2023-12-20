import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/ex/ex_im.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../common/im_data.dart';
import '../../common/image.dart';
import '../../common/loading.dart';
import '../../common/proto/qr_code_data.dart';
import '../../common/routers/RouteNames.dart';
import '../../widget/common.dart';
import '../../widget/edit_gender_sheet.dart';
import '../../widget/edit_remark_sheet.dart';
import '../home/provider/network_provider.dart';

final meDetailProvider =
    ChangeNotifierProvider<MeInfoNotifier>((ref) => MeInfoNotifier());

class MeInfoNotifier extends ChangeNotifier {
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

  changeUserSign(String sign) async {
    await GlobeDataManager.instance.updateUserInfo(sign: sign);
    me = GlobeDataManager.instance.me!;
    notifyListeners();
  }

  changeGender(int gender) async {
    await GlobeDataManager.instance.updateUserInfo(gender: gender);
    me = GlobeDataManager.instance.me!;
    notifyListeners();
  }

  getGender() {
    return me.gender == 0
        ? ""
        : me.gender == 2
            ? "女"
            : "男";
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
            _getTopItem("头像", me).onTap(() {
              selectAvatar();
            }),
            _getMeItem("名字", me.name).onTap(() {
              changeName(me.name);
            }),
            _getMeItem("蜂蜂号", me.userId),
            _getQrItem("我的二维码", me),
            _getMeItem("性别", ref.watch(meDetailProvider).getGender()).onTap(() {
              changeGender(me.gender);
            }),
            _getMeItem("签名", me.sign ?? "您还未编写签名").onTap(() {
              changeSign(me.sign);
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

extension _Action on _MeInfoPageState {
  selectAvatar() async {
    if (!ref.read(networkProvider).isNetwork()) {
      Loading.toastError("离线模式不支持修改头像");
      return;
    }
    Navigator.pushNamed(context, RouteNames.selectAvatar).then((value) =>
        {ref.read(meDetailProvider).updateUserAvatar(value as String)});
  }

  changeSign(String? sign) {
    if (!ref.read(networkProvider).isNetwork()) {
      Loading.toastError("离线模式不支持修改签名");
      return;
    }

    EditRemarkBottomSheet.show(
      context: context,
      maxLength: 18,
      data: sign ?? "",
      onConfirm: (value) => {ref.read(meDetailProvider).changeUserSign(value)},
    );
  }

  changeGender(int value) {
    if (!ref.read(networkProvider).isNetwork()) {
      Loading.toastError("离线模式不支持修改性别");
      return;
    }

    EditGenderBottomSheet.show(
      context: context,
      maxLength: 18,
      data: ref.read(meDetailProvider).getGender(),
      onConfirm: (value) => {ref.read(meDetailProvider).changeGender(value)},
    );
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
            ClipRect(
              child: ImageWidget(
                url: me.avatarName,
                width: 80.w,
                height: 80.h,
                type: ImageWidgetType.asset,
              ),
            ),
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
                  data: jsonEncode(QrCodeData(userInfo: me).toJson()),
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
}
