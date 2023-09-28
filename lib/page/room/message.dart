import '../contacts/contacts_list.dart';

enum MessageType { text, image, /*map, file,*/ audio, video }

class MessageItem {
  UserInfo userInfo = UserInfo();
  AudioFile? audioFile;
  MessageType messageType = MessageType.text;
  String text = "您好呀";
  String fileName = "";
  String time = "";

  MessageItem.forText(String userId, this.text) {
    userInfo.id = userId;
    messageType = MessageType.text;
  }

  MessageItem.forAudio(String userId, this.fileName, int audioTimeLength) {
    userInfo.id = userId;
    messageType = MessageType.audio;
    audioFile = AudioFile(fileName, audioTimeLength);
  }
}

class AudioFile {
  int audioTimeLength = 0;
  int position = 0;
  bool isPlaying = false;
  String fileName = "";

  AudioFile(this.fileName, this.audioTimeLength);
}
