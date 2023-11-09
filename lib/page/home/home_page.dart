import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/common/ex/ex_string.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';
import 'package:loar_flutter/page/home/provider/home_provider.dart';
import 'package:loar_flutter/page/home/provider/im_message_provider.dart';
import 'package:nine_grid_view/nine_grid_view.dart';

import '../../common/colors.dart';
import '../../common/image.dart';
import '../../common/routers/RouteNames.dart';
import '../../common/util/gaps.dart';
import '../../common/util/images.dart';
import 'bean/conversation_bean.dart';
import 'bean/notify_bean.dart';

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
    List<dynamic> data = [];
    List<NotifyBean> notifyList = ref.watch(imProvider).notifyList;
    List<ConversationBean> conversations =
        ref.watch(imProvider).conversationsList;
    data.addAll(notifyList);
    data.addAll(conversations);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bottomBackground,
        title: Text("聊天"),
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
          if (item is ConversationBean) {
            return _buildRoomItem(item).onTap(() {
              _room(item);
            });
          }else{
            return _buildNotifyItem(item).onTap(() {
              _invite(item);
            });
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

extension _Action on _HomePageState {
  scan() async {
    var qrCodeData = await ref.read(homeProvider).scan();
    if (qrCodeData.userInfo != null) {
      Navigator.pushNamed(
        context,
        RouteNames.usesInfoPage,
        arguments: qrCodeData.userInfo,
      );
    } else if (qrCodeData.room != null) {
      Navigator.pushNamed(
        context,
        RouteNames.roomDetail,
        arguments: qrCodeData.room,
      );
    }
  }

  _room(ConversationBean data) {
    Navigator.pushNamed(
      context,
      RouteNames.roomPage,
      arguments: data,
    );
  }

  _invite(NotifyBean data) {
    Navigator.pushNamed(
      context,
      RouteNames.notifyPage,
      arguments: data,
    );
  }
}

extension _UI on _HomePageState {
  Widget _buildNotifyItem(NotifyBean data) {
    return Column(
      children: [
        Row(
          children: [
            ImageWidget(
              width: 80.w,
              height: 80.h,
              url: AssetsImages.iconInvite,
              type: ImageWidgetType.asset,
            ).paddingHorizontal(30.w),
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
                              data.type== NotifyType.group?"您收到一个加群消息":"您收到一个好友邀请",
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: AppColors.title,
                              ),
                            ),
                            Text(
                              data.reason??"请尽快处理",
                              style: TextStyle(
                                fontSize: 22.sp,
                                color: AppColors.title.withOpacity(0.6),
                              ),
                            )
                          ],
                        ),
                      ),
                      Text(data.time.formatChatTime,
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
  Widget _buildRoomItem(ConversationBean data) {
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
                              data.title,
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: AppColors.title,
                              ),
                            ),
                            Text(
                              data.message,
                              style: TextStyle(
                                fontSize: 22.sp,
                                color: AppColors.title.withOpacity(0.6),
                              ),
                            )
                          ],
                        ),
                      ),
                      Text(data.time.formatChatTime,
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

  Widget _getIcon(ConversationBean data) {
    return NineGridView(
      width: 80.w,
      height: 80.h,
      type: NineGridType.weChatGp,
      itemCount: data.avatarUrls.length,
      itemBuilder: (BuildContext context, int index) {
        return ImageWidget(
          url: data.avatarUrls[index],
          type: ImageWidgetType.asset,
        );
      },
    );
  }
}
