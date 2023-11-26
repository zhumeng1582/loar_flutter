import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';
import 'package:loar_flutter/common/util/gaps.dart';

import '../../common/colors.dart';

final settingProvider =
    ChangeNotifierProvider<SettingNotifier>((ref) => SettingNotifier());

class SettingNotifier extends ChangeNotifier {}

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({super.key});

  @override
  ConsumerState<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends ConsumerState<SettingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: AppColors.bottomBackground,
        title: Text("设置"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _getMeItem("设备连接"),
            Gaps.line,
            _getMeItem("账号与安全"),
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

extension _Action on _SettingPageState {}

extension _UI on _SettingPageState {
  Widget _getMeItem(String title, {bool arrow = true}) {
    return Column(
      children: [
        Row(
          children: [
            Text(title,
                style: TextStyle(fontSize: 38.sp, fontWeight: FontWeight.w400)),
            Expanded(child: Container()),
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
