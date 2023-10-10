import 'dart:async';
import 'dart:convert';

import 'package:barcode_scan2/model/android_options.dart';
import 'package:barcode_scan2/model/scan_options.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/common/ex/ex_string.dart';
import 'package:loar_flutter/common/account_data.dart';
import 'package:loar_flutter/common/proto/index.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';
import 'package:nine_grid_view/nine_grid_view.dart';
import 'package:protobuf/protobuf.dart';

import '../../common/blue_tooth.dart';
import '../../common/colors.dart';
import '../../common/image.dart';
import '../../common/routers/RouteNames.dart';
import '../../common/util/gaps.dart';
import '../../common/util/images.dart';
import '../../common/util/storage.dart';

final homeProvider =
    ChangeNotifierProvider<HomeNotifier>((ref) => HomeNotifier());

class HomeNotifier extends ChangeNotifier {
  String get allChatInfoKey => "AllChatInfo${AccountData.instance.me.id}";

  AllChatInfo allChatInfo = AllChatInfo();

  List<RoomInfo> get messageRoomList => allChatInfo.roomList
      .where((element) => element.messagelist.isNotEmpty)
      .toList();

//生成两个用户的房间号
  String _getRoomId(UserInfo data) {
    var id1 = AccountData.instance.me.id;
    var id2 = data.id;
    if (id1.compareTo(id2) < 0) {
      return '$id1-$id2';
    } else {
      return '$id2-$id1';
    }
  }

  init() async {
    var value = await Storage.getIntList(allChatInfoKey);
    allChatInfo = AllChatInfo.fromBuffer(value);
    notifyListeners();

    mockData();

    BlueToothConnect.instance
        .listenLoar((text) => {getRemoteMessage(LoarMessage.fromBuffer(text))});
  }

  UserInfo _createNewUser(String id) {
    var newUser = AccountData.instance.me.deepCopy();
    newUser.id = id;
    newUser.name = "王五";
    newUser.icon = AssetsImages.getRandomAvatar();
    allChatInfo.userList.add(newUser);
    return newUser;
  }

  void mockData() {
    const period = Duration(seconds: 3);
    Timer.periodic(period, (timer) {
      var loarMessage = LoarMessage();
      loarMessage.loarMessageType = LoarMessageType.MESSAGE;
      var chatMessage = ChatMessage();
      chatMessage.messageType = MessageType.TEXT;

      UserInfo newUser = allChatInfo.userList.firstWhere(
          (element) => element.id == "user#000002",
          orElse: () => _createNewUser("user#000002"));

      chatMessage.user = newUser;
      chatMessage.content = "当前时间:" +
          DateTime.now().millisecondsSinceEpoch.toString().formatChatTime;
      chatMessage.targetId = _getRoomId(newUser);
      chatMessage.sendtime = "${DateTime.now().millisecondsSinceEpoch}";
      loarMessage.message = chatMessage;

      getRemoteMessage(loarMessage);
      notifyListeners();
    });
  }

  _addFriend(AddFriendMessage addFriendMessage) {
    allChatInfo.userList.add(addFriendMessage.user);
    notifyListeners();
  }

  _addGroup(AddGroupMessage addGroupMessage) {
    allChatInfo.roomList.add(addGroupMessage.room);
    notifyListeners();
  }

  _addChatMessage(ChatMessage chatMessage) async {
    if (isMyMessage(chatMessage)) {
      var room = getRoomInfo(chatMessage);
      //房间不存在，先创建一个房间
      room.messagelist.insert(0, chatMessage);

      //判断用户是否在房间里，不在就添加进去
      if (!isInRoom(room, chatMessage.user)) {
        room.userList.add(chatMessage.user);
      }
      //判断自己是否在房间里，不在就添加进去
      if (!isInRoom(room, AccountData.instance.me)) {
        room.userList.add(AccountData.instance.me);
      }
      await Storage.saveIntList(allChatInfoKey, allChatInfo.writeToBuffer());
    } else if (chatMessage.sendCount == 0) {
      chatMessage.sendCount++;
      _sendMessage(chatMessage);
    }
  }

  //loar消息分发处理
  getRemoteMessage(LoarMessage loarMessage) {
    switch (loarMessage.loarMessageType) {
      case LoarMessageType.ADD_FRIEND:
        _addFriend(loarMessage.addFriendMessage);
        break;
      case LoarMessageType.ADD_GROUP:
        _addGroup(loarMessage.addGroupMessage);
        break;
      case LoarMessageType.MESSAGE:
        _addChatMessage(loarMessage.message);
        break;
    }
  }

  RoomInfo getRoomInfo(ChatMessage chatMessage) {
    return allChatInfo.roomList.firstWhere(
        (element) => element.id == chatMessage.targetId,
        orElse: () => _createRoomById(chatMessage.targetId));
  }

  bool isMyMessage(ChatMessage chatMessage) {
    var isMe = allChatInfo.roomList
        .any((element) => element.id == chatMessage.targetId);
    if (!isMe) {
      isMe = chatMessage.targetId.contains(AccountData.instance.me.id);
    }
    return isMe;
  }

  bool isInRoom(RoomInfo room, UserInfo userInfo) {
    return room.userList.any((element) => element.id == userInfo.id);
  }

  RoomInfo getRoomInfoById(String id) {
    return allChatInfo.roomList.firstWhere((element) => element.id == id,
        orElse: () => _createRoomById(id));
  }

  String getRoomTitle(String id) {
    RoomInfo roomInfo = getRoomInfoById(id);
    if (roomInfo.userList.length < 3) {
      return getRoomInfoById(id).name;
    } else {
      return "${getRoomInfoById(id).name}(${roomInfo.userList.length})";
    }
  }

  List<ChatMessage> getMessageList(String id) {
    RoomInfo roomInfo = allChatInfo.roomList.firstWhere(
        (element) => element.id == id,
        orElse: () => _createRoomById(id));
    return roomInfo.messagelist;
  }

  //创建房间
  RoomInfo _createRoomById(String id) {
    var roomInfo = RoomInfo();
    roomInfo.id = id;
    if (!id.isGroup) {
      String userId = id.replaceAll(AccountData.instance.me.id, "");
      userId = userId.replaceAll("-", "");
      if (allChatInfo.userList.any((element) => element.id == userId)) {
        var user =
            allChatInfo.userList.firstWhere((element) => element.id == userId);
        roomInfo.userList.add(AccountData.instance.me);
        roomInfo.userList.add(user);
        roomInfo.name = user.name;
      }
    } else {
      roomInfo.name = "群聊";
    }

    allChatInfo.roomList.add(roomInfo);
    return roomInfo;
  }

  //通过loar发送消息
  _sendMessage(ChatMessage message) {
    LoarMessage loarMessage = LoarMessage();
    loarMessage.loarMessageType = LoarMessageType.MESSAGE;
    loarMessage.message = message;
    BlueToothConnect.instance.writeLoraMessage(loarMessage);
  }

  addTextMessage(String roomId, String text) {
    var message = ChatMessage();
    message.user = AccountData.instance.me;
    message.content = text;
    message.sendtime = "${DateTime.now().millisecondsSinceEpoch}";
    message.targetId = roomId;
    message.messageType = MessageType.TEXT;
    message.sendCount = 0;
    _addChatMessage(message);
    _sendMessage(message);
    notifyListeners();
  }

  String createGroup(List<UserInfo> userInfoList) {
    var time = DateTime.now().millisecondsSinceEpoch;
    var room = RoomInfo();
    room.userList.add(AccountData.instance.me);
    room.userList.addAll(userInfoList);
    room.name = "群聊";
    room.id = "room#$time";
    room.creator = AccountData.instance.me;
    room.createtime = "$time";
    AddGroupMessage addGroupMessage = AddGroupMessage();
    addGroupMessage.room = room;
    LoarMessage loarMessage = LoarMessage();
    loarMessage.loarMessageType = LoarMessageType.ADD_GROUP;
    loarMessage.addGroupMessage = addGroupMessage;
    BlueToothConnect.instance.writeLoraMessage(loarMessage);
    allChatInfo.roomList.add(room);
    return room.id;
  }

  inviteFriend(String roomId, List<UserInfo> userInfoList) {
    var message = ChatMessage();
    message.user = AccountData.instance.me;
    message.addUser.addAll(userInfoList);
    message.sendtime = "${DateTime.now().millisecondsSinceEpoch}";
    message.targetId = roomId;
    message.messageType = MessageType.ADD_MEMBER;
    //邀请好友消息不需要转发
    message.sendCount = 1;
    _addChatMessage(message);
    _sendMessage(message);
    notifyListeners();
  }

  addAudioMessage(String roomId, String audioFileName, int audioTimeLength) {
    var message = ChatMessage();
    message.user = AccountData.instance.me;
    message.fileName = audioFileName;
    message.playTimeLength = audioTimeLength;
    message.sendtime = "${DateTime.now().millisecondsSinceEpoch}";
    message.targetId = roomId;
    message.messageType = MessageType.AUDIO;
    message.sendCount = 0;
    _addChatMessage(message);
    _sendMessage(message);
    notifyListeners();
  }

  addUserInfoList(UserInfo userInfo) async {
    allChatInfo.userList.add(userInfo);
    await Storage.saveIntList(allChatInfoKey, allChatInfo.writeToBuffer());
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
    var qrCodeData = QrCodeData.fromBuffer(base64Decode(result.rawContent));

    if (qrCodeData.qrCodeType == QrCodeType.QR_USER) {
      addUserInfoList(qrCodeData.user);
    } else {
      allChatInfo.roomList.add(qrCodeData.room);
      inviteFriend(qrCodeData.room.id, [AccountData.instance.me]);
    }
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
    List<RoomInfo> data = ref.watch(homeProvider).messageRoomList;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bottomBackground,
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
          return _buildRoomItem(data[index]).onTap(() {
            _room(data[index]);
          });
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

  _getLastText(List<ChatMessage> list) {
    if (list.isEmpty) {
      return "";
    }
    var last = list.last;
    if (list.last.messageType == MessageType.TEXT) {
      return last.content;
    } else if (last.messageType == MessageType.ADD_MEMBER) {
      return "${last.addUser.last.name}加入群聊";
    }
    return "收到语音消息";
  }

  _getLastTime(List<ChatMessage> list) {
    return list.isNotEmpty ? list.last.sendtime.formatChatTime : "";
  }
}

extension _UI on _HomePageState {
  Widget _buildRoomItem(RoomInfo data) {
    return Column(
      children: [
        Row(
          children: [
            _getIcon(data).paddingHorizontal(30.w),
            Expanded(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.name,
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: AppColors.title,
                              ),
                            ),
                            Text(
                              _getLastText(data.messagelist),
                              style: TextStyle(
                                fontSize: 22.sp,
                                color: AppColors.title.withOpacity(0.6),
                              ),
                            )
                          ],
                        ),
                      ),
                      Text(_getLastTime(data.messagelist),
                          style: TextStyle(
                            fontSize: 22.sp,
                            color: AppColors.title.withOpacity(0.6),
                          )).paddingHorizontal(30.h),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ).paddingTop(5.h),
        Gaps.line.paddingLeft(140.w).paddingVertical(15.h)
      ],
    );
  }

  Widget _getIcon(RoomInfo data) {
    if (data.userList.length > 3) {
      return NineGridView(
        width: 80.w,
        height: 80.h,
        type: NineGridType.weChatGp,
        itemCount: data.userList.length,
        itemBuilder: (BuildContext context, int index) {
          return ImageWidget(
            url: data.userList[index].icon,
            type: ImageWidgetType.asset,
          );
        },
      );
    } else if (data.userList.isNotEmpty) {
      var val = data.userList
          .firstWhere((element) => element.id != AccountData.instance.me.id);
      return ImageWidget(
        width: 80.w,
        height: 80.h,
        url: val.icon,
        type: ImageWidgetType.asset,
      );
    } else {
      return ImageWidget(
        width: 80.w,
        height: 80.h,
        url: AssetsImages.getRandomAvatar(),
        type: ImageWidgetType.asset,
      );
    }
  }
}
