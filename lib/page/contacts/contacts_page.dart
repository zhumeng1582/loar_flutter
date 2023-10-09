import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/common/global_data.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';
import 'package:loar_flutter/page/home/home_page.dart';
import 'package:nine_grid_view/nine_grid_view.dart';

import '../../common/image.dart';
import '../../common/proto/index.dart';
import '../../common/routers/RouteNames.dart';
import '../../common/util/gaps.dart';

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
    List<UserInfo> data = ref.watch(homeProvider).userInfoList.userList;
    return Scaffold(
      appBar: AppBar(
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
      type: ImageWidgetType.network,
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
    Navigator.pushNamed(
      context,
      RouteNames.roomPage,
      arguments: _getRoomId(data),
    );
  }

  //生成两个用户的房间号
  String _getRoomId(UserInfo data) {
    var id1 = GlobalData.instance.me.id;
    var id2 = data.id;
    if (id1.compareTo(id2) < 0) {
      return '$id1-$id2';
    } else {
      return '$id2-$id1';
    }
  }
}
