import 'package:chat_bubbles/bubbles/bubble_normal_audio.dart';
import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_record_plus/flutter_plugin_record.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';

import '../../common/image.dart';
import '../../widget/voice_widget.dart';
import '../home/room_list.dart';
import 'message.dart';

final roomProvider =
    ChangeNotifierProvider<RoomNotifier>((ref) => RoomNotifier());

class RoomNotifier extends ChangeNotifier {
  List<MessageItem> data = [];

  loadData() {
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

  addData(String text) {
    var message = MessageItem.forText("1", text);
    data.add(message);
    notifyListeners();
  }

  addAudioData(String audioFileName, double audioTimeLength) {
    var message = MessageItem.forAudio("1", audioFileName, audioTimeLength);
    data.add(message);
    notifyListeners();
  }

}

class RoomPage extends ConsumerStatefulWidget {
  RoomItem roomItem;

  RoomPage({super.key, required this.roomItem});

  @override
  ConsumerState<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends ConsumerState<RoomPage> {
  FlutterPluginRecord recordPlugin = FlutterPluginRecord();


  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(roomProvider).loadData();
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
    recordPlugin.dispose();

  }

}

extension _Action on _RoomPageState {
  sendMessage(String message) {
    ref.read(roomProvider).addData(message);
  }

  void _changeSeek(MessageItem data, double value) {}

  _playAudio(MessageItem message) async{
    if (message.audioFile != null) {
      recordPlugin.playByPath(message.audioFile!.fileName, "file");
    }
  }
}

extension _UI on _RoomPageState {
  startRecord() {
    print("开始录制");
  }

  stopRecord(String path, double audioTimeLength) {
    print("结束束录制");
    print("音频文件位置" + path);
    print("音频录制时长" + audioTimeLength.toString());
    ref.read(roomProvider).addAudioData(path, audioTimeLength);
  }

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
          color: Color(0xFFE8E8EE),
          duration: data.audioFile?.audioTimeLength,
          position: 0,
          onSeekChanged: (value) => {_changeSeek(data, value)},
          onPlayPauseButtonClick: () => {_playAudio(data)},
        ),
      );
    } else {
      return BubbleSpecialOne(
        text: data.text,
        isSender: isSender,
        color: !isSender ? Colors.grey : Color(0xFF1B97F3),
        textStyle: const TextStyle(
          fontSize: 20,
        ),
      );
    }
  }

  _buildChatLeftItem(MessageItem data, Widget child) {
    return Row(
      children: [
        ImageWidget(
          url: data.userInfo.icon,
          width: 50,
          height: 50,
          type: ImageWidgetType.network,
        ),
        child,
      ],
    );
  }

  _buildChatRightItem(MessageItem data, Widget child) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        child,
        ImageWidget(
          url: data.userInfo.icon,
          width: 50,
          height: 50,
          type: ImageWidgetType.network,
        ),
      ],
    );
  }
}
