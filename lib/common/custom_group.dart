import 'package:im_flutter_sdk/im_flutter_sdk.dart';

class CustomGroup {
  static String admin = "10000000000";
  static String squareGroupId = "888881";
  static String sosGroupId = "888882";
  static String allUserGroup = "235958320562181";
  static List<String> hideAllGroup = [sosGroupId, squareGroupId, allUserGroup];

  static EMConversation sosEMConversation =
      EMConversation.fromJson({"convId": sosGroupId, "type": 1});
  static EMConversation squareEMConversation =
      EMConversation.fromJson({"convId": squareGroupId, "type": 1});

  static EMGroup sosGroup =
      EMGroup.fromJson({"groupId": sosGroupId, "name": "SOS", "owner": admin});
  static EMGroup squareGroup = EMGroup.fromJson(
      {"groupId": squareGroupId, "name": "微蜂广场", "owner": admin});

  static bool hideMore(String conversationId) {
    return conversationId == squareGroupId || conversationId == sosGroupId;
  }
}
