import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/ex/ex_im.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';
import 'package:loar_flutter/page/home/provider/im_message_provider.dart';

import '../../common/colors.dart';
import '../../common/loading.dart';
import '../../widget/commit_button.dart';
import '../../widget/common.dart';
import 'bean/notify_bean.dart';

final notifyProvider =
    ChangeNotifierProvider<NotifyNotifier>((ref) => NotifyNotifier());

class NotifyNotifier extends ChangeNotifier {
  EMUserInfo? userInfo;

  fetchUserInfoById(String userId) async {
    var contact =
        await EMClient.getInstance.userInfoManager.fetchUserInfoById([userId]);
    userInfo = contact[userId];
    notifyListeners();
  }
}

class NotifyPage extends ConsumerStatefulWidget {
  NotifyBean data;

  NotifyPage({super.key, required this.data});

  @override
  ConsumerState<NotifyPage> createState() => _NotifyPageState();
}

class _NotifyPageState extends ConsumerState<NotifyPage> {
  @override
  void initState() {
    ref.read(notifyProvider).fetchUserInfoById(widget.data.inviter!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, "通知"),
      body: SafeArea(
        child: Column(
          children: [
            widget.data.type == NotifyType.groupInvite
                ? Text(
                    "${ref.watch(notifyProvider).userInfo?.name}邀请你加入群聊:${widget.data.name}")
                : Text("${ref.watch(notifyProvider).userInfo?.name}希望成为您的好友"),
            Text("${widget.data.reason}").paddingTop(10.h),
            CommitButton(
                    buttonState: ButtonState.normal,
                    text: "同意",
                    tapAction: _agree)
                .paddingTop(20.h),
            CommitButton(
                    buttonState: ButtonState.normal,
                    backgroundColor: AppColors.disableButtonBackgroundColor,
                    text: "拒绝",
                    tapAction: _reject)
                .paddingTop(20.h)
          ],
        ).padding(all: 32.w),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

extension _Action on _NotifyPageState {
  _agree() {
    ref.read(imProvider).acceptInvitation(widget.data);
    Navigator.pop(context);
    Loading.toast("接受成功");
  }

  _reject() {
    ref.read(imProvider).rejectInvitation(widget.data);
    Navigator.pop(context);
    Loading.toast("拒绝成功");
  }
}

extension _UI on _NotifyPageState {}
