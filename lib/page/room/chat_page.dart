import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/page/room/chat_message_page.dart';
import '../../common/colors.dart';
import '../../common/routers/RouteNames.dart';
import '../../widget/message_bar.dart';
import '../home/bean/conversation_bean.dart';
import '../home/provider/im_message_provider.dart';

final roomProvider =
    ChangeNotifierProvider<RoomNotifier>((ref) => RoomNotifier());

class RoomNotifier extends ChangeNotifier {

}

class ChatPage extends ConsumerStatefulWidget {
  ConversationBean conversationBean;

  ChatPage({super.key, required this.conversationBean});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    ref.read(imProvider).getHistoryMessage(widget.conversationBean);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.bottomBackground,
          title: Text(widget.conversationBean.title),
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
            ChatMessagePage(conversationId: widget.conversationBean.id),
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
      arguments: widget.conversationBean,
    );
  }

  sendMessage(String message) {
    ref.read(imProvider).sendTextMessage(widget.conversationBean.getChatType(),
        widget.conversationBean.id, message);
  }
}

extension _UI on _ChatPageState {
  _buildBottomItem() {
    return MessageBar(
      textController: _controller,
      onSend: (message) => sendMessage(message),
      actions: [
        InkWell(
          child: const Icon(
            Icons.place,
            color: Colors.black,
            size: 24,
          ),
          onTap: () {},
        ),
      ],
    );
  }
}
