import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/common/account_data.dart';
import 'package:loar_flutter/common/ex/ex_userInfo.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';

import '../../common/colors.dart';
import '../../common/image.dart';
import '../../common/proto/index.dart';
import '../../common/routers/RouteNames.dart';
import '../../common/util/gaps.dart';
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
    List<UserInfo> data = ref.watch(homeProvider).allChatInfo.userList;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bottomBackground,
        title: Text("联系人"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'Scan',
            onPressed: ref.read(homeProvider).scan,
          )
        ],
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildRoomItem(data[index]).onTap(() {
            _room(data[index]);
          });
          ;
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
  Widget _getIcon(UserInfo data) {
    return ImageWidget(
      url: data.icon,
      width: 80.w,
      height: 80.h,
      type: ImageWidgetType.asset,
    );
  }

  Widget _buildRoomItem(UserInfo data) {
    return Column(
      children: [
        Row(
          children: [
            _getIcon(data).paddingHorizontal(30.w),
            Text(data.name),
          ],
        ),
        Gaps.line.paddingLeft(140.w).paddingVertical(15.h)
      ],
    );
  }
}

extension _Action on _ContactsPageState {
  _room(UserInfo data) {
    bool isRoomExist = ref
        .read(homeProvider)
        .allChatInfo
        .roomList
        .any((element) => element.id == data.getRoomId);
    if (!isRoomExist) {
      var roomInfo = RoomInfo();
      roomInfo.id = data.getRoomId;
      roomInfo.userList.add(AccountData.instance.me);
      roomInfo.userList.add(data);
      roomInfo.name = data.name;
      ref.read(homeProvider).allChatInfo.roomList.insert(0,roomInfo);
    }
    Navigator.pushNamed(
      context,
      RouteNames.roomPage,
      arguments: data.getRoomId,
    );
  }
}
