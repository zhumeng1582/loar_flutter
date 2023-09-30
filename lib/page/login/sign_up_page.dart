import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';

import '../../common/local_info_cache.dart';
import '../../common/colors.dart';
import '../../common/routers/RouteNames.dart';
import '../../widget/baseTextField.dart';
import '../../widget/commit_button.dart';
import 'package:loar_flutter/common/util/storage.dart';

import '../contacts/contacts_list.dart';

final signUpProvider =
    ChangeNotifierProvider<SignUpNotifier>((ref) => SignUpNotifier());

class SignUpNotifier extends ChangeNotifier {
  get key => "LoginUserInfo";

  var buttonState = ButtonState.disabled;

  setButtonState(String account, String password,String password2) {
    if (account.isEmpty || password.isEmpty || password2.isEmpty) {
      buttonState = ButtonState.disabled;
    } else {
      buttonState = ButtonState.normal;
    }
    notifyListeners();
  }


  Future<bool> saveUser(String account, String password) async {
    MyUserInfo userInfo = MyUserInfo.createUser(account, password);
    String useInfoStr = jsonEncode(userInfo);

    bool isSuccess = await Storage.save(key, useInfoStr);
    LocalInfoCache.instance.userInfo = userInfo;

    return isSuccess;
  }
}

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final TextEditingController _userAccountController = TextEditingController();
  final TextEditingController _userPasswordController = TextEditingController();
  final TextEditingController _userPassword2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userAccountController.addListener(() {
      ref.read(signUpProvider).setButtonState(
          _userAccountController.text, _userPasswordController.text,_userPassword2Controller.text);
    });
    _userPasswordController.addListener(() {
      ref.read(signUpProvider).setButtonState(
          _userAccountController.text, _userPasswordController.text,_userPassword2Controller.text);
    });
    _userPassword2Controller.addListener(() {
      ref.read(signUpProvider).setButtonState(
          _userAccountController.text, _userPasswordController.text,_userPassword2Controller.text);
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
                tapAction: () => {
                      signUp(_userAccountController.text,
                          _userPasswordController.text,_userPassword2Controller.text)
                    }).paddingTop(70.h),
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
    _userPassword2Controller.dispose();
  }
}

extension _Action on _SignUpPageState {
  signUp(String account, String password,String password2) async {
    if (password != password2) {
      EasyLoading.showToast("两次密码不一致，请重新输入");
      return;
    }

    bool isSuccess = await ref.read(signUpProvider).saveUser(account, password);
    if(isSuccess){
      Navigator.popAndPushNamed(
        context,
        RouteNames.main,
      );
    }
  }
}

extension _UI on _SignUpPageState {}
