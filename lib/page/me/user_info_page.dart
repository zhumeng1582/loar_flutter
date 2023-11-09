import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';
import 'package:loar_flutter/page/home/provider/home_provider.dart';
import 'package:loar_flutter/page/home/provider/im_message_provider.dart';
import 'package:loar_flutter/widget/commit_button.dart';

import '../../common/image.dart';
import '../../common/routers/RouteNames.dart';
import '../../common/util/images.dart';
import '../home/bean/conversation_bean.dart';

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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _topItem(),
            CommitButton(
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
  String getButtonText() {
    if (ref.read(imProvider).contacts.contains(widget.userInfo.userId)) {
      return "聊天";
    } else {
      return "添加好友";
    }
  }

  void _tapAction() {
    if (ref.read(imProvider).contacts.contains(widget.userInfo.userId)) {
      ConversationBean conversationBean = ConversationBean(0,
          widget.userInfo.userId, "", widget.userInfo.nickName ?? "", "", []);
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.roomPage,
        (route) => route.settings.name == RouteNames.main,
        arguments: conversationBean,
      );
    } else {
      ref.read(imProvider).addContact(widget.userInfo.userId, "请求添加好友");
    }
  }
}

extension _UI on _UserInfoPageState {
  Widget _topItem() {
    return Row(
      children: [
        ClipOval(
          child: ImageWidget(
            url: widget.userInfo.avatarUrl ?? AssetsImages.getDefaultAvatar(),
            width: 100.w,
            height: 100.h,
            type: ImageWidgetType.asset,
          ),
        ).paddingTop(80.h),
        Text(widget.userInfo.nickName ?? "--"),
      ],
    );
  }
}
