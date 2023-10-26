import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loar_flutter/page/home/home_page.dart';
import 'package:loar_flutter/page/room/room_message_page.dart';
import '../../common/colors.dart';
import '../../common/routers/RouteNames.dart';
import '../../widget/message_bar.dart';
import '../../widget/voice_widget.dart';
import '../home/provider/home_provider.dart';

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
