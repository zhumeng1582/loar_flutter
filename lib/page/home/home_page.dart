import 'dart:convert';

import 'package:barcode_scan2/model/android_options.dart';
import 'package:barcode_scan2/model/scan_options.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loar_flutter/common/ex/ex_string.dart';
import 'package:loar_flutter/common/local_info_cache.dart';
import 'package:loar_flutter/common/proto/index.dart';

import '../../common/blue_tooth.dart';
import '../../common/image.dart';
import '../../common/routers/RouteNames.dart';
import '../../common/util/storage.dart';

final homeProvider =
    ChangeNotifierProvider<HomeNotifier>((ref) => HomeNotifier());

class HomeNotifier extends ChangeNotifier {
  String get chatMessageKey =>
      "chatMessageKey_${LocalInfoCache.instance.userInfo?.user.id}";

  String get userInfoListKey =>
      "userInfoList_${LocalInfoCache.instance.userInfo?.user.id}";
  RoomList roomList = RoomList();
  UserInfoList userInfoList = UserInfoList();

  init() async {
    var roomListIntList = await Storage.getIntList(chatMessageKey);
    roomList = RoomList.fromBuffer(roomListIntList);

    var userInfoIntList = await Storage.getIntList(userInfoListKey);
    userInfoList = UserInfoList.fromBuffer(userInfoIntList);

    BlueToothConnect.instance
        .listenLoar((text) => {setMessage(MessageItem.fromBuffer(text))});
  }

  setMessage(MessageItem messageItem) async {
    var room = getRoomInfo(messageItem.targetId);
    if (room ==null) {
      room = getUserInfoRoom(messageItem.targetId);
      roomList.roomList.add(room);
    }
    room.messagelist.add(messageItem);

    notifyListeners();
    await Storage.saveIntList(chatMessageKey, roomList.writeToBuffer());
  }

  RoomInfo? getRoomInfo(String id) {
    for (var element in roomList.roomList) {
      if(element.id == id){
        return element;
      }
    }
    return null;
  }
  RoomInfo getRoomInfoFoRoom(String id) {
    for (var element in roomList.roomList) {
      if(element.id == id){
        return element;
      }
    }
    return getUserInfoRoom(id);
  }

  //单聊用户
  RoomInfo getUserInfoRoom(String id) {
    var user = userInfoList.userList.firstWhere((element) => id == element.id);
    RoomInfo roomInfo = RoomInfo();
    roomInfo.id = id;
    roomInfo.name = user.name;

    // roomInfo.userList.add(LocalInfoCache.instance.userInfo!.user);
    // roomInfo.userList.add(user);
    // roomList.roomList.add(roomInfo);
    // Storage.saveIntList(chatMessageKey, roomList.writeToBuffer());

    return roomInfo;
  }

  sendMessage(MessageItem message) {
    BlueToothConnect.instance.writeLoraString(message.writeToBuffer());
  }

  addData(String roomId, String text) {
    var message = MessageItem();
    message.user = LocalInfoCache.instance.userInfo!.user;
    message.content = text;
    message.sendtime = "${DateTime.now().millisecondsSinceEpoch}";
    message.targetId = roomId;
    setMessage(message);
    notifyListeners();
  }

  addAudioData(String roomId, String audioFileName, int audioTimeLength) {
    var message = MessageItem();
    message.user = LocalInfoCache.instance.userInfo!.user;
    message.fileName = audioFileName;
    message.playTimeLength = audioTimeLength;
    message.sendtime = "${DateTime.now().millisecondsSinceEpoch}";
    message.targetId = roomId;
    setMessage(message);
    notifyListeners();
  }

  addUserInfoList(UserInfo userInfo) async {
    userInfoList.userList.add(userInfo);
    await Storage.saveIntList(userInfoListKey, userInfoList.writeToBuffer());
    notifyListeners();
  }

  scan() async {
    var options = const ScanOptions(
        android: AndroidOptions(aspectTolerance: 0.5, useAutoFocus: true),
        //(默认已配)添加Android自动对焦
        autoEnableFlash: false,
        //true打开闪光灯, false关闭闪光灯
        strings: {
          'cancel': '退出',
          'flash_on': '开闪光灯',
          'flash_off': '关闪光灯'
        } //标题栏添加闪光灯按钮、退出按钮
        );
    var result = await BarcodeScanner.scan(options: options);
    var newUser = UserInfo.fromBuffer(base64Decode(result.rawContent));
    addUserInfoList(newUser);
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
  }

  @override
  Widget build(BuildContext context) {
    List<RoomInfo> data = ref.watch(homeProvider).roomList.roomList;
    return Scaffold(
      appBar: AppBar(
        title: Text("聊天"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'Scan',
            onPressed: ref.read(homeProvider).scan,
          )
        ],
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
  _room(RoomInfo data) {
    Navigator.pushNamed(
      context,
      RouteNames.roomPage,
      arguments: data.id,
    );
  }
  _getLastText(List<MessageItem> list){
    return list.isNotEmpty?list.last.content:"";
  }
  _getLastTime(List<MessageItem> list){
    return list.isNotEmpty?list.last.sendtime.toYearMonthDayTimeDate:"";
  }
}

extension _UI on _HomePageState {
  _buildRoomItem(RoomInfo data) {
    return InkWell(
      onTap: () => _room(data),
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
                    Text(_getLastText(data.messagelist))
                  ],
                ),
              ),
              Text(_getLastTime(data.messagelist)),
            ],
          ),
          const Divider(height: 10),
        ],
      ),
    );
  }

}
