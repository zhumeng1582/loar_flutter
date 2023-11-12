import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/util/ex_im.dart';
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
  EMUserInfo me = ImDataManager.instance.me;

  updateUserAvatar(String avatarUrl) async {
    try {
      Loading.show();
      await EMClient.getInstance.userInfoManager
          .updateUserInfo(avatarUrl: avatarUrl);
      await ImDataManager.instance.getUserInfo();
      me = ImDataManager.instance.me;
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
      await ImDataManager.instance.getUserInfo();
      me = ImDataManager.instance.me;
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
        title: Text("我的"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _topItem(me),
            _getMeItem("账号", me.userId, false),
            _getMeItem("名称", me.name, true).onTap(() {
              changeName(me.name);
            }),
            _getMeItem("二维码名片", "", true).onTap(() {
              QrCodeData qrCodeData = QrCodeData(userInfo: me);
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
