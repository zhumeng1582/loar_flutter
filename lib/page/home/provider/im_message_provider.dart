import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
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
    try {
      if (isConnectionSuccessful) {
        ImDataManager.instance.getUserInfo();

        List<EMConversation> result =
            await EMClient.getInstance.chatManager.loadAllConversations();
        contacts = await EMClient.getInstance.contactManager
            .getAllContactsFromServer();
        var contactsMap = await EMClient.getInstance.userInfoManager
            .fetchUserInfoById(contacts);
        contactsMap.forEach((key, value) {
          allUsers[key] = value;
        });
        conversationsList = await getConversationList(result);

        StorageUtils.saveList(Constant.contacts, contacts);
        StorageUtils.saveMap(Constant.allUsers, allUsers);
        StorageUtils.saveList(Constant.conversationsList, conversationsList);
      } else {
        contacts = StorageUtils.loadList(Constant.contacts) as List<String>;
        allUsers =
            StorageUtils.loadMap(Constant.allUsers) as Map<String, EMUserInfo>;

        conversationsList = StorageUtils.loadList(Constant.conversationsList)
            as List<ConversationBean>;
      }

      notifyListeners();
    } on EMError catch (e) {}
  }

  addMessageToMap(String conversationId, EMMessage message) {
    var messageList = messageMap[conversationId] ?? [];
    messageList.insert(0, message);
    messageMap[conversationId] = messageList;
  }

  addContacts(String userId) async {
    contacts =
        await EMClient.getInstance.contactManager.getAllContactsFromServer();
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

  Future<EMGroup?> createGroup() async {
    EMGroupOptions groupOptions = EMGroupOptions(
      style: EMGroupStyle.PrivateMemberCanInvite,
      inviteNeedConfirm: true,
      maxCount: 10,
    );

    try {
      return await EMClient.getInstance.groupManager.createGroup(
        options: groupOptions,
      );
    } on EMError catch (e) {}
    return null;
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
      } else {
        await EMClient.getInstance.contactManager
            .acceptInvitation(data.inviter);
      }
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
    } on EMError catch (e) {}
  }

  Future<EMGroup?> getGroupWithId(String roomId) async {
    try {
      return await EMClient.getInstance.groupManager.getGroupWithId(roomId);
    } on EMError catch (e) {}
  }

  addMembers(String groupId, List<String> members) async {
    try {
      await EMClient.getInstance.groupManager.addMembers(groupId, members);
    } on EMError catch (e) {}
  }

  sendTextMessage(String targetId, String messageContent) async {
    var msg = EMMessage.createTxtSendMessage(
      targetId: targetId,
      content: messageContent,
    );
    addMessageToMap(targetId, msg);
    notifyListeners();
    await EMClient.getInstance.chatManager.sendMessage(msg);
  }

  getHistoryMessage(ConversationBean conversationBean) async {
    try {
      EMCursorResult<EMMessage?> cursor =
          await EMClient.getInstance.chatManager.fetchHistoryMessages(
        conversationId: conversationBean.id,
        type: conversationBean.type,
      );
      List<EMMessage> messageList = [];
      for (var element in cursor.data) {
        if (element != null) {
          messageList.insert(0, element);
        }
      }
      messageMap[conversationBean.id] = messageList;
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

  Future<List<ConversationBean>> getConversationList(
      List<EMConversation> message) async {
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
          conversationsList.add(ConversationBean.createByConversation(
              value,
              "${lastMessage.localTime}",
              roomUserMap[lastMessage.from]?.nickName ?? "匿名",
              getMessageText(lastMessage), [
            roomUserMap[lastMessage.from]?.avatarUrl ??
                AssetsImages.getDefaultAvatar()
          ]));
        } else if (lastMessage.chatType == ChatType.GroupChat) {
          var group = await getGroupWithId(value.id);

          var roomUserMap = await EMClient.getInstance.userInfoManager
              .fetchUserInfoById(group?.memberList ?? []);

          roomUserMap.forEach((key, value) {
            allUsers[key] = value;
          });

          conversationsList.add(ConversationBean.createByConversation(
              value,
              "${lastMessage.serverTime}",
              group?.name ?? "群聊（${group?.memberList}）",
              getMessageText(lastMessage),
              roomUserMap.values
                  .map((e) => e.avatarUrl ?? AssetsImages.getDefaultAvatar())
                  .toList()));
        }
      }
    }

    var groupList =
        await EMClient.getInstance.groupManager.fetchJoinedGroupsFromServer();
    for (var group in groupList) {
      if (conversationsList.any((element) => element.id != group.groupId)) {
        var roomUserMap = await EMClient.getInstance.userInfoManager
            .fetchUserInfoById(group.memberList ?? []);

        roomUserMap.forEach((key, value) {
          allUsers[key] = value;
        });

        conversationsList.add(ConversationBean(
            group.groupId,
            "${0}",
            group.name ?? "群聊（${group.memberList}）",
            "马上发起群聊吧",
            roomUserMap.values
                .map((e) => e.avatarUrl ?? AssetsImages.getDefaultAvatar())
                .toList()));
      }
    }

    return conversationsList;
  }

  void removeImListener() {
    EMClient.getInstance.contactManager
        .removeEventHandler("UNIQUE_HANDLER_ID_1");
    EMClient.getInstance.chatManager.removeMessageEvent("UNIQUE_HANDLER_ID_2");
    EMClient.getInstance.chatManager.removeEventHandler("UNIQUE_HANDLER_ID_3");
  }
}
