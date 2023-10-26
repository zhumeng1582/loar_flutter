import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/common/ex/ex_userInfo.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';
import '../../common/colors.dart';
import '../../common/image.dart';
import '../../common/proto/index.dart';
import '../home/provider/home_provider.dart';

final roomMessageProvider =
    ChangeNotifierProvider<RoomMessageNotifier>((ref) => RoomMessageNotifier());

class RoomMessageNotifier extends ChangeNotifier {

}

class RoomMessagePage extends ConsumerStatefulWidget {
  String roomId;

  RoomMessagePage({super.key, required this.roomId});

  @override
  ConsumerState<RoomMessagePage> createState() => _RoomMessagePageState();
}

class _RoomMessagePageState extends ConsumerState<RoomMessagePage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    List<ChatMessage> data = ref
        .watch(homeProvider)
        .allChatInfo
        .getRoomById(widget.roomId)
        .messagelist;
    return _buildChat(data);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}

extension _Action on _RoomMessagePageState {
  void init() async {

  }

}

extension _UI on _RoomMessagePageState {
  Widget _buildChat(List<ChatMessage> data) {
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

  Widget _buildRoomMessageItem(ChatMessage data) {
    if (data.messageType == MessageType.NEW_USER) {
      return _buildNotifyItem(data);
    } else if (data.sender.isMe) {
      return _buildChatRightItem(data, _buildChatContent(data));
    } else {
      return _buildChatLeftItem(data, _buildChatContent(data));
    }
  }

  Widget _buildChatContent(ChatMessage data) {
    var isSender = data.sender.isMe;
    return BubbleSpecialOne(
      text: data.content,
      isSender: isSender,
      color: !isSender ? Colors.grey : const Color(0xFF1B97F3),
      textStyle: TextStyle(
        fontSize: 24.sp,
      ),
    );
  }

  _buildChatLeftItem(ChatMessage data, Widget child) {
    return Row(
      children: [
        userAvatar(data),
        child,
      ],
    );
  }

  _buildChatRightItem(ChatMessage data, Widget child) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        child,
        userAvatar(data),
      ],
    );
  }

  _buildNotifyItem(ChatMessage data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "${data.sender.name}加入群聊",
          style: TextStyle(
            color: AppColors.title.withOpacity(0.5),
            fontSize: 24.sp,
          ),
        )
      ],
    );
  }
}

Widget userAvatar(ChatMessage data) {
  return ImageWidget(
    url: data.sender.icon,
    width: 80.w,
    height: 80.h,
    type: ImageWidgetType.asset,
  );
}
