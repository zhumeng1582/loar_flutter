import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/ex/ex_im.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';
import '../../common/colors.dart';
import '../../common/image.dart';
import '../../common/loading.dart';
import '../../common/routers/RouteNames.dart';
import '../../widget/baseTextField.dart';
import '../../widget/common.dart';

final searchProvider =
    ChangeNotifierProvider<SearchNotifier>((ref) => SearchNotifier());

class SearchNotifier extends ChangeNotifier {
  Map<String, EMUserInfo> userInfo = {};

  clear() {
    userInfo.clear();
  }

  fetchUserInfoById(List<String> contacts) async {
    Loading.show();

    var searchUserInfo =
        await EMClient.getInstance.userInfoManager.fetchUserInfoById(contacts);
    Loading.dismiss();

    clear();

    if (searchUserInfo.isNotEmpty) {
      searchUserInfo.forEach((key, value) {
        if (value.ext?.isNotEmpty == true) {
          userInfo[key] = value;
        }
      });
    }

    if (userInfo.isEmpty) {
      Loading.error("未查询到用户信息");
    }

    notifyListeners();
  }
}

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _userAccountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(searchProvider).clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, "搜索"),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                BaseTextField(
                  controller: _userAccountController,
                  hintText: "请输入要查询的账号",
                  style: TextStyle(color: AppColors.title),
                ).expanded(),
                Text(
                  "搜索",
                  style: TextStyle(color: AppColors.commonPrimary),
                ).paddingLeft(15.w).onTap(search),
              ],
            ).paddingVertical(32.w),
            SizedBox(
              height: 30.h,
            ),
            ...getUserList()
          ],
        ).paddingHorizontal(30.w),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _userAccountController.dispose();
  }
}

extension _Action on _SearchPageState {
  search() {
    ref.read(searchProvider).fetchUserInfoById([_userAccountController.text]);
  }
}

extension _UI on _SearchPageState {
  List<Widget> getUserList() {
    return ref
        .watch(searchProvider)
        .userInfo
        .values
        .map((e) => _buildUserItem(e))
        .toList();
  }

  Widget _getIcon(EMUserInfo data) {
    return ImageWidget(
      url: data.avatarName,
      width: 80.w,
      height: 80.h,
      radius: 6.r,
      type: ImageWidgetType.asset,
    );
  }

  Widget _buildUserItem(EMUserInfo data) {
    return Row(
      children: [
        _getIcon(data).paddingHorizontal(30.w),
        Text(data.userId).expanded(),
        Text(data.name),
      ],
    ).onTap(() {
      Navigator.pushNamed(
        context,
        RouteNames.usesInfoPage,
        arguments: data,
      );
    });
  }
}
