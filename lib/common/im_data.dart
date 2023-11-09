import 'package:im_flutter_sdk/im_flutter_sdk.dart';
class ImDataManager {
  ImDataManager._();

  static ImDataManager get instance => _getInstance();
  static ImDataManager? _instance;

  static ImDataManager _getInstance() {
    _instance ??= ImDataManager._();
    return _instance!;
  }

  late EMUserInfo me;

  getUserInfo() async {
    try {
      var value = await EMClient.getInstance.userInfoManager.fetchOwnInfo();
      if (value != null) {
        me = value;
      }
    } on EMError catch (e) {
      // 获取当前用户属性失败，返回错误信息。
    }
  }
}
