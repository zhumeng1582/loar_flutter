import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/im_data.dart';
import 'package:loar_flutter/common/loading.dart';
import 'package:loar_flutter/common/ex/ex_im.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';
import 'package:loar_flutter/page/home/provider/im_message_provider.dart';
import 'package:loar_flutter/widget/commit_button.dart';

import '../../common/image.dart';
import '../../common/routers/RouteNames.dart';
import '../../widget/common.dart';

final userInfoProvider =
    ChangeNotifierProvider<UserInfoNotifier>((ref) => UserInfoNotifier());

class UserInfoNotifier extends ChangeNotifier {}

class UserInfoPage extends ConsumerStatefulWidget {
  EMUserInfo userInfo;

  UserInfoPage({super.key, required this.userInfo});

  @override
  ConsumerState<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends ConsumerState<UserInfoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, "用户信息"),
      body: SafeArea(
        child: Column(
          children: [
            _topItem().paddingBottom(30.h),
            isMe()
                ? Container()
                : CommitButton(
                    buttonState: ButtonState.normal,
                    text: getButtonText(),
                    tapAction: _tapAction)
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

extension _Action on _UserInfoPageState {
  bool isMe() {
    return widget.userInfo.userId == GlobeDataManager.instance.me?.userId;
  }

  String getButtonText() {
    if (ref.read(imProvider).contacts.contains(widget.userInfo.userId)) {
      return "聊天";
    } else {
      return "添加好友";
    }
  }

  void _tapAction() {
    if (ref.read(imProvider).contacts.contains(widget.userInfo.userId)) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.roomPage,
        (route) => route.settings.name == RouteNames.main,
        arguments: EMConversation.fromJson({"convId": widget.userInfo.userId}),
      );
    } else {
      ref.read(imProvider).addContact(widget.userInfo.userId, "您好，可以加个好友吗");
      Loading.toast("已发送消息，等候对方回复");
      Navigator.pop(context);
    }
  }
}

extension _UI on _UserInfoPageState {
  Widget _topItem() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipOval(
          child: ImageWidget(
            url: widget.userInfo.avatarName,
            width: 100.w,
            height: 100.h,
            radius: 6.r,
            type: ImageWidgetType.asset,
          ),
        ).paddingTop(80.h),
        Text(widget.userInfo.userId).paddingTop(20.h),
        Text(widget.userInfo.name).paddingTop(20.h),
      ],
    );
  }
}
