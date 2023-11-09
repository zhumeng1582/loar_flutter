import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';

import '../../common/colors.dart';
import '../../common/constant.dart';
import '../../common/loading.dart';
import '../../common/routers/RouteNames.dart';
import '../../common/util/reg.dart';
import '../../common/util/storage.dart';
import '../../main.dart';
import '../../widget/baseTextField.dart';
import '../../widget/commit_button.dart';

final loginProvider =
    ChangeNotifierProvider<LoginNotifier>((ref) => LoginNotifier());

class LoginNotifier extends ChangeNotifier {
  var buttonState = ButtonState.disabled;

  setButtonState(String account, String password) {
    if (account.isEmpty || password.isEmpty) {
      buttonState = ButtonState.disabled;
    } else {
      buttonState = ButtonState.normal;
    }
    notifyListeners();
  }

  Future<bool> login(String account, String password) async {
    if (account.isEmpty || password.isEmpty) {
      return false;
    }
    if (!Reg.isPhone(account)) {
      Loading.toast("请输入正确的手机号");
      return false;
    }
    if (!Reg.isLoginPassword(password)) {
      Loading.toast("请输入6-16为数字或字母组合密码");
      return false;
    }
    if (!isConnectionSuccessful) {
      var psw = await StorageUtils.getString(Constant.password + account);
      if (psw == password) {
        return true;
      } else {
        Loading.toast("账号或密码不正确，请重新输入");
        return false;
      }
    } else {
      buttonState = ButtonState.loading;
      notifyListeners();

      await EMClient.getInstance
          .login(account, password)
          .catchError((value) => error(value));
      StorageUtils.save(Constant.password + account, password);

      buttonState = ButtonState.normal;
      notifyListeners();
      return true;
    }
  }

  error(value) {
    Loading.toast((value as EMError).description);
    buttonState = ButtonState.normal;
    notifyListeners();
    throw value;
  }
}

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _userAccountController = TextEditingController();
  final TextEditingController _userPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userAccountController.text = "13265468736";
    _userPasswordController.text = "123456";
    ref.read(loginProvider).buttonState = ButtonState.normal;

    Future(() {
      _userAccountController.addListener(() {
        ref.read(loginProvider).setButtonState(
            _userAccountController.text, _userPasswordController.text);
      });
      _userPasswordController.addListener(() {
        ref.read(loginProvider).setButtonState(
            _userAccountController.text, _userPasswordController.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("登陆"),
        actions: [
          Text("跳过").onTap(() {
            Navigator.popAndPushNamed(
              context,
              // RouteNames.blueSearchList,
              RouteNames.main,
            );
          }),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(flex: 1, child: Container()),
            BaseTextField(
              controller: _userAccountController,
              hintText: "请输入账号",
              style: TextStyle(color: AppColors.title),
            ),
            BaseTextField(
              controller: _userPasswordController,
              hintText: "请输入密码",
              isInputPwd: true,
              style: TextStyle(color: AppColors.title),
            ).paddingTop(30.h),
            CommitButton(
                buttonState: ref.watch(loginProvider).buttonState,
                margin: EdgeInsets.zero,
                text: "登陆",
                tapAction: () => {
                      login(_userAccountController.text,
                          _userPasswordController.text)
                    }).paddingTop(70.h),
            Row(
              children: [
                Text("忘记密码",
                    style: TextStyle(
                      color: AppColors.disabledTextColor,
                    )).onTap(() => forgetPassword()),
                Expanded(child: Container()),
                Text("注册账户",
                    style: TextStyle(
                      color: AppColors.commonPrimary,
                    )).onTap(() => signUp())
              ],
            ).paddingTop(20.h),
            Expanded(flex: 2, child: Container()),
          ],
        ).paddingHorizontal(30.w),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _userAccountController.dispose();
    _userPasswordController.dispose();
  }
}

extension _Action on _LoginPageState {
  forgetPassword() {
    Navigator.popAndPushNamed(
      context,
      RouteNames.signUp,
    );
  }

  signUp() {
    Navigator.popAndPushNamed(
      context,
      RouteNames.signUp,
    );
  }

  login(String account, String password) async {
    bool isSuccess = await ref.read(loginProvider).login(account, password);
    if (isSuccess) {
      Navigator.popAndPushNamed(
        context,
        // RouteNames.blueSearchList,
        RouteNames.main,
      );
    }
  }
}

extension _UI on _LoginPageState {}
