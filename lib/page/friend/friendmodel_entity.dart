class FriendmodelEntity {
  List<FriendmodelData> data = [];

  FriendmodelEntity({required this.data});

  FriendmodelEntity.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      for (var v in (json['data'] as List)) {
        data.add(FriendmodelData.fromJson(v));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['data'] = this.data.map((v) => v.toJson()).toList();
    return data;
  }
}

class FriendmodelData {
  String head = "";
  String name = "";
  String time = "";
  List<String> pics = [];
  String desc = "";

  FriendmodelData(
      {required this.head,
      required this.name,
      required this.time,
      required this.pics,
      required this.desc});

  FriendmodelData.fromJson(Map<String, dynamic> json) {
    head = json['head'];
    name = json['name'];
    time = json['time'];
    pics = json['pics']?.cast<String>();
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['head'] = this.head;
    data['name'] = this.name;
    data['time'] = this.time;
    data['pics'] = this.pics;
    data['desc'] = this.desc;
    return data;
  }
}
