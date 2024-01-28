import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/ex/ex_string.dart';
import 'package:loar_flutter/common/index.dart';
import 'package:loar_flutter/page/room/chat_message_page.dart';
import '../../common/routers/RouteNames.dart';
import '../../common/util/im_cache.dart';
import '../../widget/common.dart';
import '../../widget/message_bar.dart';
import '../home/provider/im_message_provider.dart';

final roomProvider =
    ChangeNotifierProvider<RoomNotifier>((ref) => RoomNotifier());

class RoomNotifier extends ChangeNotifier {
  var sendText = "发送";
  var sendColor = AppColors.commonPrimary;
  int milliseconds = 0;
  Timer? timer;

  String getSendTime() {
    double seconds = milliseconds / 1000;
    // RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
    String result = seconds.toStringAsFixed(1);

    return "$result秒";
  }

  setTime() {
    if (milliseconds > 0) {
      milliseconds = milliseconds - 500;
      sendText = getSendTime();
      sendColor = AppColors.commonPrimary.withOpacity(0.5);
      notifyListeners();
    } else if (sendText != "发送") {
      sendText = "发送";
      sendColor = AppColors.commonPrimary;
      notifyListeners();
    }
  }

  sendTimerInterval() async {
    var time = await ImCache.getMessageInterval();
    milliseconds = time.toInt * 1000;

    if (timer != null) {
      timer?.cancel();
      timer = null;
    }

    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setTime();
    });
  }
}

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
    if (ref.read(imProvider).isOnline) {
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
            if (!CustomGroup.hideMore(widget.conversation.id))
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
    _controller.dispose();
    super.dispose();
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
    if (ref.watch(imProvider).available) {
      if (ref.read(roomProvider).milliseconds > 0) {
        Loading.toast("发送剩余时间${ref.read(roomProvider).getSendTime()}");
        return false;
      }
      ref.read(roomProvider).sendTimerInterval();
      ref.read(imProvider).sendTextMessage(
          widget.conversation.type == EMConversationType.Chat
              ? ChatType.Chat
              : ChatType.GroupChat,
          widget.conversation.id,
          message);
    } else {
      Loading.toast("当前设备不在线，请连接网络或者LORA");
    }

    return ref.watch(imProvider).available;
  }

  //发送定位
  sendLocalMessage() {
    if (ref.read(roomProvider).milliseconds > 0) {
      Loading.toast("发送剩余时间${ref.read(roomProvider).getSendTime()}");
      return;
    }
    ref.read(roomProvider).sendTimerInterval();
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
      sendButtonColor: ref.watch(roomProvider).sendColor,
      sendButtonText: ref.watch(roomProvider).sendText,
      sendLocalMessage: sendLocalMessage,
    );
  }
}
