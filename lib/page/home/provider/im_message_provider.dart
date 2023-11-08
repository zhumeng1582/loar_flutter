import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

import '../../../common/account_data.dart';
import '../../../common/util/images.dart';
import '../bean/ConversationBean.dart';

final imProvider = ChangeNotifierProvider<ImNotifier>((ref) => ImNotifier());

class ImNotifier extends ChangeNotifier {
  List<ConversationBean> conversationsList = [];
  Map<String, EMUserInfo> contacts = {};
  Map<String, EMUserInfo> allUsers = {};
  Map<String, List<EMMessage>> messageMap = {};

  addMessageToMap(String conversationId, EMMessage message) {
    var messageList = messageMap[conversationId] ?? [];
    messageList.insert(0, message);
    messageMap[conversationId] = messageList;
  }

  String getAvatarUrl(String? userId) {
    if (allUsers.containsKey(userId)) {
      return allUsers[userId]?.avatarUrl ?? AssetsImages.getRandomAvatar();
    }
    if (contacts.containsKey(userId)) {
      return contacts[userId]?.avatarUrl ?? AssetsImages.getRandomAvatar();
    }

    if (AccountData.instance.me.userId == userId) {
      return AccountData.instance.me.avatarUrl ??
          AssetsImages.getRandomAvatar();
    }
    return AssetsImages.getRandomAvatar();
  }

  void addImListener() {
    EMClient.getInstance.contactManager.addEventHandler(
      "UNIQUE_HANDLER_ID_1",
      EMContactEventHandler(
        onFriendRequestAccepted: (userId) {},
        onContactInvited: (userId, reason) {},
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

  acceptInvitation(String userId) async {
    try {
      await EMClient.getInstance.contactManager.acceptInvitation(userId);
    } on EMError catch (e) {}
  }

  Future<EMChatRoom?> getChatRoomWithId(String roomId) async {
    try {
      return await EMClient.getInstance.chatRoomManager
          .getChatRoomWithId(roomId);
    } on EMError catch (e) {}
  }

  init() async {
    try {
      AccountData.instance.getUserInfo();

      List<EMConversation> result =
          await EMClient.getInstance.chatManager.loadAllConversations();

      List<String> contacts =
          await EMClient.getInstance.contactManager.getAllContactsFromServer();

      this.contacts = await EMClient.getInstance.userInfoManager
          .fetchUserInfoById(contacts);
      this.contacts.forEach((key, value) {
        allUsers[key] = value;
      });

      getConversationList(result);
      notifyListeners();
    } on EMError catch (e) {}
  }

  addTextMessage(String targetId, String messageContent) async {
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

  getConversationList(List<EMConversation> message) async {
    conversationsList.clear();
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
            roomUserMap[lastMessage.from]?.avatarUrl ?? AssetsImages.getDefaultAvatar()
          ]));
        } else if (lastMessage.chatType == ChatType.ChatRoom) {
          var chatRoom = await getChatRoomWithId(value.id);

          var roomUserMap = await EMClient.getInstance.userInfoManager
              .fetchUserInfoById(chatRoom?.memberList ?? []);

          roomUserMap.forEach((key, value) {
            allUsers[key] = value;
          });

          conversationsList.add(ConversationBean.createByConversation(
              value,
              "${lastMessage.serverTime}",
              chatRoom?.name ?? "群聊（${chatRoom?.memberList}）",
              getMessageText(lastMessage),
              roomUserMap.values
                  .map((e) => e.avatarUrl ?? AssetsImages.getDefaultAvatar())
                  .toList()));
        }
      }
    }
    notifyListeners();
  }

  void removeImListener() {
    EMClient.getInstance.contactManager
        .removeEventHandler("UNIQUE_HANDLER_ID_1");
    EMClient.getInstance.chatManager.removeMessageEvent("UNIQUE_HANDLER_ID_2");
    EMClient.getInstance.chatManager.removeEventHandler("UNIQUE_HANDLER_ID_3");
  }
}
