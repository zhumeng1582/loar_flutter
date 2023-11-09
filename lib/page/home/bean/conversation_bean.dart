import 'package:im_flutter_sdk/im_flutter_sdk.dart';

class ConversationBean {
  EMConversationType type = EMConversationType.Chat;
  String id = "";
  String time;
  String title;
  String message;
  List<String> avatarUrls;

  ConversationBean.createByConversation(EMConversation conversation, this.time,
      this.title, this.message, this.avatarUrls) {
    type = conversation.type;
    id = conversation.id;
  }

  ConversationBean(
      this.id, this.time, this.title, this.message, this.avatarUrls) {}
}
