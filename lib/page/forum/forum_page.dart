import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/ex/ex_im.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';

import '../../common/im_data.dart';
import '../../common/colors.dart';
import '../../common/image.dart';
import '../../common/loading.dart';
import '../../common/proto/qr_code_data.dart';
import '../../common/routers/RouteNames.dart';
import '../../common/util/images.dart';
import '../../widget/edit_remark_sheet.dart';
import '../room/chat_detail_page.dart';

final forumProvider =
    ChangeNotifierProvider<ForumNotifier>((ref) => ForumNotifier());

class ForumNotifier extends ChangeNotifier {}

class ForumPage extends ConsumerStatefulWidget {
  const ForumPage({super.key});

  @override
  ConsumerState<ForumPage> createState() => _MePageState();
}

class _MePageState extends ConsumerState<ForumPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bottomBackground,
        title: Text("社区"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // _topItem(me),
            Expanded(
              flex: 10,
              child: Container(),
            ),
            _getMeItem("蜂景", "微蜂商城", AssetsImages.iconShopping),
            Divider(
              height: 0.1.h,
            ),
            _getMeItem("蜂会", "微蜂论坛", AssetsImages.iconForum),
            Expanded(
              flex: 15,
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

extension _Action on _MePageState {}

extension _UI on _MePageState {
  Widget _getMeItem(String title, String value, String image) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Spacer(),
        Text(title,
            style: TextStyle(fontSize: 50.sp, fontWeight: FontWeight.w500)),
        SizedBox(
          width: 100.w,
        ),
        Column(
          children: [
            ImageWidget.asset(
              image,
              width: 50.w,
              height: 50.h,
            ),
            Text(value,
                style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.w400)).paddingTop(5.h),
          ],
        ),
        Spacer(),
      ],
    ).paddingVertical(60.h).paddingHorizontal(60.w);
  }
}
