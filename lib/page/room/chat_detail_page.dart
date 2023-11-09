import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/ex/ex_widget.dart';
import 'package:loar_flutter/page/home/provider/im_message_provider.dart';
import '../../common/proto/qr_code_data.dart';
import '../../common/routers/RouteNames.dart';
import '../home/bean/ConversationBean.dart';

final roomProvider =
    ChangeNotifierProvider<RoomDetailNotifier>((ref) => RoomDetailNotifier());

class RoomDetailNotifier extends ChangeNotifier {
  roomDetail() {}
}

class ChatDetailPage extends ConsumerStatefulWidget {
  ConversationBean conversationBean;

  ChatDetailPage({super.key, required this.conversationBean});

  @override
  ConsumerState<ChatDetailPage> createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends ConsumerState<ChatDetailPage> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("聊天信息"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _getMeItem("邀请好友", "", true).onTap(selectUser),
            _getMeItem("群二维码名片", "", true).onTap(() {
              QrCodeData qrCodeData = QrCodeData();
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
  invite(List<EMUserInfo> data) async {
    EMGroup? group;
    if (widget.conversationBean.type == EMConversationType.Chat) {
      group = await ref.read(imProvider).createGroup();
    } else {
      group =
          await ref.read(imProvider).getGroupWithId(widget.conversationBean.id);
    }
    if (group != null) {
      await ref
          .read(imProvider)
          .addMembers(group.groupId, data.map((e) => e.userId).toList());

      ConversationBean conversationBean =
          ConversationBean(group.groupId, "", group.name ?? "", "", []);
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.roomPage,
        (route) => route.settings.name == RouteNames.main,
        arguments: conversationBean,
      );
    }
  }

  selectUser() async {
    List<EMUserInfo> data = [];
    if (widget.conversationBean.type == EMConversationType.Chat) {
      data = ref.read(imProvider).contacts.values.toList();
    } else {
      var group =
          await ref.read(imProvider).getGroupWithId(widget.conversationBean.id);
      // group.memberList
      ref.read(imProvider).contacts.forEach((key, value) {
        if (group?.memberList?.contains(key) != true) {
          data.add(value);
        }
      });
    }

    Navigator.pushNamed(context, RouteNames.selectContact, arguments: data)
        .then((value) => {invite(value as List<EMUserInfo>)});
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
