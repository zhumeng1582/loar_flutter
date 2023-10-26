import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/common/ex/ex_string.dart';
import 'package:loar_flutter/common/account_data.dart';
import 'package:loar_flutter/common/proto/index.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';
import 'package:loar_flutter/page/home/provider/home_provider.dart';
import 'package:nine_grid_view/nine_grid_view.dart';

import '../../common/colors.dart';
import '../../common/image.dart';
import '../../common/routers/RouteNames.dart';
import '../../common/util/gaps.dart';
import '../../common/util/images.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<RoomInfo> data = ref.watch(homeProvider).allChatInfo.roomList;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bottomBackground,
        title: Text("聊天"),
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
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

extension _Action on _HomePageState {
  _room(RoomInfo data) {
    Navigator.pushNamed(
      context,
      RouteNames.roomPage,
      arguments: data.id,
    );
  }

  _getFirstText(List<ChatMessage> list) {
    if (list.isEmpty) {
      return "";
    }
    var first = list.first;
    var message = "[收到新消息]";
    switch (first.messageType) {
      case MessageType.TEXT:
        message = first.content;
        break;
      case MessageType.NEW_USER:
        message = "${first.sender.name}加入群聊";
        break;
      case MessageType.MAP:
        message = "${first.sender.name}发送了位置";
        break;
    }
    return message;
  }

  _getLastTime(List<ChatMessage> list) {
    return list.isNotEmpty ? list.last.sendtime.formatChatTime : "";
  }
}

extension _UI on _HomePageState {
  Widget _buildRoomItem(RoomInfo data) {
    return Column(
      children: [
        Row(
          children: [
            _getIcon(data).paddingHorizontal(30.w),
            Expanded(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.name,
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: AppColors.title,
                              ),
                            ),
                            Text(
                              _getFirstText(data.messagelist),
                              style: TextStyle(
                                fontSize: 22.sp,
                                color: AppColors.title.withOpacity(0.6),
                              ),
                            )
                          ],
                        ),
                      ),
                      Text(_getLastTime(data.messagelist),
                          style: TextStyle(
                            fontSize: 22.sp,
                            color: AppColors.title.withOpacity(0.6),
                          )).paddingHorizontal(30.h),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ).paddingTop(5.h),
        Gaps.line.paddingLeft(140.w).paddingVertical(15.h)
      ],
    );
  }

  Widget _getIcon(RoomInfo data) {
    if (data.userList.length >= 3) {
      return NineGridView(
        width: 80.w,
        height: 80.h,
        type: NineGridType.weChatGp,
        itemCount: data.userList.length,
        itemBuilder: (BuildContext context, int index) {
          return ImageWidget(
            url: data.userList[index].icon,
            type: ImageWidgetType.asset,
          );
        },
      );
    } else if (data.userList.isNotEmpty) {
      var val = data.userList
          .firstWhere((element) => element.id != AccountData.instance.me.id);
      return ImageWidget(
        width: 80.w,
        height: 80.h,
        url: val.icon,
        type: ImageWidgetType.asset,
      );
    } else {
      return ImageWidget(
        width: 80.w,
        height: 80.h,
        url: AssetsImages.getRandomAvatar(),
        type: ImageWidgetType.asset,
      );
    }
  }
}
