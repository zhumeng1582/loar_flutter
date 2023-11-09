import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/im_data.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';
import '../../common/image.dart';
import '../../common/routers/RouteNames.dart';
import '../home/provider/im_message_provider.dart';

final roomMessageProvider =
    ChangeNotifierProvider<RoomMessageNotifier>((ref) => RoomMessageNotifier());

class RoomMessageNotifier extends ChangeNotifier {}

class ChatMessagePage extends ConsumerStatefulWidget {
  String conversationId;

  ChatMessagePage({super.key, required this.conversationId});

  @override
  ConsumerState<ChatMessagePage> createState() => _RoomMessagePageState();
}

class _RoomMessagePageState extends ConsumerState<ChatMessagePage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    List<EMMessage> data =
        ref.watch(imProvider).messageMap[widget.conversationId] ?? [];
    return _buildChat(data);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}

extension _Action on _RoomMessagePageState {
  void init() async {}
}

extension _UI on _RoomMessagePageState {
  Widget _buildChat(List<EMMessage> data) {
    return Expanded(
        flex: 1,
        child: Container(
          alignment: Alignment.topCenter,
          child: ListView.builder(
            controller: _scrollController,
            itemCount: data.length,
            reverse: true,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return _buildRoomMessageItem(data[index])
                  .paddingVertical(10.w)
                  .paddingHorizontal(30.w);
            },
          ),
        ));
  }

  Widget _buildRoomMessageItem(EMMessage data) {
    if (data.from == ImDataManager.instance.me.userId) {
      return _buildChatRightItem(data, _buildChatContent(data));
    } else {
      return _buildChatLeftItem(data, _buildChatContent(data));
    }
  }

  Widget _buildChatContent(EMMessage data) {
    var isSender = data.from == ImDataManager.instance.me.userId;
    EMTextMessageBody body = data.body as EMTextMessageBody;
    return BubbleSpecialOne(
      text: body.content,
      isSender: isSender,
      color: !isSender ? Colors.grey : const Color(0xFF1B97F3),
      textStyle: TextStyle(
        fontSize: 24.sp,
      ),
    );
  }

  _buildChatLeftItem(EMMessage data, Widget child) {
    return Row(
      children: [
        userAvatar(data),
        child,
      ],
    );
  }

  _buildChatRightItem(EMMessage data, Widget child) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        child,
        userAvatar(data),
      ],
    );
  }

  Widget userAvatar(EMMessage data) {
    return ImageWidget(
      url: ref.read(imProvider).getAvatarUrl(data.from),
      width: 80.w,
      height: 80.h,
      type: ImageWidgetType.asset,
    ).onTap(() {
      var userInfo = ref.read(imProvider).allUsers[data.from];
      Navigator.pushNamed(
        context,
        RouteNames.usesInfoPage,
        arguments: {"userInfo": userInfo},
      );
    });
  }

// _buildNotifyItem(EMMessage data) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.center,
//     children: [
//       Text(
//         "${data.sender.name}加入群聊",
//         style: TextStyle(
//           color: AppColors.title.withOpacity(0.5),
//           fontSize: 24.sp,
//         ),
//       )
//     ],
//   );
// }
}