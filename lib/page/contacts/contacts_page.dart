import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/ex/ex_im.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';
import 'package:loar_flutter/page/home/provider/im_message_provider.dart';
import 'package:nine_grid_view/nine_grid_view.dart';

import '../../common/colors.dart';
import '../../common/image.dart';
import '../../common/routers/RouteNames.dart';
import '../../common/util/gaps.dart';
import '../../common/util/images.dart';
import '../home/bean/conversation_bean.dart';
import '../home/provider/home_provider.dart';

class ContactsPage extends ConsumerStatefulWidget {
  const ContactsPage({super.key});

  @override
  ConsumerState<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends ConsumerState<ContactsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, EMGroup> groupMap = ref.watch(imProvider).groupMap;
    List<String> contacts = ref.watch(imProvider).contacts;
    List<dynamic> data = [0, ...contacts, ...groupMap.values];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bottomBackground,
        title: Text("通讯录"),
        centerTitle: true,
        actions: [
          ImageWidget(
            url: AssetsImages.iconScan,
            width: 46.w,
            height: 46.h,
            type: ImageWidgetType.asset,
          ).paddingRight(30.w).onTap(scan)
        ],
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          var item = data[index];
          if (item is String) {
            var userInfo = ref.read(imProvider).getUserInfo(item);
            if (userInfo != null) {
              return _buildRoomItem(userInfo).onTap(() {
                _userRoom(userInfo);
              });
            } else {
              Container();
            }
          } else if (item is EMGroup) {
            return _buildRoomGroupItem(item).onTap(() {
              _groupRoom(item);
            });
          } else {
            return _buildSearch();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

extension _UI on _ContactsPageState {
  Widget _buildSearch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImageWidget(
          url: AssetsImages.iconSearch,
          width: 46.w,
          height: 46.h,
          type: ImageWidgetType.asset,
        ),
        Text("搜索")
      ],
    )
        .padding(vertical: 5.h)
        .roundedBorder(radius: 10, color: AppColors.buttonDisableColor)
        .padding(
          vertical: 25.h,
          horizontal: 32.w,
        )
        .onTap(search);
  }

  Widget _getIcon(EMUserInfo data) {
    return ImageWidget(
      url: data.avatarName,
      width: 80.w,
      height: 80.h,
      type: ImageWidgetType.asset,
    );
  }

  Widget _getGroupIcon(EMGroup data) {
    var users = data.allUsers;
    return NineGridView(
      width: 80.w,
      height: 80.h,
      type: NineGridType.weChatGp,
      itemCount: users.length,
      itemBuilder: (BuildContext context, int index) {
        return ImageWidget(
          url: ref.watch(imProvider).getAvatarUrl(users[index]),
          type: ImageWidgetType.asset,
        );
      },
    );
  }

  Widget _buildRoomItem(EMUserInfo data) {
    return Column(
      children: [
        Row(
          children: [
            _getIcon(data).paddingHorizontal(30.w),
            Text(data.userId).expanded(),
            Text(data.name).paddingHorizontal(30.w),
          ],
        ),
        Gaps.line.paddingLeft(140.w).paddingVertical(15.h)
      ],
    ).paddingTop(3.h);
  }

  Widget _buildRoomGroupItem(EMGroup data) {
    return Column(
      children: [
        Row(
          children: [
            _getGroupIcon(data).paddingHorizontal(30.w),
            Text(data.showName).expanded(),
            Text("${data.allUsers.length}人").paddingHorizontal(30.w),
          ],
        ),
        Gaps.line.paddingLeft(140.w).paddingVertical(15.h)
      ],
    ).paddingTop(3.h);
  }
}

extension _Action on _ContactsPageState {
  search() async {
    Navigator.pushNamed(
      context,
      RouteNames.searchPage,
    );
  }

  scan() async {
    var qrCodeData = await ref.read(homeProvider).scan();
    if (qrCodeData.userInfo != null) {
    } else if (qrCodeData.room != null) {}
  }

  _userRoom(EMUserInfo data) {
    Navigator.pushNamed(
      context,
      RouteNames.roomPage,
      arguments: EMConversation.fromJson({"convId": data.userId, "type": 0}),
    );
  }

  _groupRoom(EMGroup data) {
    Navigator.pushNamed(
      context,
      RouteNames.roomPage,
      arguments: EMConversation.fromJson({"convId": data.groupId, "type": 1}),
    );
  }
}
