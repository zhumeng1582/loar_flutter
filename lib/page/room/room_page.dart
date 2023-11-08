import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/page/room/room_message_page.dart';
import '../../common/colors.dart';
import '../../common/routers/RouteNames.dart';
import '../../widget/message_bar.dart';
import '../home/bean/ConversationBean.dart';
import '../home/provider/im_message_provider.dart';

final roomProvider =
    ChangeNotifierProvider<RoomNotifier>((ref) => RoomNotifier());

class RoomNotifier extends ChangeNotifier {}

class RoomPage extends ConsumerStatefulWidget {
  ConversationBean conversationBean;

  RoomPage({super.key, required this.conversationBean});

  @override
  ConsumerState<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends ConsumerState<RoomPage> {
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
            RoomMessagePage(conversationId: widget.conversationBean.id),
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

extension _Action on _RoomPageState {
  roomDetail() {
    if (widget.conversationBean.type == EMConversationType.Chat) {
      // Navigator.pushNamed(
      //   context,
      //   RouteNames.me,
      //   arguments: widget.conversationBean.id,
      // );
    } else {
      Navigator.pushNamed(
        context,
        RouteNames.roomDetail,
        arguments: widget.conversationBean,
      );
    }
  }

  sendMessage(String message) {
    ref.read(imProvider).addTextMessage(widget.conversationBean.id, message);
  }
}

extension _UI on _RoomPageState {
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
