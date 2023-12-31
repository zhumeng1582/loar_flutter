import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/index.dart';
import 'package:loar_flutter/page/room/chat_message_page.dart';
import '../../common/im_data.dart';
import '../../common/routers/RouteNames.dart';
import '../../widget/common.dart';
import '../../widget/message_bar.dart';
import '../home/provider/im_message_provider.dart';

final roomProvider =
    ChangeNotifierProvider<RoomNotifier>((ref) => RoomNotifier());

class RoomNotifier extends ChangeNotifier {}

class ChatPage extends ConsumerStatefulWidget {
  EMConversation conversation;

  ChatPage({super.key, required this.conversation});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    if (GlobeDataManager.instance.isEaseMob) {
      ref
          .read(imProvider)
          .getHistoryMessage(widget.conversation.id, widget.conversation.type);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context,
          ref.read(imProvider).getConversationTitle(widget.conversation),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_horiz),
              tooltip: 'Detail',
              onPressed: roomDetail,
            )
          ]),
      body: SafeArea(
        child: Column(
          children: [
            ChatMessagePage(conversationId: widget.conversation.id),
            _buildBottomItem()
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

extension _Action on _ChatPageState {
  roomDetail() async {
    Navigator.pushNamed(
      context,
      RouteNames.roomDetail,
      arguments: widget.conversation,
    );
  }

  bool sendMessage(String message) {
    if (ref.watch(imProvider).communicationStatue.available) {
      ref.read(imProvider).sendTextMessage(
          widget.conversation.type == EMConversationType.Chat
              ? ChatType.Chat
              : ChatType.GroupChat,
          widget.conversation.id,
          message);
    } else {
      Loading.toast("当前设备不在线，请连接网络或者LORA");
    }

    return ref.watch(imProvider).communicationStatue.available;
  }

  //发送定位
  sendLocalMessage() {
    ref.read(imProvider).sendLocalMessage(
        widget.conversation.type == EMConversationType.Chat
            ? ChatType.Chat
            : ChatType.GroupChat,
        widget.conversation.id);
  }
}

extension _UI on _ChatPageState {
  _buildBottomItem() {
    return MessageBar(
      textController: _controller,
      onSend: (message) => sendMessage(message),
      sendLocalMessage: sendLocalMessage,
    );
  }
}
