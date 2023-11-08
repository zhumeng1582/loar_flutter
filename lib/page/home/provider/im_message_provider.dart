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
  List<EMChatRoom> chatRoomList = [];
  Map<String, List<EMMessage>> messageMap = {};

  addMessageToMap(String conversationId, EMMessage message) {
    var messageList = messageMap[conversationId] ?? [];
    messageList.insert(0, message);
    messageMap[conversationId] = messageList;
  }

  String? getAvatarUrl(String? userId) {
    if (AccountData.instance.me.userId == userId) {
      return AccountData.instance.me.avatarUrl;
    }
    return contacts[userId]?.avatarUrl;
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

  addContact(userId, reason) async {
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

  init() async {
    try {
      AccountData.instance.getUserInfo();
      List<EMConversation> result =
          await EMClient.getInstance.chatManager.loadAllConversations();

      List<String> contacts =
          await EMClient.getInstance.contactManager.getAllContactsFromDB();

      this.contacts = await EMClient.getInstance.userInfoManager
          .fetchUserInfoById(contacts);
      var roomResult = await EMClient.getInstance.chatRoomManager
          .fetchPublicChatRoomsFromServer();
      chatRoomList = roomResult.data ?? [];
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
          var user = await EMClient.getInstance.userInfoManager
              .fetchUserInfoById([lastMessage.from!]);
          conversationsList.add(ConversationBean.createByConversation(
              value,
              "${lastMessage.localTime}",
              user[lastMessage.from]?.nickName ?? "匿名",
              getMessageText(lastMessage), [
            user[lastMessage.from]?.avatarUrl ?? AssetsImages.getRandomAvatar()
          ]));
        } else if (lastMessage.chatType == ChatType.ChatRoom) {
          var room = chatRoomList
              .firstWhere((element) => element.roomId == lastMessage.from);
          var roomUserMap = await EMClient.getInstance.userInfoManager
              .fetchUserInfoById(room.memberList ?? []);

          conversationsList.add(ConversationBean.createByConversation(
              value,
              "${lastMessage.serverTime}",
              room.name ?? "群聊（${room.memberList}）",
              getMessageText(lastMessage),
              roomUserMap.values
                  .map((e) => e.avatarUrl ?? AssetsImages.getRandomAvatar())
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
