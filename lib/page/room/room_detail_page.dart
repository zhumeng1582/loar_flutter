import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/common/ex/ex_string.dart';
import 'package:loar_flutter/common/ex/ex_userInfo.dart';
import 'package:loar_flutter/common/ex/ex_widget.dart';
import 'package:loar_flutter/common/account_data.dart';
import 'package:loar_flutter/common/proto/index.dart';
import 'package:protobuf/protobuf.dart';
import '../../common/routers/RouteNames.dart';
import '../home/provider/home_provider.dart';

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
            _getMeItem("邀请好友", "", true).onTap(selectUser),
            _getMeItem("群二维码名片", "", true).onTap(() {
              QrCodeData qrCodeData = QrCodeData();
              qrCodeData.qrCodeType = QrCodeType.QR_GROUP;
              qrCodeData.room = ref
                  .watch(homeProvider)
                  .allChatInfo
                  .getRoomById(widget.roomId)
                  .deepCopy();
              qrCodeData.user = AccountData.instance.me;
              qrCodeData.room.messagelist.clear();

              Navigator.pushNamed(context, RouteNames.qrGenerate,
                  arguments: qrCodeData);
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
    Navigator.pushNamed(context, RouteNames.selectContact,
            arguments: widget.roomId)
        .then((value) => {invite(value as List<UserInfo>?)});
  }

  invite(List<UserInfo>? userInfoList) {
    if (userInfoList == null || userInfoList.isEmpty) {
      return;
    }
    var room = ref.read(homeProvider).allChatInfo.getRoomById(widget.roomId);

    if (widget.roomId.isGroup) {
      room.addUserList(userInfoList);
      ref.read(homeProvider).inviteFriend(room, userInfoList);
      Navigator.pop(context);
    } else {
      //将当前房间的两人拉入群聊
      userInfoList.insertAll(0, room.userList);
      var newRoom = AccountData.instance.createRoom();
      ref.read(homeProvider).inviteFriend(room, userInfoList);
      Navigator.pushNamedAndRemoveUntil(
          context, RouteNames.roomPage, ModalRoute.withName(RouteNames.main),
          arguments: newRoom.id);
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
