import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/common/ex/ex_string.dart';
import 'package:loar_flutter/common/ex/ex_widget.dart';
import 'package:loar_flutter/common/proto/index.dart';
import 'package:loar_flutter/page/home/home_page.dart';
import 'package:protobuf/protobuf.dart';
import '../../common/routers/RouteNames.dart';

final roomProvider =
    ChangeNotifierProvider<RoomDetailNotifier>((ref) => RoomDetailNotifier());

class RoomDetailNotifier extends ChangeNotifier {
  roomDetail() {}
}

class RoomDetailPage extends ConsumerStatefulWidget {
  String roomId;

  RoomDetailPage({super.key, required this.roomId});

  @override
  ConsumerState<RoomDetailPage> createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends ConsumerState<RoomDetailPage> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(ref.read(homeProvider).getRoomTitle(widget.roomId)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _getMeItem("拉好友入群", "", true).onTap(selectUser),
            _getMeItem("群二维码名片", "", true).onTap(() {
              var roomInfo =
                  ref.watch(homeProvider).getRoomInfoById(widget.roomId).deepCopy();
              roomInfo.messagelist.clear();

              Navigator.pushNamed(context, RouteNames.qrGenerate,
                  arguments: base64Encode(roomInfo.writeToBuffer()));
            }),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

extension _Action on _RoomDetailPageState {
  selectUser() {
    Navigator.pushNamed(context, RouteNames.selectContact)
        .then((value) => {invite(value as List<UserInfo>)});
  }

  invite(List<UserInfo> userInfoList) {
    if (widget.roomId.isGroup) {
      ref.read(homeProvider).inviteFriend(widget.roomId, userInfoList);
      Navigator.pop(context);
    } else {
      var roomId = ref.read(homeProvider).createGroup(userInfoList);
      Navigator.pushNamedAndRemoveUntil(
          context, RouteNames.roomPage, ModalRoute.withName(RouteNames.main),
          arguments: roomId);
    }
  }
}

extension _UI on _RoomDetailPageState {
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
