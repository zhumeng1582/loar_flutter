import 'dart:math';

class Packet {
  List<int> data = [];
  List<int> dataHead = [];
  List<int> messageId = [];

  String getMessageId() {
    return "${messageId[0]}${messageId[1]}";
  }

  //数据包的总长度，非当前包长度
  int length = 0;

  Packet(this.dataHead, this.messageId, this.length, this.data);

  Packet.fromIntList(List<int> listData) {
    dataHead = listData.sublist(0, 2);
    messageId = listData.sublist(2, 4);
    length = listData[4];
    data = listData.sublist(5, listData.length);
  }

  List<int> toIntList() {
    return [
      ...dataHead,
      ...messageId,
      ...[length],
      ...data
    ];
  }

  static List<List<int>> splitData(List<int> longData, int splitLength) {
    //减去包头5个字节，
    splitLength = splitLength - 5;

    var random = Random();
    var messageId1 = random.nextInt(255);
    var messageId2 = random.nextInt(255);
    List<List<int>> packets = [];
    for (int i = 0; i < longData.length; i += splitLength) {
      List<int> part =
          longData.sublist(i, min(i + splitLength, longData.length));
      Packet packet =
          Packet([0x67, 0x89], [messageId1, messageId2], longData.length, part);
      packets.add(packet.toIntList());
    }
    return packets;
  }
}
