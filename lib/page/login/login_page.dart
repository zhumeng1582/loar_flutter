import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/image.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';
import 'package:loar_flutter/common/util/gaps.dart';
import 'package:loar_flutter/page/home/provider/im_message_provider.dart';

import '../../common/colors.dart';
import '../../common/constant.dart';
import '../../common/im_data.dart';
import '../../common/loading.dart';
import '../../common/routers/RouteNames.dart';
import '../../common/util/encrypter.dart';
import '../../common/util/im_cache.dart';
import '../../common/util/reg.dart';
import '../../widget/loginTextField.dart';

final loginProvider =
    ChangeNotifierProvider<LoginNotifier>((ref) => LoginNotifier());

class LoginNotifier extends ChangeNotifier {
  Future<bool> login(String account, String password, var isNetwork) async {
    if (!Reg.isPhone(account)) {
      Loading.toast("请输入正确的手机号");
      return false;
    }
    if (!Reg.isLoginPassword(password)) {
      Loading.toast("请输入6-16为数字和字母组合密码");
      return false;
    }

    password = Encrypter.encrypt(password, Constant.encryptKey);
    if (isNetwork) {
      try {
        Loading.show();
        notifyListeners();
        await EMClient.getInstance.logout();

        await EMClient.getInstance.login(account, Constant.loginPassword);
        EMUserInfo? userInfo =
            await GlobeDataManager.instance.getOnlineUserInfo();
        Loading.dismiss();
        if (userInfo?.ext == password) {
          ImCache.savePassword(password);
          return true;
        } else {
          await EMClient.getInstance.logout();
          Loading.error("账号或密码不正确，请重新输入");
          return false;
        }
      } on EMError catch (e) {
        error(e);
        return false;
      }
    } else {
      return await loginCache(password);
    }
  }

  Future<bool> loginCache(String password) async {
    var psw = await ImCache.getPassword();
    Loading.dismiss();
    if (psw == password) {
      return true;
    } else {
      Loading.toastError("需要有线登录一次获取信息，再离线登录");
      return false;
    }
  }

  error(value) {
    Loading.toastError((value as EMError).description);
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

    Future(() async {
      // _userAccountController.text = GlobeDataManager.instance.me?.userId ?? "";
      // _userPasswordController.text = await ImCache.getPassword();

      _userAccountController.addListener(() {});
      _userPasswordController.addListener(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Text("跳过").paddingHorizontal(30.w).onTap(() {
            login("18888888888", "qwe123");
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
                Text("账号").paddingHorizontal(25.h),
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
                  "离线登陆",
                  style: TextStyle(fontSize: 34.sp),
                ).padding(all: 20.w)
              ],
            ).roundedBorder(radius: 24.r).onTap(() {
              loarLogin(
                  _userAccountController.text, _userPasswordController.text);
            }).paddingTop(70.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "在线登陆",
                  style: TextStyle(fontSize: 34.sp),
                ).padding(all: 20.w)
              ],
            ).roundedBorder(radius: 24.r).onTap(() {
              login(_userAccountController.text, _userPasswordController.text);
            }).paddingTop(30.h),
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
    bool isSuccess =
        await ref.read(loginProvider).login(account, password, true);

    if (isSuccess) {
      ref.read(imProvider).emConnected = true;
      ref.read(imProvider).isOnline = true;
      Navigator.popAndPushNamed(
        context,
        // RouteNames.blueSearchList,
        RouteNames.main,
      );
    }
  }

  loarLogin(String account, String password) async {
    bool isSuccess =
        await ref.read(loginProvider).login(account, password, false);

    if (isSuccess) {
      ref.read(imProvider).isOnline = false;
      ref.read(imProvider).emConnected = false;
      Navigator.popAndPushNamed(
        context,
        // RouteNames.blueSearchList,
        RouteNames.main,
      );
    }
  }
}

extension _UI on _LoginPageState {}
