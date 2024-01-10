import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/common/ex/ex_string.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';
import 'package:loar_flutter/common/util/gaps.dart';
import 'package:loar_flutter/widget/edit_remark_sheet.dart';

import '../../common/colors.dart';
import '../../common/loading.dart';
import '../../common/routers/RouteNames.dart';
import '../../common/util/im_cache.dart';
import '../../widget/common.dart';
import '../../widget/edit_time_sheet.dart';

final settingProvider =
    ChangeNotifierProvider<SettingNotifier>((ref) => SettingNotifier());

class SettingNotifier extends ChangeNotifier {
  var time = "5";

  getMessageInterval() async {
    time = await ImCache.getMessageInterval();
    notifyListeners();
  }

  bool setMessageInterval(String time) {
    if (time.isEmpty) {
      Loading.toast("时间必须为1~20的正整数");
      return false;
    }
    try {
      int value = int.parse(time);
      if (value > 20 || value < 1) {
        Loading.toast("时间必须为1~20的正整数");
        return false;
      }

      this.time = time;
      ImCache.saveMessageInterval(time);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({super.key});

  @override
  ConsumerState<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends ConsumerState<SettingPage> {
  @override
  void initState() {
    super.initState();
    Future(() {
      ref.read(settingProvider).getMessageInterval();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, "设置"),
      body: SafeArea(
        child: Column(
          children: [
            _getMeItem("设备连接").onTap(() {
              Navigator.pushNamed(context, RouteNames.blueSearchList)
                  .then((value) => setState(() {}));
            }),
            Gaps.line,
            _getMeItem("离线地址管理").onTap(() {
              Navigator.pushNamed(context, RouteNames.offlineMap);
            }),
            Gaps.line,
            _getMeItem("账号与安全").onTap(() {
              Navigator.pushNamed(context, RouteNames.changePasswordPage);
            }),
            Gaps.line,
            _getMeItem("发送间隔", value: "${ref.watch(settingProvider).time}秒")
                .onTap(setMessageInterval),
            Gaps.line,
            _getMeItem("通用"),
            Gaps.line,
            _getMeItem("权限"),
            Gaps.line,
            _getMeItem("帮助与反馈"),
            Gaps.line,
            _getMeItem("退出登陆", arrow: false),
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

extension _Action on _SettingPageState {
  setMessageInterval() {
    EditTimeBottomSheet.show(
        context: context,
        maxLength: 18,
        keyboardType: TextInputType.number,
        data: ref.read(settingProvider).time,
        onConfirm: ref.read(settingProvider).setMessageInterval);
  }
}

extension _UI on _SettingPageState {
  Widget _getMeItem(String title, {String value = "", bool arrow = true}) {
    return Column(
      children: [
        Row(
          children: [
            Text(title,
                style: TextStyle(fontSize: 38.sp, fontWeight: FontWeight.w400)),
            Expanded(child: Container()),
            Text(value,
                style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w400)),
            if (arrow)
              Icon(
                Icons.keyboard_arrow_right,
                size: 43.w,
              )
          ],
        ).paddingHorizontal(30.w).paddingVertical(40.h),
      ],
    );
  }
}
