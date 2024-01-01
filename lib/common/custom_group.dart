import 'package:im_flutter_sdk/im_flutter_sdk.dart';

class CustomGroup {
  static String admin = "18888888888";
  static String sosGroupId = "sos";
  static String squareGroupId = "square";
  static EMConversation sosEMConversation =
      EMConversation.fromJson({"convId": sosGroupId, "type": 1});
  static EMConversation squareEMConversation =
      EMConversation.fromJson({"convId": squareGroupId, "type": 1});

  static EMGroup sosGroup =
      EMGroup.fromJson({"groupId": sosGroupId, "name": "SOS", "owner": admin});
  static EMGroup squareGroup = EMGroup.fromJson(
      {"groupId": squareGroupId, "name": "微蜂广场", "owner": admin});
}
