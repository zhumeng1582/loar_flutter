import 'package:chat_bubbles/bubbles/bubble_normal_audio.dart';
import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:loar_flutter/common/local_info_cache.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';
import 'package:loar_flutter/page/home/home_page.dart';
import '../../common/image.dart';
import '../../common/proto/index.dart';
import '../../widget/voice_widget.dart';

final roomProvider =
    ChangeNotifierProvider<RoomNotifier>((ref) => RoomNotifier());

class RoomNotifier extends ChangeNotifier {
  MessageItem? playMessage;
  setPlayMessage(MessageItem message) {
    playMessage = message;
  }

  setPlayPosition(int value) {
    if (playMessage?.fileName.isEmpty == true) {
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

class RoomPage extends ConsumerStatefulWidget {
  String roomId;

  RoomPage({super.key, required this.roomId});

  @override
  ConsumerState<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends ConsumerState<RoomPage> {
  final player = AudioPlayer();
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    List<MessageItem> data = ref.watch(homeProvider).getRoomInfoFoRoom(widget.roomId).messagelist??[];
    return Scaffold(
      appBar: AppBar(
        title: Text(ref.watch(homeProvider).getRoomInfoFoRoom(widget.roomId).name??""),
      ),
      body: SafeArea(
        child: Column(
          children: [_buildChat(data), _buildBottomItem()],
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
  void init() async {
    player.positionStream.listen((position) {
      ref.read(roomProvider).setPlayPosition(position.inSeconds);
    });
    player.processingStateStream.listen((state) {
      ref.read(roomProvider).setPlayState(state);
    });
  }

  sendMessage(String message) {
    var value = ref.read(homeProvider).addData(widget.roomId,message);
    ref.read(homeProvider).sendMessage(value);
  }

  void _changeSeek(MessageItem message, double value) async {
    ref.read(roomProvider).setPlayMessage(message);
    await player.setFilePath(message.fileName);
    player.seek(Duration(seconds: value.toInt()));

    player.play();
  }

  _playAudio(MessageItem message) async {
    ref.read(roomProvider).setPlayMessage(message);
    await player.setFilePath(message.fileName);
    player.play();
  }

  startRecord() {
    print("开始录制");
  }

  stopRecord(String path, double audioTimeLength) {
    print("结束束录制");
    print("音频文件位置" + path);
    print("音频录制时长" + audioTimeLength.toString());
    var value =
        ref.read(homeProvider).addAudioData(widget.roomId,path, audioTimeLength.toInt());
    ref.read(homeProvider).sendMessage(value);
  }
}

extension _UI on _RoomPageState {
  _buildBottomItem() {
    return MessageBar(
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
        VoiceWidget(
          startRecord: startRecord,
          stopRecord: stopRecord,
          // 加入定制化Container的相关属性
          height: 40.0,
        ),
      ],
    );
  }

  Widget _buildChat(List<MessageItem> data) {
    return Expanded(
        child: ListView.builder(
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildRoomItem(data[index])
            .paddingVertical(10.w)
            .paddingHorizontal(30.w);
      },
    ));
  }

  Widget _buildRoomItem(MessageItem data) {
    if (data.user.id == LocalInfoCache.instance.userInfo?.user.id) {
      return _buildChatRightItem(data, _buildChatContent(data));
    } else {
      return _buildChatLeftItem(data, _buildChatContent(data));
    }
  }

  Widget _buildChatContent(MessageItem data) {
    var isSender = data.user.id == LocalInfoCache.instance.userInfo?.user.id;

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
        color: !isSender ? Colors.grey : Color(0xFF1B97F3),
        textStyle: TextStyle(
          fontSize: 24.sp,
        ),
      );
    }
  }

  _buildChatLeftItem(MessageItem data, Widget child) {
    return Row(
      children: [
        userAvatar(data),
        child,
      ],
    );
  }

  _buildChatRightItem(MessageItem data, Widget child) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        child,
        userAvatar(data),
      ],
    );
  }
}

ImageWidget userAvatar(MessageItem data) {
  return ImageWidget(
    url: data.user.icon,
    width: 80.w,
    height: 80.w,
    type: ImageWidgetType.network,
  );
}
