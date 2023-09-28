import '../contacts/contacts_list.dart';

enum MessageType { text, image, /*map, file,*/ audio, video }

class MessageItem {
  UserInfo userInfo = UserInfo();
  AudioFile? audioFile;
  MessageType messageType = MessageType.text;
  String text = "您好呀";
  String fileName = "";
  String time = "";

  MessageItem.forText(String userId,this.text) {
    userInfo.id = userId;
    messageType = MessageType.text;
  }

  MessageItem.forAudio(String userId, this.fileName,double audioTimeLength) {
    userInfo.id = userId;
    messageType = MessageType.audio;
    audioFile = AudioFile(fileName, audioTimeLength);
  }
}

class AudioFile {
  double audioTimeLength = 0;
  String fileName = "";

  AudioFile(this.fileName, this.audioTimeLength);
}
