import 'package:chat_bubbles/bubbles/bubble_normal_audio.dart';
import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:loar_flutter/common/global_data.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';
import 'package:loar_flutter/page/home/home_page.dart';
import 'package:nine_grid_view/nine_grid_view.dart';
import '../../common/image.dart';
import '../../common/proto/index.dart';
import '../../widget/voice_widget.dart';

final roomMessageProvider =
    ChangeNotifierProvider<RoomMessageNotifier>((ref) => RoomMessageNotifier());

class RoomMessageNotifier extends ChangeNotifier {
  ChatMessage? playMessage;

  setPlayMessage(ChatMessage message) {
    playMessage = message;
  }

  setPlayPosition(int value) {
    if (playMessage == null) {
      return;
    }

    if (playMessage!.fileName.isEmpty == true) {
      return;
    }
    if (value == playMessage!.playTimeLength) {
      playMessage!.isPlaying = false;
    } else {
      playMessage!.isPlaying = true;
    }
    if (value <= playMessage!.playTimeLength) {
      playMessage!.playPosition = value;
    }
    notifyListeners();
  }

  setPlayState(ProcessingState state) {
    if (playMessage == null) {
      return;
    }

    if (playMessage?.fileName.isEmpty == true) {
      return;
    }
    if (state == ProcessingState.completed) {
      playMessage!.isPlaying = false;
      playMessage!.playPosition = playMessage!.playTimeLength;
    } else if (state == ProcessingState.loading) {
      playMessage!.isLoading = true;
      playMessage!.playPosition = 0;
    }

    notifyListeners();
  }
}

class RoomMessagePage extends ConsumerStatefulWidget {
  String roomId;

  RoomMessagePage({super.key, required this.roomId});

  @override
  ConsumerState<RoomMessagePage> createState() => _RoomMessagePageState();
}

class _RoomMessagePageState extends ConsumerState<RoomMessagePage> {
  final player = AudioPlayer();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    List<ChatMessage> data =
        ref.watch(homeProvider).getRoomInfoById(widget.roomId).messagelist;
    bool isAtBottom = _scrollController.hasClients &&
        _scrollController.offset >= _scrollController.position.maxScrollExtent;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isAtBottom) {
        _scrollToBottom();
      }
    });

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
    player.positionStream.listen((position) {
      ref.read(roomMessageProvider).setPlayPosition(position.inSeconds);
    });
    player.processingStateStream.listen((state) {
      ref.read(roomMessageProvider).setPlayState(state);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _changeSeek(ChatMessage message, double value) async {
    ref.read(roomMessageProvider).setPlayMessage(message);
    await player.setFilePath(message.fileName);
    player.seek(Duration(seconds: value.toInt()));

    player.play();
  }

  _playAudio(ChatMessage message) async {
    ref.read(roomMessageProvider).setPlayMessage(message);
    await player.setFilePath(message.fileName);
    player.play();
  }


  void _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }
}

extension _UI on _RoomMessagePageState {

  Widget _buildChat(List<ChatMessage> data) {
    return Expanded(
        child: ListView.builder(
      controller: _scrollController,
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildRoomMessageItem(data[index])
            .paddingVertical(10.w)
            .paddingHorizontal(30.w);
      },
    ));
  }

  Widget _buildRoomMessageItem(ChatMessage data) {
    if (data.user.id == GlobalData.instance.me.id) {
      return _buildChatRightItem(data, _buildChatContent(data));
    } else {
      return _buildChatLeftItem(data, _buildChatContent(data));
    }
  }

  Widget _buildChatContent(ChatMessage data) {
    var isSender = data.user.id == GlobalData.instance.me.id;

    if (data.messageType == MessageType.IMAGE) {
      return BubbleNormalImage(
        id: 'id001',
        tail: false,
        isSender: isSender,
        image: ImageWidget(
          url:
              "https://pics2.baidu.com/feed/d8f9d72a6059252d3a7bdecca7abd9375ab5b94c.jpeg@f_auto?token=691ee68a67c3508710aaefb99fdfd9ae",
          type: ImageWidgetType.network,
        ),
        color: Colors.purpleAccent,
      );
    } else if (data.messageType == MessageType.AUDIO) {
      return Expanded(
        child: BubbleNormalAudio(
          isSender: isSender,
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 140.w,
              maxHeight: 70),
          color: const Color(0xFFE8E8EE),
          isPlaying: data.isPlaying,
          isLoading: data.isLoading,
          duration: data.playTimeLength.toDouble(),
          position: data.playPosition.toDouble(),
          onSeekChanged: (value) => {_changeSeek(data, value)},
          onPlayPauseButtonClick: () => {_playAudio(data)},
        ),
      );
    } else {
      return BubbleSpecialOne(
        text: data.content,
        isSender: isSender,
        color: !isSender ? Colors.grey : const Color(0xFF1B97F3),
        textStyle: TextStyle(
          fontSize: 24.sp,
        ),
      );
    }
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
}

Widget userAvatar(ChatMessage data) {
  return ImageWidget(
    url: data.user.icon,
    width: 80.w,
    height: 80.h,
    type: ImageWidgetType.network,
  );
}
