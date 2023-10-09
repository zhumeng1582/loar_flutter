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
import '../../common/proto/index.dart';
final loginProvider =
    ChangeNotifierProvider<LoginNotifier>((ref) => LoginNotifier());

class LoginNotifier extends ChangeNotifier {
  get key => "LoginUserInfo";

  var buttonState = ButtonState.disabled;

  setButtonState(String account, String password) {
    if (account.isEmpty || password.isEmpty) {
      buttonState = ButtonState.disabled;
    } else {
      buttonState = ButtonState.normal;
    }
    notifyListeners();
  }

  getAccount(TextEditingController userAccountController,
      TextEditingController userPasswordController) async {
    var text = await Storage.getIntList(key);
    if (text.isNotEmpty) {
      LoginUserInfo userInfo = LoginUserInfo.fromBuffer(text);
      userAccountController.text = userInfo.user.account;
      userPasswordController.text = userInfo.password;
    }
  }

  Future<bool> login(String account, String password) async {
    buttonState = ButtonState.loading;
    notifyListeners();
    var text = await Storage.getIntList(key);

    if (text.isNotEmpty) {
      LoginUserInfo userInfo = LoginUserInfo.fromBuffer(text);
      if (userInfo.password == password &&
          userInfo.user.account == account) {
        LocalInfoCache.instance.userInfo = userInfo;
        buttonState = ButtonState.normal;
        notifyListeners();
        return true;
      }
    }
    buttonState = ButtonState.normal;
    notifyListeners();
    return false;
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
    ref
        .read(loginProvider)
        .getAccount(_userAccountController, _userPasswordController);
    _userAccountController.addListener(() {
      ref.read(loginProvider).setButtonState(
          _userAccountController.text, _userPasswordController.text);
    });
    _userPasswordController.addListener(() {
      ref.read(loginProvider).setButtonState(
          _userAccountController.text, _userPasswordController.text);
    });
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
      if (LocalInfoCache.instance.userInfo != null) {
        Navigator.popAndPushNamed(
          context,
          // RouteNames.blueSearchList,
          RouteNames.main,
        );
      }
    } else {
      EasyLoading.showToast("账号或密码不正确，请重新登陆");
    }
  }
}

extension _UI on _LoginPageState {}
