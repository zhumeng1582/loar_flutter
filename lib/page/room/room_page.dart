import 'dart:convert';

import 'package:chat_bubbles/bubbles/bubble_normal_audio.dart';
import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';
import 'package:loar_flutter/common/util/storage.dart';
import '../../common/image.dart';
import '../../widget/voice_widget.dart';
import '../home/room_list.dart';
import 'message.dart';

final roomProvider =
    ChangeNotifierProvider<RoomNotifier>((ref) => RoomNotifier());

class RoomNotifier extends ChangeNotifier {
  List<MessageItem> data = [];
  MessageItem? playMessage;
  String roomId = "";

  get key => "Room$roomId";

  loadData(String roomId) async {
    this.roomId = roomId;
    data.clear();
    var text = await Storage.getString(key);
    if (text != null) {
      List<dynamic> dynamicList = jsonDecode(text);
      data = dynamicList
          .map((item) => MessageItem.fromJson(item))
          .toList();

    } else {
      var message1 = MessageItem.forText("1", "你好呀");
      var message2 = MessageItem.forText("2", "你也好呀");
      var message3 = MessageItem.forText("2", "嗯，挺好的");
      var message4 = MessageItem.forText("1", "ok");
      var message5 = MessageItem.forText("1", "ok");
      var message6 = MessageItem.forText("2", "ok");
      data.add(message1);
      data.add(message2);
      data.add(message5);
      data.add(message3);
      data.add(message6);
      data.add(message4);

    }
    notifyListeners();
  }

  addData(String text) {
    var message = MessageItem.forText("1", text);
    data.add(message);
    notifyListeners();
  }

  addAudioData(String audioFileName, int audioTimeLength) {
    var message = MessageItem.forAudio("1", audioFileName, audioTimeLength);
    data.add(message);
    notifyListeners();
  }

  setPlayMessage(MessageItem message) {
    playMessage = message;
  }

  setPlayPosition(int value) {
    if (playMessage?.audioFile == null) {
      return;
    }
    if (value == playMessage!.audioFile.audioTimeLength) {
      playMessage!.audioFile.isPlaying = false;
    } else {
      playMessage!.audioFile.isPlaying = true;
    }
    if (value <= playMessage!.audioFile.audioTimeLength) {
      playMessage!.audioFile.position = value;
    }
    notifyListeners();
  }

  setPlayState(ProcessingState state) {
    if (playMessage?.audioFile == null) {
      return;
    }
    if (state == ProcessingState.completed) {
      playMessage!.audioFile.isPlaying = false;
      playMessage!.audioFile.position =
          playMessage!.audioFile.audioTimeLength;
    } else if (state == ProcessingState.loading) {
      playMessage!.audioFile.isLoading = true;
      playMessage!.audioFile.position = 0;
    }

    notifyListeners();
  }

  saveData() async {
    String chatList = jsonEncode(data);
    Storage.save(key, chatList);

  }
}

class RoomPage extends ConsumerStatefulWidget {
  RoomItem roomItem;

  RoomPage({super.key, required this.roomItem});

  @override
  ConsumerState<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends ConsumerState<RoomPage> {
  final player = AudioPlayer();
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    print("text=initState");
    init();
  }

  @override
  Widget build(BuildContext context) {
    List<MessageItem> data = ref.watch(roomProvider).data;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roomItem.name),
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
    ref.watch(roomProvider).saveData();
  }
}

extension _Action on _RoomPageState {
  void init() async {
    ref.read(roomProvider).loadData(widget.roomItem.id);

    player.positionStream.listen((position) {
      ref.read(roomProvider).setPlayPosition(position.inSeconds);
    });
    player.processingStateStream.listen((state) {
      ref.read(roomProvider).setPlayState(state);
    });
  }

  sendMessage(String message) {
    ref.read(roomProvider).addData(message);
  }

  void _changeSeek(MessageItem message, double value) async {
    ref.read(roomProvider).setPlayMessage(message);
    await player.setFilePath(message.audioFile.fileName);
    player.seek(Duration(seconds: value.toInt()));

    player.play();
    }

  _playAudio(MessageItem message) async {
    ref.read(roomProvider).setPlayMessage(message);
    await player.setFilePath(message.audioFile.fileName);
    player.play();
    }

  startRecord() {
    print("开始录制");
  }

  stopRecord(String path, double audioTimeLength) {
    print("结束束录制");
    print("音频文件位置" + path);
    print("音频录制时长" + audioTimeLength.toString());
    ref.read(roomProvider).addAudioData(path, audioTimeLength.toInt());
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
    if (data.userInfo.id == "1") {
      return _buildChatRightItem(data, _buildChatContent(data));
    } else {
      return _buildChatLeftItem(data, _buildChatContent(data));
    }
  }

  Widget _buildChatContent(MessageItem data) {
    var isSender = data.userInfo.id == "1";

    if (data.messageType == MessageType.image) {
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
    } else if (data.messageType == MessageType.audio) {
      return Expanded(
        child: BubbleNormalAudio(
          isSender: isSender,
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 140.w, maxHeight: 70),
          color: const Color(0xFFE8E8EE),
          isPlaying: data.audioFile.isPlaying,
          isLoading: data.audioFile.isLoading,
          duration: data.audioFile.audioTimeLength.toDouble(),
          position: data.audioFile.position.toDouble(),
          onSeekChanged: (value) => {_changeSeek(data, value)},
          onPlayPauseButtonClick: () => {_playAudio(data)},
        ),
      );
    } else {
      return BubbleSpecialOne(
        text: data.text,
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
    url: data.userInfo.icon,
    width: 80.w,
    height: 80.w,
    type: ImageWidgetType.network,
  );
}
