import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/util/ex_im.dart';
import 'package:loar_flutter/common/util/storage.dart';

import '../../../common/constant.dart';
import '../../../common/im_data.dart';
import '../../../common/util/images.dart';
import '../../../main.dart';
import '../bean/conversation_bean.dart';
import '../bean/notify_bean.dart';

final imProvider = ChangeNotifierProvider<ImNotifier>((ref) => ImNotifier());

class ImNotifier extends ChangeNotifier {
  List<ConversationBean> conversationsList = [];
  List<NotifyBean> notifyList = [];
  List<String> contacts = [];
  Map<String, EMUserInfo> allUsers = {};
  Map<String, List<EMMessage>> messageMap = {};

  init() async {
    if (true) {
      ImDataManager.instance.getUserInfo();

      // EMCursorResult<EMConversation> result =
      // await EMClient.getInstance.chatManager.fetchConversation();

      contacts =
          await EMClient.getInstance.contactManager.getAllContactsFromServer();
      var contactsMap = await EMClient.getInstance.userInfoManager
          .fetchUserInfoById(contacts);
      contactsMap.forEach((key, value) {
        allUsers[key] = value;
      });

      conversationsList = await getConversationList();

      // StorageUtils.saveList(Constant.contacts, contacts);
      // StorageUtils.saveMap(Constant.allUsers, allUsers);
      // StorageUtils.saveList(Constant.conversationsList, conversationsList);
    } else {
      contacts = StorageUtils.loadList(Constant.contacts) as List<String>;
      allUsers =
          StorageUtils.loadMap(Constant.allUsers) as Map<String, EMUserInfo>;

      conversationsList = StorageUtils.loadList(Constant.conversationsList)
          as List<ConversationBean>;
    }

    notifyListeners();
  }

  addMessageToMap(String conversationId, EMMessage message) async {
    var messageList = messageMap[conversationId] ?? [];
    messageList.insert(0, message);
    messageMap[conversationId] = messageList;
    EMClient.getInstance.chatManager.importMessages([message]);
    ConversationBean conversationBean =
        await messageToConversation(message, conversationId);

    int index =
        conversationsList.indexWhere((element) => element.id == conversationId);

    if (index == -1) {
      conversationsList.insert(0, conversationBean);
    } else {
      conversationsList.removeAt(index);
      conversationsList.insert(index, conversationBean);
    }

    notifyListeners();
  }

  Future<ConversationBean> messageToConversation(
      EMMessage message, String conversationId) async {
    ConversationBean conversationBean;
    if (message.chatType == ChatType.Chat) {
      conversationBean = ConversationBean(
          0,
          conversationId,
          "${DateTime.now().millisecondsSinceEpoch}",
          allUsers[conversationId].name,
          getMessageText(message),
          [allUsers[conversationId].avatarName]);
    } else {
      var group = await fetchGroupInfoFromServer(conversationId);

      var roomUser = [group.owner ?? ""];
      roomUser.addAll(group.memberList ?? []);
      roomUser.addAll(group.adminList ?? []);
      var roomUserMap = await EMClient.getInstance.userInfoManager
          .fetchUserInfoById(roomUser);

      roomUserMap.forEach((key, value) {
        allUsers[key] = value;
      });

      conversationBean = ConversationBean(
          1,
          conversationId,
          "${DateTime.now().millisecondsSinceEpoch}",
          isEmpty(group.name) ? group.name! : "群聊（${(roomUserMap.length)})",
          getMessageText(message),
          roomUserMap.values.map((e) => e.avatarName).toList());
    }
    return conversationBean;
  }

  addContacts(String userId) async {
    var contactsMap =
        await EMClient.getInstance.userInfoManager.fetchUserInfoById([userId]);
    if (!contacts.contains(userId)) {
      contacts.add(userId);
    }

    if (contactsMap[userId] != null) {
      allUsers[userId] = contactsMap[userId]!;
    }

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
    EMClient.getInstance.groupManager.addEventHandler(
        "UNIQUE_HANDLER_ID_1",
        EMGroupEventHandler(
          onInvitationAcceptedFromGroup: (groupId, userId, reason) {},
          onInvitationReceivedFromGroup: (
            groupId,
            groupName,
            inviter,
            reason,
          ) {
            notifyList.add(NotifyBean(NotifyType.group, inviter,
                "${DateTime.now().millisecondsSinceEpoch}",
                groupId: groupId, name: groupName, reason: reason));
            // EMClient.getInstance.groupManager.acceptInvitation(groupId, inviter);
          },
        ));
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
        await groupToConversation(conversationsList);
      } else {
        await EMClient.getInstance.contactManager
            .acceptInvitation(data.inviter);
        contacts = await EMClient.getInstance.contactManager
            .getAllContactsFromServer();
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

  addMembers(String groupId, List<String> members) async {
    try {
      await EMClient.getInstance.groupManager.addMembers(groupId, members);
    } on EMError catch (e) {}
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

  getHistoryMessage(ConversationBean conversationBean) async {
    try {
      EMCursorResult<EMMessage?> cursor =
          await EMClient.getInstance.chatManager.fetchHistoryMessages(
        conversationId: conversationBean.id,
        type: conversationBean.getConversationType(),
      );
      List<EMMessage> messageList = [];
      for (var element in cursor.data) {
        if (element != null) {
          messageList.insert(0, element);
        }
      }
      messageMap[conversationBean.id] = messageList;

      EMClient.getInstance.chatManager.importMessages(messageList);
      notifyListeners();
    } on EMError catch (e) {}
  }

  String getMessageText(EMMessage message) {
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

  Future<List<ConversationBean>> getConversationList() async {
    List<EMConversation> message =
        await EMClient.getInstance.chatManager.loadAllConversations();

    List<ConversationBean> conversationsList = [];
    for (var value in message) {
      var lastMessage = await value.lastReceivedMessage();
      if (lastMessage != null) {
        if (lastMessage.chatType == ChatType.Chat) {
          var roomUserMap = await EMClient.getInstance.userInfoManager
              .fetchUserInfoById([lastMessage.from!]);
          roomUserMap.forEach((key, value) {
            allUsers[key] = value;
          });
          conversationsList.add(ConversationBean(
              0,
              value.id,
              "${lastMessage.localTime}",
              roomUserMap[lastMessage.from]!.name,
              getMessageText(lastMessage), [
            roomUserMap[lastMessage.from]?.avatarUrl ??
                AssetsImages.getDefaultAvatar()
          ]));
        } else if (lastMessage.chatType == ChatType.GroupChat) {
          var group = await fetchGroupInfoFromServer(value.id);

          var roomUser = [group.owner ?? ""];
          roomUser.addAll(group.memberList ?? []);
          roomUser.addAll(group.adminList ?? []);
          var roomUserMap = await EMClient.getInstance.userInfoManager
              .fetchUserInfoById(roomUser);

          roomUserMap.forEach((key, value) {
            allUsers[key] = value;
          });

          conversationsList.add(ConversationBean(
              1,
              value.id,
              "${lastMessage.serverTime}",
              isEmpty(group.name) ? group.name! : "群聊（${(roomUserMap.length)})",
              getMessageText(lastMessage),
              roomUserMap.values.map((e) => e.avatarName).toList()));
        }
      }
    }

    await groupToConversation(conversationsList);

    return conversationsList;
  }

  Future<void> groupToConversation(
      List<ConversationBean> conversationsList) async {
    var groupList =
        await EMClient.getInstance.groupManager.fetchJoinedGroupsFromServer();
    for (var group in groupList) {
      if (!conversationsList.any((element) => element.id == group.groupId)) {
        var groupInfo = await fetchGroupInfoFromServer(group.groupId);
        var roomUser = [group.owner ?? ""];
        roomUser.addAll(groupInfo.memberList ?? []);
        roomUser.addAll(groupInfo.adminList ?? []);
        var roomUserMap = await EMClient.getInstance.userInfoManager
            .fetchUserInfoById(roomUser);

        roomUserMap.forEach((key, value) {
          allUsers[key] = value;
        });
        roomUserMap[ImDataManager.instance.me.userId] =
            ImDataManager.instance.me;

        conversationsList.add(ConversationBean(
            1,
            groupInfo.groupId,
            "${0}",
            isEmpty(groupInfo.name)
                ? groupInfo.name!
                : "群聊（${(roomUserMap.length)})",
            "马上发起群聊吧",
            roomUserMap.values.map((e) => e.avatarName).toList()));
      }
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
  }
}
