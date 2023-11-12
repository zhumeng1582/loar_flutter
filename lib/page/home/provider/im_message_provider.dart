import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/ex/ex_im.dart';
import 'package:loar_flutter/common/ex/ex_num.dart';
import 'package:loar_flutter/common/util/storage.dart';

import '../../../common/constant.dart';
import '../../../common/im_data.dart';
import '../../../common/loading.dart';
import '../../../common/util/images.dart';
import '../../../main.dart';
import '../bean/conversation_bean.dart';
import '../bean/notify_bean.dart';

final imProvider = ChangeNotifierProvider<ImNotifier>((ref) => ImNotifier());
var isConnectionSuccessful = false;

class ImNotifier extends ChangeNotifier {
  List<EMConversation> conversationsList = [];
  List<NotifyBean> notifyList = [];
  List<String> contacts = [];
  Map<String, EMGroup> groupMap = {};
  Map<String, EMUserInfo> allUsers = {};
  Map<String, List<EMMessage>> messageMap = {};

  changeGroup(EMGroup group) {
    groupMap[group.groupId] = group;
    notifyListeners();
  }

  init() async {
    try {
      Loading.show();
      await loadData();
      notifyListeners();
      Loading.dismiss();
    } catch (e) {
      Loading.error("网络错误,清扫后再试");
      Loading.dismiss();
    }
  }

  Future<void> loadData() async {
    ImDataManager.instance.getUserInfo();

    contacts =
        await EMClient.getInstance.contactManager.getAllContactsFromServer();

    for (var element in contacts) {
      await getHistoryMessage(element, EMConversationType.Chat);
    }

    var groupList =
        await EMClient.getInstance.groupManager.fetchJoinedGroupsFromServer();
    groupList.forEach((element) async {
      groupMap[element.groupId] =
          await fetchGroupInfoFromServer(element.groupId);
    });
    for (var element in groupList) {
      await getHistoryMessage(element.groupId, EMConversationType.GroupChat);
    }

    var userList = [...contacts];
    groupMap.forEach((key, value) {
      userList.addAll([
        value.owner!,
        ...value.adminList ?? [],
        ...value.memberList ?? []
      ]);
    });
    await loadUerInfo(userList);

    conversationsList =
        await EMClient.getInstance.chatManager.loadAllConversations();
  }

  String getConversationTitle(EMConversation data) {
    if (data.type == EMConversationType.Chat) {
      return allUsers[data.id].name;
    } else {
      return groupMap[data.id].showName;
    }
  }

  String getConversationLastMessage(EMConversation data) {
    return getMessageText(messageMap[data.id]?.first);
  }

  String getConversationLastTime(EMConversation data) {
    return "${messageMap[data.id]?.first.serverTime.formatChatTime}";
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

  Future<void> loadUerInfo(List<String> contacts) async {
    var contactsMap =
        await EMClient.getInstance.userInfoManager.fetchUserInfoById(contacts);
    allUsers.addAll(contactsMap);
  }

  addMessageToMap(String conversationId, EMMessage message) async {
    var messageList = messageMap[conversationId] ?? [];
    messageList.insert(0, message);
    messageMap[conversationId] = messageList;

    updateConversation(conversationId, message.chatType);
    EMClient.getInstance.chatManager.updateMessage(message);

    notifyListeners();
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
  }

  addContacts(String userId) async {
    var contactsMap =
        await EMClient.getInstance.userInfoManager.fetchUserInfoById([userId]);
    if (!contacts.contains(userId)) {
      contacts.add(userId);
    }
    allUsers.addAll(contactsMap);

    notifyListeners();
  }

  EMUserInfo? getUserInfo(String? userId) {
    if (allUsers.containsKey(userId)) {
      return allUsers[userId];
    }
    if (ImDataManager.instance.me.userId == userId) {
      return ImDataManager.instance.me;
    }
    return null;
  }

  String getAvatarUrl(String? userId) {
    if (allUsers.containsKey(userId)) {
      return allUsers[userId]?.avatarUrl ?? AssetsImages.getRandomAvatar();
    }
    if (ImDataManager.instance.me.userId == userId) {
      return ImDataManager.instance.me.avatarUrl ??
          AssetsImages.getRandomAvatar();
    }
    return AssetsImages.getRandomAvatar();
  }

  void addImListener() {
    EMClient.getInstance.contactManager.addEventHandler(
      "UNIQUE_HANDLER_ID_1",
      EMContactEventHandler(
        onContactAdded: (userId) {
          addContacts(userId);
        },
        onFriendRequestAccepted: (userId) {
          addContacts(userId);
        },
        onContactInvited: (userId, reason) {
          notifyList.add(NotifyBean(NotifyType.friend, userId,
              "${DateTime.now().millisecondsSinceEpoch}",
              reason: reason));
          notifyListeners();
        },
        onFriendRequestDeclined: (userId) {},
      ),
    );

    EMClient.getInstance.chatManager.addMessageEvent(
        "UNIQUE_HANDLER_ID_2",
        ChatMessageEvent(
          onSuccess: (msgId, msg) {},
          onProgress: (msgId, progress) {},
          onError: (msgId, msg, error) {},
        ));

    EMClient.getInstance.chatManager.addEventHandler(
      "UNIQUE_HANDLER_ID_3",
      EMChatEventHandler(
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
        "UNIQUE_HANDLER_ID_4",
        EMGroupEventHandler(
          onAttributesChangedOfGroupMember: (
            groupId,
            userId,
            attributes,
            operatorId,
          ) {
            debugPrint("-------->onAttributesChangedOfGroupMember:" +
                jsonEncode(attributes));
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
          onInvitationReceivedFromGroup: (
            groupId,
            groupName,
            inviter,
            reason,
          ) {
            notifyList.add(NotifyBean(NotifyType.group, inviter,
                "${DateTime.now().millisecondsSinceEpoch}",
                groupId: groupId, name: groupName, reason: reason));
            notifyListeners();
          },
        ));

    // 注册连接状态监听
    EMClient.getInstance.addConnectionEventHandler(
      "UNIQUE_HANDLER_ID_5",
      EMConnectionEventHandler(
        // sdk 连接成功;
        onConnected: () => {},
        // 由于网络问题导致的断开，sdk会尝试自动重连，连接成功后会回调 "onConnected";
        onDisconnected: () => {},
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
  }

  addContact(String userId, String reason) async {
    try {
      await EMClient.getInstance.contactManager
          .addContact(userId, reason: reason);
    } on EMError catch (e) {}
  }

  acceptInvitation(NotifyBean data) async {
    try {
      if (data.type == NotifyType.group) {
        await EMClient.getInstance.groupManager
            .acceptInvitation(data.groupId!, data.inviter);
        groupMap[data.groupId!] = await fetchGroupInfoFromServer(data.groupId!);
        updateConversation(data.groupId!, ChatType.GroupChat);
        notifyListeners();
      } else {
        await EMClient.getInstance.contactManager
            .acceptInvitation(data.inviter);
        contacts = await EMClient.getInstance.contactManager
            .getAllContactsFromServer();
        updateConversation(data.groupId!, ChatType.ChatRoom);
      }
      notifyList.remove(data);
      notifyListeners();
    } on EMError catch (e) {}
  }

  rejectInvitation(NotifyBean data) async {
    try {
      if (data.type == NotifyType.group) {
        await EMClient.getInstance.groupManager
            .declineInvitation(groupId: data.groupId!, inviter: data.inviter);
      } else {
        await EMClient.getInstance.contactManager
            .declineInvitation(data.inviter);
      }
      notifyList.remove(data);
      notifyListeners();
    } on EMError catch (e) {}
  }

  Future<EMGroup> fetchGroupInfoFromServer(String groupId) async {
    return await EMClient.getInstance.groupManager
        .fetchGroupInfoFromServer(groupId, fetchMembers: true);
  }

  leaveGroup(String groupId) async {
    try {
      await EMClient.getInstance.groupManager.leaveGroup(groupId);
    } on EMError catch (e) {}
  }

  destroyGroup(String groupId) async {
    try {
      await EMClient.getInstance.groupManager.destroyGroup(groupId);
    } on EMError catch (e) {}
  }

  sendTextMessage(
      ChatType chatType, String targetId, String messageContent) async {
    var msg = EMMessage.createTxtSendMessage(
        targetId: targetId, content: messageContent, chatType: chatType);
    addMessageToMap(targetId, msg);
    notifyListeners();
    await EMClient.getInstance.chatManager.sendMessage(msg);
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
          messageList.add(data);
        }
      }
      messageMap[id] = messageList;
      EMClient.getInstance.chatManager.importMessages(messageList);
      notifyListeners();
    } on EMError catch (e) {}
  }

  String getMessageText(EMMessage? message) {
    if (message == null) {
      return "去发送一个消息吧";
    }
    switch (message.body.type) {
      case MessageType.TXT:
        {
          EMTextMessageBody body = message.body as EMTextMessageBody;
          return body.content;
        }
      default:
        return "收到一个新消息";
    }
  }

  bool isEmpty(String? text) {
    return text?.isNotEmpty == true;
  }

  void removeImListener() {
    EMClient.getInstance.contactManager
        .removeEventHandler("UNIQUE_HANDLER_ID_1");

    EMClient.getInstance.chatManager.removeMessageEvent("UNIQUE_HANDLER_ID_2");
    EMClient.getInstance.chatManager.removeEventHandler("UNIQUE_HANDLER_ID_3");
    EMClient.getInstance.groupManager.removeEventHandler("UNIQUE_HANDLER_ID_4");
    // 解注册连接状态监听
    EMClient.getInstance.removeConnectionEventHandler(
      "UNIQUE_HANDLER_ID_5",
    );
  }
}
