import '../contacts/contacts_list.dart';

enum MessageType { text, image, /*map, file,*/ audio, video }

class MessageItem {
  UserInfo userInfo = UserInfo();
  AudioFile audioFile = AudioFile("", 0);
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

  Map<String, dynamic> toJson() => {
        'text': text,
        'fileName': fileName,
        'time': time,
        'userInfo': userInfo.toJson(),
        'audioFile': audioFile?.toJson(),
        'messageType': messageType.name,
      };

  MessageItem.fromJson(Map<String, dynamic> json) {
    text = json["text"];
    fileName = json["fileName"];
    time = json["time"];
    userInfo = UserInfo.fromJson(json["userInfo"]);
    audioFile = AudioFile.fromJson(json["audioFile"]);
    messageType = MessageType.values.firstWhere(
        (element) => element.name == json["messageType"],
        orElse: () => MessageType.text);
  }
}

class AudioFile {
  int audioTimeLength = 0;
  int position = 0;
  bool isPlaying = false;
  bool isLoading = false;
  String fileName = "";

  AudioFile(this.fileName, this.audioTimeLength);

  Map<String, dynamic> toJson() => {
        'audioTimeLength': audioTimeLength,
        'position': position,
        'isPlaying': isPlaying,
        'isLoading': isLoading,
        'fileName': fileName,
      };

  AudioFile.fromJson(Map<String, dynamic> json) {
    audioTimeLength = json["audioTimeLength"];
    position = json["position"];
    isPlaying = json["isPlaying"];
    isLoading = json["isLoading"];
    fileName = json["fileName"];
  }
}
