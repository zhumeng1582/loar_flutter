import 'package:im_flutter_sdk/im_flutter_sdk.dart';

import '../util/images.dart';

extension ExUserInfo on EMUserInfo? {
  String get avatarName {
    return this?.avatarUrl ?? AssetsImages.getDefaultAvatar();
  }

  String get name {
    return this?.nickName?.trim() ?? "微蜂用户${this?.userId.substring(-4) ?? ""}";
  }
}

extension ExGroup on EMGroup? {
  int get userCount {
    return (this?.memberList?.length ?? 0) + (this?.adminList?.length ?? 0) + 1;
  }

  String get showName {
    if (this?.name?.trim().isNotEmpty == true) {
      return this!.name!.trim();
    }
    return "群聊（${(userCount)})";
  }

  List<String> get allUsers {
    return [
      this?.owner ?? "",
      ...this?.adminList ?? [],
      ...this?.memberList ?? []
    ];
  }
}
