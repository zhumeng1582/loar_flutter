import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';

import '../../common/colors.dart';
import '../../widget/commit_button.dart';

final sosProvider = ChangeNotifierProvider<SosNotifier>((ref) => SosNotifier());

class SosNotifier extends ChangeNotifier {}

class SosPage extends ConsumerStatefulWidget {
  const SosPage({super.key});

  @override
  ConsumerState<SosPage> createState() => _SosPageState();
}

class _SosPageState extends ConsumerState<SosPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bottomBackground,
        title: Text("SOS"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Text("状态：未发起").paddingTop(80.h),
            CommitButton(
                buttonState: ButtonState.normal,
                backgroundColor: Colors.red,
                text: "发起SOS",
                tapAction: () => {}).paddingTop(80.h),
            CommitButton(
                buttonState: ButtonState.normal,
                backgroundColor: Colors.blue,
                text: "预设SOS",
                tapAction: () => {}).paddingTop(80.h),
          ],
        ).paddingHorizontal(30.w),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

extension _Action on _SosPageState {}

extension _UI on _SosPageState {}
