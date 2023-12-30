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
import '../../common/util/encrypter.dart';
import '../../common/util/gaps.dart';
import '../../common/util/im_cache.dart';
import '../../common/util/reg.dart';
import '../../widget/commit_button.dart';
import '../../widget/common.dart';
import '../../widget/loginTextField.dart';

final changePasswordProvider = ChangeNotifierProvider<ChangePasswordNotifier>(
    (ref) => ChangePasswordNotifier());

class ChangePasswordNotifier extends ChangeNotifier {
  var buttonState = ButtonState.disabled;

  setButtonState(String account, String password, String password2) {
    if (account.isEmpty || password.isEmpty || password2.isEmpty) {
      buttonState = ButtonState.disabled;
    } else {
      buttonState = ButtonState.normal;
    }
    notifyListeners();
  }

  updateUserPassword(String password) async {
    await EMClient.getInstance.userInfoManager
        .updateUserInfo(ext: password)
        .catchError((value) => error(value));
  }

  error(value) {
    Loading.toast((value as EMError).description);
    buttonState = ButtonState.normal;
    notifyListeners();
    throw value;
  }
}

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<ChangePasswordPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _userPassword2Controller =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _oldPasswordController.addListener(() {
      ref.read(changePasswordProvider).setButtonState(
          _oldPasswordController.text,
          _newPasswordController.text,
          _userPassword2Controller.text);
    });
    _newPasswordController.addListener(() {
      ref.read(changePasswordProvider).setButtonState(
          _oldPasswordController.text,
          _newPasswordController.text,
          _userPassword2Controller.text);
    });
    _userPassword2Controller.addListener(() {
      ref.read(changePasswordProvider).setButtonState(
          _oldPasswordController.text,
          _newPasswordController.text,
          _userPassword2Controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, "修改密码"),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 4, child: Container()),
            Row(
              children: [
                Text("旧密码"),
                LoginTextField(
                  fillColor: Colors.transparent,
                  controller: _oldPasswordController,
                  hintText: "请输入旧密码",
                  isInputPwd: true,
                  style: TextStyle(color: AppColors.title),
                ).expanded()
              ],
            ),
            Gaps.line,
            Row(
              children: [
                Text("新密码"),
                LoginTextField(
                  fillColor: Colors.transparent,
                  controller: _newPasswordController,
                  hintText: "请输入新密码",
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
                  hintText: "请再次输入新密码",
                  isInputPwd: true,
                  style: TextStyle(color: AppColors.title),
                ).expanded()
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "修改密码",
                  style: TextStyle(fontSize: 34.sp),
                ).padding(all: 20.w)
              ],
            )
                .roundedBorder(radius: 24.r)
                .onTap(changePassword)
                .paddingTop(70.h),
            Expanded(flex: 10, child: Container()),
          ],
        ).paddingHorizontal(60.w),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _userPassword2Controller.dispose();
  }
}

extension _Action on _SignUpPageState {
  changePassword() async {
    String oldPassword = _oldPasswordController.text;
    String password = _newPasswordController.text;
    String password2 = _userPassword2Controller.text;
    var isNetwork = await GlobeDataManager.instance.isNetworkAwait();
    if (!isNetwork) {
      Loading.toast("请先连接网络");
      return false;
    }

    if (!Reg.isLoginPassword(oldPassword)) {
      Loading.toast("请输入6-16为数字或字母旧密码");
      return false;
    }
    oldPassword = Encrypter.encrypt(oldPassword, Constant.encryptKey);
    if (oldPassword != GlobeDataManager.instance.me?.ext) {
      Loading.toast("请输入正确的旧密码");
      return false;
    }
    if (!Reg.isLoginPassword(password) || !Reg.isLoginPassword(password2)) {
      Loading.toast("请输入6-16为数字或字母新密码");
      return false;
    }

    if (password != password2) {
      Loading.toast("两次密码不一致，请重新输入");
      return;
    }
    try {
      Loading.show();
      password = Encrypter.encrypt(password, Constant.encryptKey);
      await ref.read(changePasswordProvider).updateUserPassword(password);
      EMUserInfo? userInfo =
          await GlobeDataManager.instance.getOnlineUserInfo();
      Loading.dismiss();

      if (userInfo!.ext == password) {
        Loading.toast("修改密码成功");
        Navigator.pop(context);
      }
    } catch (e) {
      Loading.dismiss();
      Loading.error(e.toString());
    }
  }
}

extension _UI on _SignUpPageState {}
