import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/image.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';
import 'package:loar_flutter/common/util/gaps.dart';

import '../../common/colors.dart';
import '../../common/im_data.dart';
import '../../common/loading.dart';
import '../../common/routers/RouteNames.dart';
import '../../common/util/im_cache.dart';
import '../../common/util/images.dart';
import '../../common/util/reg.dart';
import '../../widget/baseTextField.dart';
import '../../widget/commit_button.dart';
import '../../widget/loginTextField.dart';

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
    if (!Reg.isPhone(account)) {
      Loading.toast("请输入正确的手机号");
      return false;
    }
    if (!Reg.isLoginPassword(password)) {
      Loading.toast("请输入6-16为数字或字母组合密码");
      return false;
    }
    if (!GlobeDataManager.instance.isConnectionSuccessful) {
      var psw = await ImCache.getPassword();
      if (psw == password) {
        return true;
      } else {
        Loading.toast("账号或密码不正确，请重新输入");
        return false;
      }
    } else {
      buttonState = ButtonState.loading;
      notifyListeners();
      await EMClient.getInstance.logout();

      await EMClient.getInstance
          .login(account, password)
          .catchError((value) => error(value));
      ImCache.savePassword(password);

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

    ref.read(loginProvider).buttonState = ButtonState.normal;

    Future(() async {
      // _userAccountController.text = GlobeDataManager.instance.me?.userId ?? "";
      // _userPasswordController.text = await ImCache.getPassword();

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
        actions: [
          Text("跳过").paddingHorizontal(30.w).onTap(() {
            login("13265468736", "Z123456");
          }),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 10, child: Container()),
            Text("欢迎使用", style: TextStyle(fontSize: 26.sp)),
            Text("微蜂",
                style: TextStyle(fontSize: 80.sp, fontWeight: FontWeight.w400)),
            Row(
              children: [
                Row(
                  children: [
                    Text("+86"),
                    ImageWidget(
                      url: AssetsImages.iconDown,
                      width: 30.w,
                      height: 30.h,
                      type: ImageWidgetType.asset,
                    ),
                  ],
                ).padding(horizontal: 10.h, vertical: 2.w).roundedBorder(
                    radius: 8.r, color: AppColors.title.withOpacity(0.4)),
                LoginTextField(
                  fillColor: Colors.transparent,
                  controller: _userAccountController,
                  hintText: "请输入手机号",
                  style: TextStyle(color: AppColors.title),
                ).expanded(),
              ],
            ).paddingTop(20.h),
            Gaps.line,
            Row(
              children: [
                Text("密码").paddingHorizontal(25.h),
                LoginTextField(
                  fillColor: Colors.transparent,
                  controller: _userPasswordController,
                  hintText: "请输入密码",
                  isInputPwd: true,
                  style: TextStyle(color: AppColors.title),
                ).expanded()
              ],
            ).paddingTop(30.h),
            Gaps.line,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "登陆",
                  style: TextStyle(fontSize: 34.sp),
                ).padding(all: 20.w)
              ],
            ).roundedBorder(radius: 24.r).onTap(() {
              login(_userAccountController.text, _userPasswordController.text);
            }).paddingTop(70.h),
            Row(
              children: [
                Text("忘记密码", style: TextStyle()).onTap(() => forgetPassword()),
                Expanded(child: Container()),
                Text("注册账户", style: TextStyle()).onTap(() => signUp())
              ],
            ).paddingTop(30.h),
            Expanded(flex: 25, child: Container()),
          ],
        ).paddingHorizontal(120.w),
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
    // Navigator.popAndPushNamed(
    //   context,
    //   RouteNames.signUp,
    // );
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
