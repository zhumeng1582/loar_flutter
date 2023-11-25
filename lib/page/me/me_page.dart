import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/ex/ex_im.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';

import '../../common/im_data.dart';
import '../../common/colors.dart';
import '../../common/image.dart';
import '../../common/loading.dart';
import '../../common/proto/qr_code_data.dart';
import '../../common/routers/RouteNames.dart';
import '../../common/util/images.dart';
import '../../widget/edit_remark_sheet.dart';
import '../room/chat_detail_page.dart';

final meProvider = ChangeNotifierProvider<MeNotifier>((ref) => MeNotifier());

class MeNotifier extends ChangeNotifier {
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
    EMUserInfo me = ref.watch(meProvider).me;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bottomBackground,
        title: Text("我"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // _topItem(me),
            Divider(
              height: 0.1.h,
            ).paddingTop(200.h),
            _getMeItem("蜂蜂号", me.userId).onTap(() {
              Navigator.pushNamed(context, RouteNames.meDetailPage);
            }),
            _getMeItem("蜂讯", ""),
            _getMeItem("蜂圈", ""),
            _getMeItem("离线地址管理", "").onTap(() {
              Navigator.pushNamed(context, RouteNames.offlineMap);
            }),
            _getMeItem("设置", ""),
            _getMeItem("关于微蜂", "").onTap(() {
              Navigator.pushNamed(context, RouteNames.aboutPage);
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

extension _Action on _MePageState {
  selectAvatar() async {
    Navigator.pushNamed(context, RouteNames.selectAvatar).then(
        (value) => {ref.read(meProvider).updateUserAvatar(value as String)});
  }

  changeName(String name) {
    EditRemarkBottomSheet.show(
      context: context,
      maxLength: 18,
      data: name,
      onConfirm: (value) => {ref.read(meProvider).changeUserName(value)},
    );
  }
}

extension _UI on _MePageState {
  Widget _topItem(EMUserInfo me) {
    return Column(
      children: [
        ClipOval(
          child: ImageWidget(
            url: me.avatarName,
            width: 100.w,
            height: 100.h,
            type: ImageWidgetType.asset,
          ),
        ).onTap(selectAvatar).paddingTop(80.h),
      ],
    );
  }

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
}
