import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:barcode_scan2/model/android_options.dart';
import 'package:barcode_scan2/model/scan_options.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:loar_flutter/common/ex/ex_num.dart';
import 'package:loar_flutter/common/account_data.dart';
import 'package:loar_flutter/common/ex/ex_userInfo.dart';
import 'package:loar_flutter/common/proto/index.dart';
import 'package:protobuf/protobuf.dart';

import '../../../common/blue_tooth.dart';
import '../../../common/util/images.dart';
import '../../../common/util/storage.dart';

final homeProvider =
    ChangeNotifierProvider<HomeNotifier>((ref) => HomeNotifier());

class HomeNotifier extends ChangeNotifier {
  String get allChatInfoKey => "AllChatInfo${AccountData.instance.me.id}";

  AllChatInfo allChatInfo = AllChatInfo();

  init() async {
    var value = await Storage.getIntList(allChatInfoKey);
    allChatInfo = AllChatInfo.fromBuffer(value);
    notifyListeners();

    mockData();

    BlueToothConnect.instance
        .listenLoar((text) => {getRemoteMessage(LoarMessage.fromBuffer(text))});
  }

  UserInfo _createNewUser(String id, String name) {
    var newUser = AccountData.instance.me.deepCopy();
    newUser.id = id;
    newUser.account = id;
    newUser.name = name;
    newUser.icon = AssetsImages.getRandomAvatar();
    allChatInfo.userList.add(newUser);
    return newUser;
  }

  void mockData() {
    if (allChatInfo.userList.isEmpty) {
      _createNewUser("user#000001", "张三");
      _createNewUser("user#000002", "李四");
      _createNewUser("user#000003", "王五");
      _createNewUser("user#000004", "赵六");
      _createNewUser("user#000005", "唐七");
    }

    const period = Duration(seconds: 3);
    Timer.periodic(period, (timer) {
      if (allChatInfo.roomList.isEmpty) {
        return;
      }

      var room =
          allChatInfo.roomList[Random().nextInt(allChatInfo.roomList.length)];

      var loarMessage = LoarMessage();
      loarMessage.loarMessageType = LoarMessageType.CHAT_MESSAGE;
      var chatMessage = ChatMessage();
      chatMessage.messageType = MessageType.TEXT;

      UserInfo newUser = room.userList[Random().nextInt(room.userList.length)];
      chatMessage.sender = newUser;
      chatMessage.content =
          "${newUser.name}发送消息，当前时间:${DateTime.now().millisecondsSinceEpoch.toHourMinSecondDate}";
      chatMessage.recipientId = room.id;
      chatMessage.sendtime = "${DateTime.now().millisecondsSinceEpoch}";
      loarMessage.message = chatMessage;

      getRemoteMessage(loarMessage);
      notifyListeners();
    });
  }

  void joinRoom(RoomInfo room) {
    allChatInfo.addGroup([room]);
    var message = ChatMessage();
    message.sender = AccountData.instance.me;
    message.messageType = MessageType.NEW_USER;
    message.sendtime = "${DateTime.now().millisecondsSinceEpoch}";
    message.recipientId = room.id;
    _addChatMessage(message);
    _sendMessage(message);
    notifyListeners();
  }

  _addChatMessage(ChatMessage chatMessage) async {
    var room = getRoomInfo(chatMessage);

    //房间不存在，先创建一个房间
    room.messagelist.insert(0, chatMessage);

    //判断用户是否在房间里，不在就添加进去

    if (!room.containsUserInfo(chatMessage.sender)) {
      room.userList.add(chatMessage.sender);
    }

    await Storage.saveIntList(allChatInfoKey, allChatInfo.writeToBuffer());
  }

  //loar消息分发处理
  getRemoteMessage(LoarMessage loarMessage) {
    switch (loarMessage.loarMessageType) {
      case LoarMessageType.CHAT_MESSAGE:
        if (isMyMessage(loarMessage.message)) {
          _addChatMessage(loarMessage.message);
        } else if (loarMessage.sendCount == 0) {
          //不是我的消息，直接转发
          loarMessage.sendCount++;
          BlueToothConnect.instance.writeLoraMessage(loarMessage);
        }
        break;
      case LoarMessageType.ADD_GROUP:
        var isMeMessage = loarMessage.addGroupMessage.room.userList
            .any((element) => AccountData.instance.me.id == element.id);
        if (isMeMessage) {
          joinRoom(loarMessage.addGroupMessage.room);
        } else if (loarMessage.sendCount == 0) {
          //不是我的消息，直接转发
          loarMessage.sendCount++;
          BlueToothConnect.instance.writeLoraMessage(loarMessage);
        }
        break;
    }
  }

  RoomInfo getRoomInfo(ChatMessage chatMessage) {
    return allChatInfo.roomList
        .firstWhere((element) => element.id == chatMessage.recipientId);
  }

  bool isMyMessage(ChatMessage chatMessage) {
    var isMe = allChatInfo.roomList
        .any((element) => element.id == chatMessage.recipientId);
    if (!isMe) {
      isMe = chatMessage.recipientId.contains(AccountData.instance.me.id);
    }
    return isMe;
  }

  String getRoomTitle(String id) {
    RoomInfo roomInfo = allChatInfo.getRoomById(id);
    if (roomInfo.userList.length < 3) {
      return roomInfo.name;
    } else {
      return "${roomInfo.name}(${roomInfo.userList.length})";
    }
  }

  //通过loar发送消息
  _sendMessage(ChatMessage message) {
    LoarMessage loarMessage = LoarMessage();
    loarMessage.loarMessageType = LoarMessageType.CHAT_MESSAGE;
    loarMessage.message = message;
    loarMessage.sendCount = 0;
    BlueToothConnect.instance.writeLoraMessage(loarMessage);
  }

  addTextMessage(String roomId, String text) {
    var message = ChatMessage();
    message.sender = AccountData.instance.me;
    message.content = text;
    message.sendtime = "${DateTime.now().millisecondsSinceEpoch}";
    message.recipientId = roomId;
    _addChatMessage(message);
    _sendMessage(message);
    notifyListeners();
  }

  inviteFriend(RoomInfo room, List<UserInfo> userInfoList) {
    AddGroupMessage addGroupMessage = AddGroupMessage();
    addGroupMessage.sender = AccountData.instance.me;
    addGroupMessage.room = room;
    addGroupMessage.recipientIds.addAll(userInfoList.map((e) => e.id).toList());

    LoarMessage loarMessage = LoarMessage();
    loarMessage.sendCount = 0;
    loarMessage.loarMessageType = LoarMessageType.ADD_GROUP;
    BlueToothConnect.instance.writeLoraMessage(loarMessage);
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
      allChatInfo.addUserInfo([qrCodeData.user]);
      notifyListeners();
    } else {
      joinRoom(qrCodeData.room);
    }

    await Storage.saveIntList(allChatInfoKey, allChatInfo.writeToBuffer());
    notifyListeners();
  }
}
