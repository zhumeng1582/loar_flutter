import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';

import '../../common/colors.dart';
import '../../widget/baseTextField.dart';
import '../../widget/commit_button.dart';

final loginProvider =
ChangeNotifierProvider<LoginNotifier>((ref) => LoginNotifier());

class LoginNotifier extends ChangeNotifier {

}

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {

  final TextEditingController _userAccountController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("登陆"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(flex:1,child: Container()),
            BaseTextField(
              controller: _userAccountController,
              hintText: "请输入账号",
              style: TextStyle(color: AppColors.title),
            ),
            
            BaseTextField(
              controller: _userAccountController,
              hintText: "请输入密码",
              style: TextStyle(color: AppColors.title),
            ).paddingTop(30.h),
            CommitButton(
                buttonState:ButtonState.normal,
                margin: EdgeInsets.zero,
                text: "登陆",
                tapAction: () => {}).paddingTop(70.h),
            Expanded(flex:2,child: Container()),
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

extension _Action on _LoginPageState {

}

extension _UI on _LoginPageState {
}
