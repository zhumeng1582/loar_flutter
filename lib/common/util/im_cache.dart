import 'dart:convert';

import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/ex/ex_userInfo.dart';
import 'package:loar_flutter/common/util/storage.dart';

class ImCache {
  static const conversationsListKey = "conversationsList";
  static const contactsKey = "contacts";
  static const groupKey = "groupMap";
  static const allUsersKey = "allUsers";
  static const meKey = "me";
  static const mePassword = "mePassword";

  static saveConversationsList(List<EMConversation> conversationsList) {
    List<Map<String, dynamic>> saveData = [];
    for (var element in conversationsList) {
      saveData.add(element.toJson());
    }

    StorageUtils.saveList(conversationsListKey, saveData);
  }

  static Future<List<EMConversation>> getConversationsList() async {
    var list = await StorageUtils.loadList(conversationsListKey);
    List<EMConversation> ret = [];
    for (var element in list) {
      ret.add(EMConversation.fromJson(element));
    }
    return ret;
  }

  static saveContacts(List<String> contacts) {
    StorageUtils.save(contactsKey, contacts);
  }

  static Future<List<String>?> getContacts() async {
    return await StorageUtils.getListString(contactsKey);
  }

  static saveGroup(Map<String, EMGroup> group) {
    StorageUtils.saveMap(groupKey, group);
  }

  static Future<Map<String, EMGroup>> getGroup() async {
    var map = await StorageUtils.loadMap(groupKey);
    var ret = <String, EMGroup>{};
    map.forEach((key, value) {
      ret[key] = EMGroup.fromJson(value);
    });
    return ret;
  }

  static saveAllUser(Map<String, EMUserInfo> group) {
    StorageUtils.saveMap(allUsersKey, group);
  }

  static Future<Map<String, EMUserInfo>> getAllUser() async {
    var map = await StorageUtils.loadMap(allUsersKey);
    var ret = <String, EMUserInfo>{};
    map.forEach((key, value) {
      ret[key] = EMUserInfo.fromJson(value);
    });
    return ret;
  }

  static saveMe(EMUserInfo me) {
    StorageUtils.save(meKey, me.toJson());
  }

  static Future<EMUserInfo?> getMe() async {
    String me = (await StorageUtils.getString(meKey)) ?? "";
    if (me.isEmpty) {
      return null;
    }
    return EMUserInfo.fromJson(jsonDecode(me));
  }

  static savePassword(String password) {
    StorageUtils.save(mePassword, password);
  }

  static Future<String> getPassword() async {
    String password = (await StorageUtils.getString(mePassword)) ?? "";
    return password;
  }
}
