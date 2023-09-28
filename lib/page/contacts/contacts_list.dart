class UserInfo {
  UserInfo();
  String id = "";
  String icon =
      "https://img0.baidu.com/it/u=1691000662,1326044609&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1695834000&t=804a82ed014a5bcbe6c69e1a74228a29";
  String name = "联系人1";

  Map<String, dynamic> toJson() => {
    'id': id,
    'icon': icon,
    'name': name,
  };
  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    icon = json["icon"];
    name = json["name"];
  }
}
