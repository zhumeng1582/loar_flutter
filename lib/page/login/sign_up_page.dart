import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';
import 'package:loar_flutter/common/util/images.dart';
import 'package:loar_flutter/common/util/storage.dart';

import '../../common/colors.dart';
import '../../common/constant.dart';
import '../../common/image.dart';
import '../../common/loading.dart';
import '../../common/routers/RouteNames.dart';
import '../../common/util/reg.dart';
import '../../main.dart';
import '../../widget/baseTextField.dart';
import '../../widget/commit_button.dart';

final signUpProvider =
    ChangeNotifierProvider<SignUpNotifier>((ref) => SignUpNotifier());

class SignUpNotifier extends ChangeNotifier {
  var avatar = AssetsImages.getRandomAvatar();

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

  updateUser(String name, String phone) async {
    await EMClient.getInstance.userInfoManager
        .updateUserInfo(nickname: name, phone: phone, avatarUrl: avatar)
        .catchError((value) => error(value));
  }

  Future<bool> saveUser(String account, String password) async {
    if (!isConnectionSuccessful) {
      Loading.toast("请先连接网络");
      return false;
    }

    if (!Reg.isPhone(account)) {
      Loading.toast("请输入正确的手机号");
      return false;
    }
    if (!Reg.isLoginPassword(password)) {
      Loading.toast("请输入6-16为数字或字母密码");
      return false;
    }
    await EMClient.getInstance
        .createAccount(account, password)
        .catchError((value) => error(value));

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
      StorageUtils.save(Constant.password + account, password);
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
      appBar: AppBar(
        title: Text("注册"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(flex: 1, child: Container()),
            ImageWidget.asset(
              ref.watch(signUpProvider).avatar,
              width: 80.w,
              height: 80.h,
            ).onTap(selectAvatar),
            BaseTextField(
              controller: _userNameController,
              hintText: "请输入昵称",
              style: TextStyle(color: AppColors.title),
            ).paddingTop(30.h),
            BaseTextField(
              controller: _userAccountController,
              hintText: "请输入账号",
              style: TextStyle(color: AppColors.title),
            ).paddingTop(30.h),
            BaseTextField(
              controller: _userPasswordController,
              hintText: "请输入密码",
              isInputPwd: true,
              style: TextStyle(color: AppColors.title),
            ).paddingTop(30.h),
            BaseTextField(
              controller: _userPassword2Controller,
              hintText: "请再次输入密码",
              isInputPwd: true,
              style: TextStyle(color: AppColors.title),
            ).paddingTop(30.h),
            CommitButton(
                    buttonState: ref.watch(signUpProvider).buttonState,
                    margin: EdgeInsets.zero,
                    text: "注册",
                    tapAction: signUp)
                .paddingTop(70.h),
            Expanded(flex: 2, child: Container()),
          ],
        ).paddingHorizontal(30.w),
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

  signUp() async {
    String account = _userAccountController.text;
    String userName = _userNameController.text;
    String password = _userPasswordController.text;
    String password2 = _userPassword2Controller.text;
    if (password != password2) {
      Loading.toast("两次密码不一致，请重新输入");
      return;
    }
    try {
      Loading.show();
      bool isSuccess =
          await ref.read(signUpProvider).saveUser(account, password);
      if (isSuccess) {
        await ref.read(signUpProvider).login(account, password);
        await ref.read(signUpProvider).updateUser(userName, account);

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
