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

final meProvider = ChangeNotifierProvider<MeNotifier>((ref) => MeNotifier());

class MeNotifier extends ChangeNotifier {
  EMUserInfo me = GlobeDataManager.instance.me!;

}

class MePage extends ConsumerStatefulWidget {
  const MePage({super.key});

  @override
  ConsumerState<MePage> createState() => _MePageState();
}

class _MePageState extends ConsumerState<MePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EMUserInfo me = ref.watch(meProvider).me;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bottomBackground,
        title: Text("我"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // _topItem(me),
            Divider(
              height: 0.1.h,
            ).paddingTop(200.h),
            _getMeItem("蜂蜂号", me.userId).onTap(() {
              Navigator.pushNamed(context, RouteNames.meDetailPage);
            }),
            _getMeItem("蜂讯", "").onTap(() {
              Navigator.pushNamed(context, RouteNames.meInfoPage);
            }),
            _getMeItem("蜂圈", ""),
            _getMeItem("离线地址管理", "").onTap(() {
              Navigator.pushNamed(context, RouteNames.offlineMap);
            }),
            _getMeItem("设置", "").onTap(() {
              Navigator.pushNamed(context, RouteNames.settingPage);
            }),
            _getMeItem("关于微蜂", "").onTap(() {
              Navigator.pushNamed(context, RouteNames.aboutPage);
            }),
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

extension _Action on _MePageState {

}

extension _UI on _MePageState {

  Widget _getMeItem(String title, String? value) {
    return Column(
      children: [
        Row(
          children: [
            Text(title,
                style: TextStyle(fontSize: 38.sp, fontWeight: FontWeight.w400)),
            Expanded(child: Container()),
            Text(
              value ?? "",
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ).paddingHorizontal(30.w).paddingVertical(40.h),
        Divider(
          height: 0.1.h,
        ),
      ],
    );
  }
}
