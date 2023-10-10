import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/common/account_data.dart';
import 'package:loar_flutter/common/ex/ex_string.dart';
import 'package:loar_flutter/common/ex/ex_userInfo.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';
import 'package:loar_flutter/page/home/home_page.dart';
import 'package:nine_grid_view/nine_grid_view.dart';

import '../../common/image.dart';
import '../../common/proto/index.dart';
import '../../common/routers/RouteNames.dart';
import '../../common/util/gaps.dart';

final contractSelectProvider = ChangeNotifierProvider<ContactsSelectNotifier>(
    (ref) => ContactsSelectNotifier());

class ContactsSelectNotifier extends ChangeNotifier {
  List<UserInfo> data = [];
  late RoomInfo roomInfo;

  initData(List<UserInfo> data, RoomInfo roomInfo) {
    this.roomInfo = roomInfo;
    this.data = data.where((element) => !isInRoom(roomInfo, element)).toList();
    notifyListeners();
  }

  bool isInRoom(RoomInfo room, UserInfo userInfo) {
    return room.userList.any((element) => element.id == userInfo.id);
  }
}

class ContactsSelectPage extends ConsumerStatefulWidget {
  String roomId;

  ContactsSelectPage({super.key, required this.roomId});

  @override
  ConsumerState<ContactsSelectPage> createState() => _ContactsSelectPageState();
}

class _ContactsSelectPageState extends ConsumerState<ContactsSelectPage> {
  @override
  void initState() {
    Future(() {
      var userList = ref.read(homeProvider).allChatInfo.userList;
      var roomInfo =
          ref.read(homeProvider).allChatInfo.getRoomById(widget.roomId);
      ref.read(contractSelectProvider).initData(userList, roomInfo);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<UserInfo> data = ref.watch(contractSelectProvider).data;

    return Scaffold(
      appBar: AppBar(
        title: Text("选择联系人"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildCellItem(data[index]).onTap(() {
            _selectUser(data[index]);
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

extension _UI on _ContactsSelectPageState {
  Widget _getIcon(UserInfo data) {
    return ImageWidget(
      url: data.icon,
      width: 40.w,
      height: 40.h,
      type: ImageWidgetType.asset,
    );
  }

  Widget _buildCellItem(UserInfo data) {
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

extension _Action on _ContactsSelectPageState {
  _selectUser(UserInfo data) {
    Navigator.pop(context, [data]);
  }
}
