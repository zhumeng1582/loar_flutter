import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/util/ex_im.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';
import 'package:loar_flutter/page/home/provider/im_message_provider.dart';

import '../../common/colors.dart';
import '../../common/image.dart';
import '../../common/loading.dart';
import '../../common/routers/RouteNames.dart';
import '../../common/util/gaps.dart';
import '../../common/util/images.dart';
import '../../widget/baseTextField.dart';

final searchProvider =
    ChangeNotifierProvider<SearchNotifier>((ref) => SearchNotifier());

class SearchNotifier extends ChangeNotifier {
  Map<String, EMUserInfo>? userInfo;

  clear() {
    userInfo = null;
  }

  fetchUserInfoById(List<String> contacts) async {
    Loading.show();
    userInfo = await EMClient.getInstance.userInfoManager
        .fetchUserInfoById(contacts)
        .catchError((value) => Loading.dismiss());
    Loading.dismiss();
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
      appBar: AppBar(
        title: Text("搜索"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
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
            ),
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
    var list = ref
        .watch(searchProvider)
        .userInfo
        ?.values
        .map((e) => _buildRoomItem(e))
        .toList();
    return list ?? [];
  }

  Widget _getIcon(EMUserInfo data) {
    return ImageWidget(
      url: data.avatarName,
      width: 80.w,
      height: 80.h,
      type: ImageWidgetType.asset,
    );
  }

  Widget _buildRoomItem(EMUserInfo data) {
    return Row(
      children: [
        _getIcon(data).paddingHorizontal(30.w),
        Text(data.userId),
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
