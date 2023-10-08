import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loar_flutter/common/ex/ex_num.dart';
import 'package:loar_flutter/common/local_info_cache.dart';
import 'package:loar_flutter/common/proto/index.dart';

import '../../common/blue_tooth.dart';
import '../../common/image.dart';
import '../../common/routers/RouteNames.dart';
import '../../common/util/storage.dart';

final homeProvider =
    ChangeNotifierProvider<HomeNotifier>((ref) => HomeNotifier());

class HomeNotifier extends ChangeNotifier {
  String get chatMessageKey => "chatMessageKey";
  RoomList roomList = RoomList();

  init() async {
    var value = await Storage.getIntList(chatMessageKey);
    roomList = RoomList.fromBuffer(value);
    BlueToothConnect.instance
        .listenLoar((text) => {setMessage(MessageItem.fromBuffer(text))});
  }

  setMessage(MessageItem messageItem) async {
    var room = getRoomInfo(messageItem.targetId);
    room?.messagelist.add(messageItem);
    await Storage.saveIntList(chatMessageKey, roomList.writeToBuffer());
  }
  RoomInfo? getRoomInfo(String id){
    return  roomList.roomList.firstWhere(
            (element) => id == element.id,
        orElse: () => RoomInfo());
  }

  sendMessage(MessageItem message) {
    BlueToothConnect.instance.writeLoraString(message.writeToBuffer());
  }

   addData(String roomId,String text) {
    var message = MessageItem();
    message.user = LocalInfoCache.instance.userInfo!.user;
    message.content = text;
    message.sendtime = DateTime.now().millisecondsSinceEpoch;
    message.targetId = roomId;
    setMessage(message);
    notifyListeners();
  }

  addAudioData(String roomId,String audioFileName, int audioTimeLength) {
    var message = MessageItem();
    message.user = LocalInfoCache.instance.userInfo!.user;
    message.fileName = audioFileName;
    message.playTimeLength = audioTimeLength;
    message.sendtime = DateTime.now().millisecondsSinceEpoch;
    message.targetId = roomId;
    setMessage(message);
    notifyListeners();
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    ref.read(homeProvider).init();
  }

  @override
  Widget build(BuildContext context) {
    List<RoomInfo> data = ref.watch(homeProvider).roomList.roomList;
    return Scaffold(
      appBar: AppBar(
        title: Text("聊天"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildRoomItem(data[index]);
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

extension _Action on _HomePageState {
  room(RoomInfo data) {
    Navigator.pushNamed(
      context,
      RouteNames.roomPage,
      arguments: data.id,
    );
  }
}

extension _UI on _HomePageState {
  _buildRoomItem(RoomInfo data) {
    return InkWell(
      onTap: () => room(data),
      child: Column(
        children: [
          Row(
            children: [
              ImageWidget(
                url: data.icon,
                width: 50,
                height: 50,
                type: ImageWidgetType.network,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.name),
                    Text(data.messagelist.last.content),
                  ],
                ),
              ),
              Text(data.messagelist.last.sendtime.toYearMonthDayTimeDate),
            ],
          ),
          const Divider(height: 10),
        ],
      ),
    );
  }
}
