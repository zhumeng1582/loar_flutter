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
import 'bean/ConversationBean.dart';

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
    List<ConversationBean> data = ref.watch(imProvider).conversationsList;
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
  _room(ConversationBean data) {
    Navigator.pushNamed(
      context,
      RouteNames.roomPage,
      arguments: data,
    );
  }
}

extension _UI on _HomePageState {
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
