import 'package:im_flutter_sdk/im_flutter_sdk.dart';

// class ConversationBean {
//   // 0:私聊，1：群聊
//   int _type = 0;
//   String id = '';
//   String time = '';
//   String title = '';
//   String message = '';
//   List<String> avatarUrls = [];
//
//   EMConversationType getConversationType() {
//     return _type == 0 ? EMConversationType.Chat : EMConversationType.GroupChat;
//   }
//
//   ChatType getChatType() {
//     return _type == 0 ? ChatType.Chat : ChatType.GroupChat;
//   }
//
//   ConversationBean(this._type, this.id, this.time, this.title, this.message,
//       this.avatarUrls);
//
//   ConversationBean.fromJson(Map<String, dynamic> json) {
//     _type = json['type'] ?? 0;
//     id = json['id'] ?? "";
//     time = json['time'] ?? "";
//     title = json['title'] ?? "";
//     message = json['message'] ?? "";
//     avatarUrls = List<String>.from(json['avatarUrls']).toList();
//   }
//
//   toJson() {
//     return {
//       'type': _type,
//       'id': id,
//       'time': time,
//       'title': title,
//       'message': message,
//       'avatarUrls': avatarUrls,
//     };
//   }
// }
