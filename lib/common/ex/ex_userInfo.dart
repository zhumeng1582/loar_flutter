import 'package:loar_flutter/common/proto/index.dart';

import '../account_data.dart';

extension ExUserInfo on UserInfo {
  String get getRoomId {
    var id1 = AccountData.instance.me.id;
    if (id1.compareTo(id) < 0) {
      return '$id1-$id';
    } else {
      return '$id-$id1';
    }
  }
}

extension ExRoom on RoomInfo {
  addUserList(List<UserInfo> list) {
    for (var element in list) {
      if (!_containsUserInfo(element)) {
        userList.add(element);
      }
    }
  }

  bool _containsUserInfo(UserInfo userInfo) {
    return userList.any((element) => userInfo.id == element.id);
  }
}

extension ExAllChatInfo on AllChatInfo {
  RoomInfo getRoomById(String id) {
    return roomList.firstWhere((element) => element.id == id);
  }

  addUserInfo(List<UserInfo> list) {
    for (var element in list) {
      if (!_containsUserInfo(element)) {
        userList.insert(0, element);
      }
    }
  }

  addGroup(List<RoomInfo> list) {
    for (var element in list) {
      if (!_containsRoom(element)) {
        roomList.insert(0, element);
      }
    }
  }

  bool _containsUserInfo(UserInfo userInfo) {
    return userList.any((element) => userInfo.id == element.id);
  }

  bool _containsRoom(RoomInfo roomInfo) {
    return roomList.any((element) => roomInfo.id == element.id);
  }
}
