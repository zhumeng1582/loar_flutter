import 'package:im_flutter_sdk/im_flutter_sdk.dart';

import 'images.dart';

extension ExWidget on EMUserInfo? {
  String get avatarName {
    return this?.avatarUrl ?? AssetsImages.getDefaultAvatar();
  }

  String get name {
    return this?.nickName?.trim() ?? "微蜂用户${this?.userId.substring(-4)}";
  }
}
