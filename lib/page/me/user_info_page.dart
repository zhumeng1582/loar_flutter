import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';
import 'package:loar_flutter/page/home/provider/home_provider.dart';
import 'package:loar_flutter/widget/commit_button.dart';

import '../../common/image.dart';
import '../../common/util/images.dart';

final userInfoProvider =
    ChangeNotifierProvider<UserInfoNotifier>((ref) => UserInfoNotifier());

class UserInfoNotifier extends ChangeNotifier {}

class UserInfoPage extends ConsumerStatefulWidget {

  EMUserInfo userInfo;
  String message;

  UserInfoPage({super.key, required this.userInfo, required this.message});

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
            Text(widget.message),
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
    // bool isFriend = ref
    //     .watch(homeProvider)
    //     .allChatInfo
    //     .userList
    //     .any((element) => element.id == widget.userInfo.userId);
    // if (isFriend) {
    //   return "聊天";
    // }
    // if (widget.message.isNotEmpty) {
    //   return "同意";
    // }
    return "添加好友";
  }

  void _tapAction() {
    // bool isFriend = ref
    //     .watch(homeProvider)
    //     .allChatInfo
    //     .userList
    //     .any((element) => element.id == widget.userInfo.userId);
    // if (isFriend) {
    //   chatRoom(widget.userInfo);
    // } else if (widget.message.isNotEmpty) {
    // } else {
    //
    // }
  }

  chatRoom(EMUserInfo data) {

    // bool isRoomExist = ref
    //     .read(homeProvider)
    //     .allChatInfo
    //     .roomList
    //     .any((element) => element.id == data.getRoomId);
    // if (!isRoomExist) {
    //   var roomInfo = RoomInfo();
    //   roomInfo.id = data.getRoomId;
    //   roomInfo.userList.add(AccountData.instance.me);
    //   roomInfo.userList.add(data);
    //   roomInfo.name = data.name;
    //   ref.read(homeProvider).allChatInfo.roomList.insert(0, roomInfo);
    // }
    // Navigator.pushNamed(
    //   context,
    //   RouteNames.roomPage,
    //   arguments: data.getRoomId,
    // );
  }
}

extension _UI on _UserInfoPageState {
  Widget _topItem() {
    return Row(
      children: [
        ClipOval(
          child: ImageWidget(
            url: widget.userInfo.avatarUrl??AssetsImages.getRandomAvatar(),
            width: 100.w,
            height: 100.h,
            type: ImageWidgetType.asset,
          ),
        ).paddingTop(80.h),
        Text(widget.userInfo.nickName??"--"),
      ],
    );
  }
}
