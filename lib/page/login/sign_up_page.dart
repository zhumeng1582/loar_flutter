import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';
import 'package:loar_flutter/common/util/images.dart';

import '../../common/colors.dart';
import '../../common/constant.dart';
import '../../common/im_data.dart';
import '../../common/image.dart';
import '../../common/loading.dart';
import '../../common/routers/RouteNames.dart';
import '../../common/util/gaps.dart';
import '../../common/util/im_cache.dart';
import '../../common/util/reg.dart';
import '../../widget/commit_button.dart';
import '../../widget/loginTextField.dart';

final signUpProvider =
    ChangeNotifierProvider<SignUpNotifier>((ref) => SignUpNotifier());

class SignUpNotifier extends ChangeNotifier {
  var avatar = AssetsImages.getRandomAvatar();
  bool isCheck = true;

  setCheck(bool isCheck) {
    this.isCheck = isCheck;
    notifyListeners();
  }

  setAvatar(String avatar) {
    this.avatar = avatar;
    notifyListeners();
  }

  var buttonState = ButtonState.disabled;

  setButtonState(String account, String password, String password2) {
    if (account.isEmpty || password.isEmpty || password2.isEmpty) {
      buttonState = ButtonState.disabled;
    } else {
      buttonState = ButtonState.normal;
    }
    notifyListeners();
  }

  updateUser(String name, String phone, String password) async {
    await EMClient.getInstance.userInfoManager
        .updateUserInfo(
            nickname: name, phone: phone, avatarUrl: avatar, ext: password)
        .catchError((value) => error(value));
  }

  Future<bool> createAccount(String account, String password) async {
    await EMClient.getInstance.createAccount(account, password);

    return true;
  }

  Future<bool> login(String account, String password) async {
    buttonState = ButtonState.loading;
    notifyListeners();

    if (account.isNotEmpty && password.isNotEmpty) {
      await EMClient.getInstance
          .login(account, password)
          .catchError((value) => error(value));
      buttonState = ButtonState.normal;
      notifyListeners();
      ImCache.savePassword(password);
      return true;
    }
    buttonState = ButtonState.normal;
    notifyListeners();
    return false;
  }

  error(value) {
    Loading.toast((value as EMError).description);
    buttonState = ButtonState.normal;
    notifyListeners();
    throw value;
  }
}

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final TextEditingController _userAccountController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userCountryController = TextEditingController();
  final TextEditingController _userPasswordController = TextEditingController();
  final TextEditingController _userPassword2Controller =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _userAccountController.addListener(() {
      ref.read(signUpProvider).setButtonState(_userAccountController.text,
          _userPasswordController.text, _userPassword2Controller.text);
    });
    _userPasswordController.addListener(() {
      ref.read(signUpProvider).setButtonState(_userAccountController.text,
          _userPasswordController.text, _userPassword2Controller.text);
    });
    _userPassword2Controller.addListener(() {
      ref.read(signUpProvider).setButtonState(_userAccountController.text,
          _userPasswordController.text, _userPassword2Controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 4, child: Container()),
            Text("注册",
                style: TextStyle(fontSize: 80.sp, fontWeight: FontWeight.w400)),
            ImageWidget.asset(
              ref.watch(signUpProvider).avatar,
              width: 160.w,
              height: 160.h,
            ).onTap(selectAvatar).paddingVertical(20.h).center(),
            Row(
              children: [
                Text("昵称"),
                LoginTextField(
                  fillColor: Colors.transparent,
                  controller: _userNameController,
                  hintText: "请输入昵称",
                  style: TextStyle(color: AppColors.title),
                ).expanded()
              ],
            ),
            Gaps.line,
            Row(
              children: [
                Text("国家"),
                LoginTextField(
                  fillColor: Colors.transparent,
                  controller: _userCountryController,
                  hintText: "",
                  style: TextStyle(color: AppColors.title),
                ).expanded()
              ],
            ),
            Gaps.line,
            Row(
              children: [
                Text("手机号"),
                LoginTextField(
                  fillColor: Colors.transparent,
                  controller: _userAccountController,
                  hintText: "请输入手机号",
                  style: TextStyle(color: AppColors.title),
                ).expanded()
              ],
            ),
            Gaps.line,
            Row(
              children: [
                Text("密码"),
                LoginTextField(
                  fillColor: Colors.transparent,
                  controller: _userPasswordController,
                  hintText: "请输入密码",
                  isInputPwd: true,
                  style: TextStyle(color: AppColors.title),
                ).expanded()
              ],
            ),
            Gaps.line,
            Row(
              children: [
                Text("密码确认"),
                LoginTextField(
                  fillColor: Colors.transparent,
                  controller: _userPassword2Controller,
                  hintText: "请再次输入密码",
                  isInputPwd: true,
                  style: TextStyle(color: AppColors.title),
                ).expanded()
              ],
            ),
            Gaps.line,
            Row(
              children: [
                CupertinoCheckbox(
                    value: ref.watch(signUpProvider).isCheck,
                    onChanged: onChanged),
                Text(
                  "已阅读并同意《微蜂软件许可及服务协议》",
                  style: TextStyle(fontSize: 26.sp),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "注册",
                  style: TextStyle(fontSize: 34.sp),
                ).padding(all: 20.w)
              ],
            ).roundedBorder(radius: 24.r).onTap(signUp).paddingTop(70.h),
            Expanded(flex: 10, child: Container()),
          ],
        ).paddingHorizontal(60.w),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _userNameController.dispose();
    _userAccountController.dispose();
    _userPasswordController.dispose();
    _userPassword2Controller.dispose();
  }
}

extension _Action on _SignUpPageState {
  selectAvatar() {
    Navigator.pushNamed(context, RouteNames.selectAvatar)
        .then((value) => {ref.read(signUpProvider).setAvatar(value as String)});
  }

  void onChanged(bool? isCheck) {
    ref.watch(signUpProvider).setCheck(isCheck == true);
  }

  signUp() async {
    String account = _userAccountController.text;
    String userName = _userNameController.text;
    String password = _userPasswordController.text;
    String password2 = _userPassword2Controller.text;
    var isNetwork = await GlobeDataManager.instance.isNetworkAwait();
    if (!isNetwork) {
      Loading.toast("请先连接网络");
      return false;
    }
    if (!ref.read(signUpProvider).isCheck) {
      Loading.toast("请先阅读并同意服务协议");
      return;
    }
    if (!Reg.isPhone(account)) {
      Loading.toast("请输入正确的手机号");
      return false;
    }
    if (!Reg.isLoginPassword(password)) {
      Loading.toast("请输入6-16为数字或字母密码");
      return false;
    }

    if (password != password2) {
      Loading.toast("两次密码不一致，请重新输入");
      return;
    }
    try {
      Loading.show();
      bool isSuccess = await ref
          .read(signUpProvider)
          .createAccount(account, Constant.loginPassword);
      if (isSuccess) {
        await ref.read(signUpProvider).login(account, Constant.loginPassword);

        await ref.read(signUpProvider).updateUser(userName, account, password);

        Loading.dismiss();
        Navigator.popAndPushNamed(
          context,
          RouteNames.main,
        );
      }
    } catch (e) {
      Loading.dismiss();
      Loading.error(e.toString());
    }
  }
}

extension _UI on _SignUpPageState {}
