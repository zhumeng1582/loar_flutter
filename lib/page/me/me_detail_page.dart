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

final meDetailProvider = ChangeNotifierProvider<MeDetailNotifier>((ref) => MeDetailNotifier());

class MeDetailNotifier extends ChangeNotifier {
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: AppColors.bottomBackground,
        title: Text("蜂蜂号"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _topItem(me),
            Text(me.name,style: TextStyle(fontSize: 60.sp,fontWeight: FontWeight.w500),).paddingTop(20.h).onTap(() {
              changeName(me.name);
            }),
            Text("蜂蜂号：${me.userId}",style: TextStyle(fontSize: 40.sp,fontWeight: FontWeight.w400),).paddingTop(20.h),
            Stack(
              children: [
                QrImageView(
                  data: jsonEncode(me.toJson()),
                  version: QrVersions.auto,
                  gapless: false,
                  size: 280.w,
                ),
                getImage()
              ],
            ).paddingTop(10.h),
            Row(),

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
    Navigator.pushNamed(context, RouteNames.selectAvatar).then(
            (value) => {ref.read(meDetailProvider).updateUserAvatar(value as String)});
  }

  changeName(String name) {
    EditRemarkBottomSheet.show(
      context: context,
      maxLength: 18,
      data: name,
      onConfirm: (value) => {ref.read(meDetailProvider).changeUserName(value)},
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
            type: ImageWidgetType.asset,
          ),
        ).onTap(selectAvatar).paddingTop(80.h),
      ],
    );
  }

}
