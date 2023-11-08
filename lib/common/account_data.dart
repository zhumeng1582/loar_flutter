import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/util/images.dart';

class AccountData {
  AccountData._();

  static AccountData get instance => _getInstance();
  static AccountData? _instance;

  static AccountData _getInstance() {
    _instance ??= AccountData._();
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
