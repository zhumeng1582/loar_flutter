import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/page/home/home_page.dart';
import 'package:loar_flutter/page/room/room_message_page.dart';
import '../../common/colors.dart';
import '../../common/image.dart';
import '../../common/proto/index.dart';
import '../../common/routers/RouteNames.dart';
import '../../widget/message_bar.dart';
import '../../widget/voice_widget.dart';

final roomProvider =
    ChangeNotifierProvider<RoomNotifier>((ref) => RoomNotifier());

class RoomNotifier extends ChangeNotifier {}

class RoomPage extends ConsumerStatefulWidget {
  String roomId;

  RoomPage({super.key, required this.roomId});

  @override
  ConsumerState<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends ConsumerState<RoomPage> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.bottomBackground,
          title: Text(ref.read(homeProvider).getRoomTitle(widget.roomId)),
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
            RoomMessagePage(roomId: widget.roomId),
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
    Navigator.pushNamed(
      context,
      RouteNames.roomDetail,
      arguments: widget.roomId,
    );
  }

  sendMessage(String message) {
    ref.read(homeProvider).addTextMessage(widget.roomId, message);
  }

  startRecord() {
    print("开始录制");
  }

  stopRecord(String path, double audioTimeLength) {
    print("结束束录制");
    print("音频文件位置" + path);
    print("音频录制时长" + audioTimeLength.toString());
    ref
        .read(homeProvider)
        .addAudioMessage(widget.roomId, path, audioTimeLength.toInt());
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
        VoiceWidget(
          startRecord: startRecord,
          stopRecord: stopRecord,
          // 加入定制化Container的相关属性
          height: 40.0,
        ),
      ],
    );
  }
}
