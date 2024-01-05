import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';

import '../../common/colors.dart';
import '../../common/image.dart';
import '../../common/util/images.dart';

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
        const Spacer(),
        ImageWidget.asset(
          image,
          width: 50.w,
          height: 50.h,
        ),
        SizedBox(
          width: 20.w,
        ),
        Text(title,
            style: TextStyle(fontSize: 50.sp, fontWeight: FontWeight.w600)),
        SizedBox(
          width: 100.w,
        ),
        Text(value,
                style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.w500))
            .paddingTop(5.h),
        const Spacer(),
      ],
    ).paddingVertical(80.h).paddingHorizontal(60.w);
  }
}
