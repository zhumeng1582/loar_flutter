import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/ex/ex_im.dart';
import 'package:loar_flutter/common/ex/ex_num.dart';
import 'package:loar_flutter/common/util/im_cache.dart';
import 'package:loar_flutter/common/util/storage.dart';
import 'package:protobuf/protobuf.dart';

import '../../../common/blue_tooth.dart';
import '../../../common/constant.dart';
import '../../../common/custom_group.dart';
import '../../../common/ex/ex_userInfo.dart';
import '../../../common/im_data.dart';
import '../../../common/loading.dart';
import '../../../common/proto/LoarProto.pb.dart';
import '../../../common/util/images.dart';
import '../../../main.dart';
import '../bean/conversation_bean.dart';
import '../bean/notify_bean.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';

final imProvider = ChangeNotifierProvider<ImNotifier>((ref) => ImNotifier());
var isConnectionSuccessful = false;

class ImNotifier extends ChangeNotifier {
  List<EMConversation> conversationsList = [];
  CommunicationStatue communicationStatue = CommunicationStatue(true);
  List<NotifyBean> notifyMessageList = [];
  List<String> contacts = [];
  Map<String, EMGroup> groupMap = {};
  Map<String, EMUserInfo> allUsers = {};
  Map<String, OnlineUser> allOnlineUsers = {};
  Map<String, List<EMMessage>> messageMap = {};

  init() async {
    Loading.show();
    await loadData();
    notifyListeners();
    Loading.dismiss();
  }

  //修改群组信息
  changeGroup(EMGroup group) {
    groupMap[group.groupId] = group;
    notifyListeners();
    ImCache.saveGroup(groupMap);
  }

  Future<void> loadData() async {
    await GlobeDataManager.instance.getUserInfo();

    if (GlobeDataManager.instance.isEaseMob) {
      contacts =
          await EMClient.getInstance.contactManager.getAllContactsFromServer();

      for (var element in contacts) {
        await getHistoryMessage(element, EMConversationType.Chat);
      }

      var groupList =
          await EMClient.getInstance.groupManager.fetchJoinedGroupsFromServer();

      for (var element in groupList) {
        groupMap[element.groupId] =
            await fetchGroupInfoFromServer(element.groupId);
        await getHistoryMessage(element.groupId, EMConversationType.GroupChat);
      }

      await loadUerInfo();

      conversationsList =
          await EMClient.getInstance.chatManager.loadAllConversations();

      ImCache.saveConversationsList(conversationsList);
      addCustomGroup();
      ImCache.saveGroup(groupMap);
      ImCache.saveAllUser(allUsers);
      ImCache.saveContacts(contacts);
    } else {
      conversationsList = await ImCache.getConversationsList();
      groupMap = await ImCache.getGroup();
      addCustomGroup();
      allUsers = await ImCache.getAllUser();
      messageMap = await ImCache.getAllMessage(allUsers.keys.toList());
      contacts = (await ImCache.getContacts()) ?? [];
    }
  }

  addCustomGroup() {
    if (!conversationsList
        .any((element) => element.id == CustomGroup.sosEMConversation.id)) {
      conversationsList.add(CustomGroup.sosEMConversation);
    }
    if (!conversationsList
        .any((element) => element.id == CustomGroup.squareEMConversation.id)) {
      conversationsList.add(CustomGroup.squareEMConversation);
    }

    if (!groupMap.containsKey(CustomGroup.sosGroup.groupId)) {
      groupMap[CustomGroup.sosGroup.groupId] = CustomGroup.sosGroup;
    }

    if (!groupMap.containsKey(CustomGroup.squareGroup.groupId)) {
      groupMap[CustomGroup.squareGroup.groupId] = CustomGroup.squareGroup;
    }
  }

  String getConversationTitle(EMConversation data) {
    if (data.type == EMConversationType.Chat) {
      return allUsers[data.id].name;
    } else {
      return groupMap[data.id].showName;
    }
  }

  String getConversationLastMessage(EMConversation? data) {
    var message = messageMap[data?.id];
    if (message?.isNotEmpty == true) {
      return getMessageText(message?.first);
    } else {
      return "去发送一个消息吧";
    }
  }

  String getConversationLastTime(EMConversation? data) {
    var message = messageMap[data?.id];
    if (message?.isNotEmpty == true) {
      return message?.first.serverTime.formatChatTime ?? "";
    } else {
      return "";
    }
  }

  List<String> getConversationAvatars(EMConversation data) {
    if (data.type == EMConversationType.Chat) {
      return [allUsers[data.id].avatarName];
    } else {
      return groupMap[data.id]
          .allUsers
          .map((e) => allUsers[e].avatarName)
          .toList();
    }
  }

  Future<void> loadUerInfo() async {
    var userList = groupMap[CustomGroup.allUserGroup].allUsers;
    var contactsMap =
        await EMClient.getInstance.userInfoManager.fetchUserInfoById(userList);
    allUsers.addAll(contactsMap);
  }

  addMessageToMap(String conversationId, EMMessage message) async {
    var messageList = messageMap[conversationId] ?? [];
    messageList.insert(0, message);
    messageMap[conversationId] = messageList;

    ImCache.saveChatMessage(conversationId, messageList);

    updateConversation(conversationId, message.chatType);
    // if (GlobeDataManager.instance.isEaseMob) {
    //   EMClient.getInstance.chatManager
    //       .updateMessage(message)
    //       .catchError((value) => error(value));
    // }
  }

  void updateConversation(String conversationId, ChatType chatType) {
    var index =
        conversationsList.indexWhere((element) => element.id == conversationId);
    EMConversation conversation;
    if (index != -1) {
      conversation = conversationsList[index];
      conversationsList.removeAt(index);
    } else {
      conversation = EMConversation.fromJson({
        "convId": conversationId,
        "type": chatType == ChatType.Chat ? 0 : 1
      });
    }

    conversationsList.insert(0, conversation);
    ImCache.saveConversationsList(conversationsList);
  }

  addContacts(String userId) async {
    if (contacts.contains(userId)) {
      return;
    }

    var contactsMap =
        await EMClient.getInstance.userInfoManager.fetchUserInfoById([userId]);
    if (contactsMap.isNotEmpty) {
      contacts.add(userId);
      allUsers[userId] = contactsMap[userId]!;
      ImCache.saveAllUser(allUsers);
      sendCmdMessage(ChatType.Chat, userId, "我们已经是好友了，快来聊天吧");
      notifyListeners();
    }
  }

  EMUserInfo? getUserInfo(String? userId) {
    if (allUsers.containsKey(userId)) {
      return allUsers[userId];
    }
    if (GlobeDataManager.instance.me?.userId == userId) {
      return GlobeDataManager.instance.me;
    }
    return null;
  }

  String getAvatarUrl(String? userId) {
    if (allUsers.containsKey(userId)) {
      return allUsers[userId]?.avatarUrl ?? AssetsImages.getRandomAvatar();
    }
    if (GlobeDataManager.instance.me?.userId == userId) {
      return GlobeDataManager.instance.me?.avatarUrl ??
          AssetsImages.getRandomAvatar();
    }
    return AssetsImages.getRandomAvatar();
  }

  void addImListener() async {
    await EMClient.getInstance.startCallback();

    EMClient.getInstance.contactManager.addEventHandler(
      "UNIQUE_HANDLER_ID",
      EMContactEventHandler(
        onContactAdded: (userId) {
          addContacts(userId);
          debugPrint("addContacts----1----->$userId");
        },
        onFriendRequestAccepted: (userId) {
          // addContacts(userId);
          debugPrint("addContacts----2----->$userId");
        },
        onContactInvited: (userId, reason) {
          notifyMessageList.add(NotifyBean(NotifyType.friendInvite,
              "${DateTime.now().millisecondsSinceEpoch}",
              inviter: userId, reason: reason));
          notifyListeners();
        },
        onFriendRequestDeclined: (userId) {},
      ),
    );

    EMClient.getInstance.chatManager.addMessageEvent(
        "UNIQUE_HANDLER_ID",
        ChatMessageEvent(
          onSuccess: (msgId, msg) {},
          onProgress: (msgId, progress) {},
          onError: (msgId, msg, error) {},
        ));

    EMClient.getInstance.chatManager.addEventHandler(
      "UNIQUE_HANDLER_ID",
      EMChatEventHandler(
        onMessagesDelivered: (list) {
          for (var message in list) {
            messageMap[message.conversationId]?.forEach((element) {
              //服务器消息id和本地消息id不一样，不能通过ID来判断
              if (element.localTime == message.localTime) {
                element.hasDeliverAck = message.hasDeliverAck;
                notifyListeners();
                return;
              }
            });
          }
        },
        onMessagesReceived: (messages) {
          for (var msg in messages) {
            if (msg.conversationId != null) {
              addMessageToMap(msg.conversationId!, msg);
            }
          }
          notifyListeners();
        },
      ),
    );

    EMClient.getInstance.groupManager.addEventHandler(
        "UNIQUE_HANDLER_ID",
        EMGroupEventHandler(
          onGroupDestroyed: (String groupId, String? groupName) {
            groupMap.remove(groupId);
          },
          onAttributesChangedOfGroupMember: (
            groupId,
            userId,
            attributes,
            operatorId,
          ) {
            debugPrint(
                "-------->onAttributesChangedOfGroupMember:${jsonEncode(attributes)}");
          },
          onRequestToJoinReceivedFromGroup:
              (groupId, groupName, applicant, reason) async {
            notifyMessageList.add(NotifyBean(
                NotifyType.joinPublicGroupApproval,
                applicant: applicant,
                "${DateTime.now().millisecondsSinceEpoch}",
                groupId: groupId,
                name: groupName,
                reason: reason));
            notifyListeners();
          },
          onAutoAcceptInvitationFromGroup: (groupId, userId, reason) async {
            groupMap[groupId] = await fetchGroupInfoFromServer(groupId);
            updateConversation(groupId, ChatType.GroupChat);
            notifyListeners();
          },
          onInvitationAcceptedFromGroup: (groupId, userId, reason) async {
            groupMap[groupId] = await fetchGroupInfoFromServer(groupId);
            updateConversation(groupId, ChatType.GroupChat);
            notifyListeners();
          },
          onRequestToJoinAcceptedFromGroup: (groupId, userId, reason) async {
            // groupMap[groupId] = await fetchGroupInfoFromServer(groupId);
            // updateConversation(groupId, ChatType.GroupChat);
            // notifyListeners();
          },
          onSpecificationDidUpdate: (group) async {
            groupMap[group.groupId] = group;
            notifyListeners();
          },
          onInvitationReceivedFromGroup: (groupId,
              groupName,
              inviter,
              reason,) {
            notifyMessageList.add(NotifyBean(NotifyType.groupInvite,
                "${DateTime.now().millisecondsSinceEpoch}",
                inviter: inviter,
                groupId: groupId,
                name: groupName,
                reason: reason));
            notifyListeners();
          },
        ));

    // 注册连接状态监听
    EMClient.getInstance.addConnectionEventHandler(
      "UNIQUE_HANDLER_ID",
      EMConnectionEventHandler(
        // sdk 连接成功;
        onConnected: () =>
            {communicationStatue.available = true, notifyListeners()},
        // 由于网络问题导致的断开，sdk会尝试自动重连，连接成功后会回调 "onConnected";
        onDisconnected: () => {
          communicationStatue.available = BlueToothConnect.instance.isConnect(),
          notifyListeners()
        },
        // 用户 token 鉴权失败;
        onUserAuthenticationFailed: () => {},
        // 由于密码变更被踢下线;
        onUserDidChangePassword: () => {},
        // 用户被连接被服务器禁止;
        onUserDidForbidByServer: () => {},
        // 用户登录设备超出数量限制;
        onUserDidLoginTooManyDevice: () => {},
        // 用户从服务器删除;
        onUserDidRemoveFromServer: () => {},
        // 调用 `kickDevice` 方法将设备踢下线，被踢设备会收到该回调；
        onUserKickedByOtherDevice: () => {},
        // 登录新设备时因达到了登录设备数量限制而导致当前设备被踢下线，被踢设备收到该回调；
        onUserDidLoginFromOtherDevice: (String deviceName) => {},
        // Token 过期;
        onTokenDidExpire: () => {},
        // Token 即将过期，需要调用 renewToken;
        onTokenWillExpire: () => {},
      ),
    );
    BlueToothConnect.instance.setListen((text) => {getRemoteMessage(text)});
  }

  //loar消息分发处理
  getRemoteMessage(dynamic message) {
    debugPrint("1getRemoteMessage-------->$message");
    try {
      LoarMessage loarMessage = LoarMessage.fromBuffer(message);
      debugPrint("2getRemoteMessage-------->$loarMessage");

      if (loarMessage.hasDeliverAck &&
          loarMessage.sender == GlobeDataManager.instance.me?.userId) {
        //给消息标记已送达，只标记我发送的消息
        paraDeliverAckMessage(loarMessage);
      } else if (loarMessage.conversationType == ConversationType.BROARDCAST) {
        allOnlineUsers[loarMessage.sender] =
            OnlineUser(loarMessage.sender, loarMessage);
      } else if (loarMessage.conversationId ==
              GlobeDataManager.instance.me?.userId ||
          groupMap.containsKey(loarMessage.conversationId)) {
        paraLoarMessage(loarMessage);

        if (loarMessage.conversationId ==
            GlobeDataManager.instance.me?.userId) {
          //发送消息已送到标志
          LoarMessage deliverAckMessage = loarMessage.deepCopy();

          // deliverAckMessage.content = "";
          // deliverAckMessage.longitude = 0;
          // deliverAckMessage.latitude = 0;

          deliverAckMessage.hasDeliverAck = true;
          BlueToothConnect.instance.writeLoraMessage(deliverAckMessage);
        }
      } else if (loarMessage.sendCount == 0) {
        //不是我的消息，直接转发
        loarMessage.sendCount++;
        loarMessage.repeater = GlobeDataManager.instance.me?.userId ?? "";
        BlueToothConnect.instance.writeLoraMessage(loarMessage);
      }
    } on Exception {}
  }

  void paraDeliverAckMessage(LoarMessage loarMessage) {
    messageMap[loarMessage.conversationId]?.forEach((element) {
      if (element.msgId == element.msgId) {
        element.hasDeliverAck = true;
        notifyListeners();
        return;
      }
    });
  }

  void paraLoarMessage(LoarMessage loarMessage) {
    EMMessage message;
    if (loarMessage.msgType == MsgType.TEXT) {
      message = EMMessage.createReceiveMessage(
          body: EMTextMessageBody(
              content: loarMessage.content,
              targetLanguages: [loarMessage.repeater]),
          chatType: loarMessage.conversationType == ConversationType.CHAT
              ? ChatType.Chat
              : ChatType.GroupChat);
    } else {
      message = EMMessage.createReceiveMessage(
          body: EMLocationMessageBody(
              latitude: loarMessage.latitude, longitude: loarMessage.longitude),
          chatType: loarMessage.conversationType == ConversationType.CHAT
              ? ChatType.Chat
              : ChatType.GroupChat);
    }

    message.from = loarMessage.sender;
    message.to = loarMessage.conversationId;
    var conversationId = "";

    if (loarMessage.conversationType == ConversationType.CHAT) {
      conversationId = loarMessage.sender;
    } else {
      conversationId = loarMessage.conversationId;
    }

    updateConversation(conversationId, message.chatType);
    addMessageToMap(conversationId, message);

    notifyListeners();
  }

  error(value) {
    Loading.toast((value as EMError).description);
  }

  addContact(String userId, String reason) async {
    await EMClient.getInstance.contactManager
        .addContact(userId, reason: reason)
        .catchError((value) => error(value));
  }

  acceptInvitation(NotifyBean data) async {
    try {
      if (data.type == NotifyType.groupInvite) {
        await EMClient.getInstance.groupManager
            .acceptInvitation(data.groupId!, data.inviter!);
        groupMap[data.groupId!] = await fetchGroupInfoFromServer(data.groupId!);
        updateConversation(data.groupId!, ChatType.GroupChat);
      } else if (data.type == NotifyType.friendInvite) {
        await EMClient.getInstance.contactManager
            .acceptInvitation(data.inviter!);
        contacts = await EMClient.getInstance.contactManager
            .getAllContactsFromServer();
        updateConversation(data.inviter!, ChatType.ChatRoom);
      } else if (data.type == NotifyType.joinPublicGroupApproval) {
        await EMClient.getInstance.groupManager
            .acceptJoinApplication(data.groupId!, data.applicant!);
      }
      notifyMessageList.remove(data);
      notifyListeners();
    } on EMError catch (e) {
      error(e);
    }
  }

  rejectInvitation(NotifyBean data) async {
    try {
      if (data.type == NotifyType.groupInvite) {
        await EMClient.getInstance.groupManager
            .declineInvitation(groupId: data.groupId!, inviter: data.inviter!);
      } else {
        await EMClient.getInstance.contactManager
            .declineInvitation(data.inviter!);
      }
    } on EMError catch (e) {}

    notifyMessageList.remove(data);
    notifyListeners();
  }

  Future<EMGroup> fetchGroupInfoFromServer(String groupId) async {
    return await EMClient.getInstance.groupManager
        .fetchGroupInfoFromServer(groupId, fetchMembers: true);
  }

  leaveGroup(String groupId) async {
    try {
      await EMClient.getInstance.groupManager.leaveGroup(groupId);
    } on EMError catch (e) {
      Loading.error(e.description);
    }
  }

  joinPublicGroup(String groupId) async {
    try {
      await EMClient.getInstance.groupManager.joinPublicGroup(groupId);
      Loading.toast("消息已发送,等待群主同意");
    } on EMError catch (e) {
      Loading.error(e.description);
    }
  }

  destroyGroup(String groupId) async {
    try {
      await EMClient.getInstance.groupManager.destroyGroup(groupId);
    } on EMError catch (e) {
      Loading.error(e.description);
    }
  }

  sendTextMessage(
      ChatType chatType, String targetId, String messageContent) async {
    var msg = EMMessage.createTxtSendMessage(
        targetId: targetId, content: messageContent, chatType: chatType);

    await sendMessage(targetId, msg, chatType, messageContent);
  }

  sendCmdMessage(
      ChatType chatType, String targetId, String messageContent) async {
    var msg = EMMessage.createCmdSendMessage(
        targetId: targetId, action: messageContent);

    await sendMessage(targetId, msg, chatType, messageContent);
  }

  Future<void> sendMessage(String targetId, EMMessage msg, ChatType chatType,
      String messageContent) async {
    addMessageToMap(targetId, msg);
    notifyListeners();
    if (GlobeDataManager.instance.isEaseMob) {
      await EMClient.getInstance.chatManager.sendMessage(msg);
    } else {
      LoarMessage message = LoarMessage(
        msgId: msg.msgId,
        msgType: MsgType.TEXT,
        hasDeliverAck: false,
        sender: GlobeDataManager.instance.me?.userId,
        conversationId: targetId,
        conversationType: chatType == ChatType.Chat
            ? ConversationType.CHAT
            : ConversationType.GROUP,
        content: messageContent,
      );
      BlueToothConnect.instance.writeLoraMessage(message);
    }
  }

  sendLocalMessage(ChatType chatType, String targetId) async {
    BMFCoordinate? position = GlobeDataManager.instance.getPosition();
    if (position == null) {
      Loading.toast("还未获取到定位数据");
      return;
    }
    var msg = EMMessage.createLocationSendMessage(
        targetId: targetId,
        latitude: position.latitude,
        longitude: position.longitude,
        chatType: chatType);

    addMessageToMap(targetId, msg);
    notifyListeners();
    if (GlobeDataManager.instance.isEaseMob) {
      await EMClient.getInstance.chatManager.sendMessage(msg);
    } else {
      LoarMessage message = LoarMessage(
        msgId: msg.msgId,
        msgType: MsgType.LOCATION,
        sender: GlobeDataManager.instance.me?.userId,
        conversationId: targetId,
        conversationType: chatType == ChatType.Chat
            ? ConversationType.CHAT
            : ConversationType.GROUP,
        latitude: position.latitude,
        longitude: position.longitude,
      );
      BlueToothConnect.instance.writeLoraMessage(message);
    }
  }

  getHistoryMessage(String id, EMConversationType type) async {
    try {
      EMCursorResult<EMMessage?> cursor =
          await EMClient.getInstance.chatManager.fetchHistoryMessages(
        conversationId: id,
        type: type,
      );
      List<EMMessage> messageList = [];
      for (int i = cursor.data.length - 1; i >= 0; i--) {
        var data = cursor.data[i];
        if (data != null) {
          if (data.chatType == ChatType.Chat) {
            //所有历史消息均为已送达
            data.hasDeliverAck = true;
          }
          messageList.add(data);
        }
      }

      messageMap[id] = messageList;
      ImCache.saveChatMessage(id, messageList);
      EMClient.getInstance.chatManager.importMessages(messageList);
      notifyListeners();
    } on EMError catch (e) {}
  }

  String getMessageText(EMMessage? message) {
    if (message == null) {
      return "去发送一条消息吧";
    }
    switch (message.body.type) {
      case MessageType.TXT:
        {
          EMTextMessageBody body = message.body as EMTextMessageBody;
          return body.content;
        }
      case MessageType.CMD:
        {
          EMCmdMessageBody body = message.body as EMCmdMessageBody;
          return body.action;
        }
      default:
        return "收到一条新消息";
    }
  }

  bool isEmpty(String? text) {
    return text?.isNotEmpty == true;
  }

  void removeImListener() {
    EMClient.getInstance.contactManager.removeEventHandler("UNIQUE_HANDLER_ID");

    EMClient.getInstance.chatManager.removeMessageEvent("UNIQUE_HANDLER_ID");
    EMClient.getInstance.chatManager.removeEventHandler("UNIQUE_HANDLER_ID");
    EMClient.getInstance.groupManager.removeEventHandler("UNIQUE_HANDLER_ID");
    // 解注册连接状态监听
    EMClient.getInstance.removeConnectionEventHandler(
      "UNIQUE_HANDLER_ID",
    );
  }
}
