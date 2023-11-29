import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loar_flutter/common/util/images.dart';

/// 提示框
class Loading {
  static const int _milliseconds = 500; // 提示 延迟毫秒, 提示体验 秒关太快
  static const int _dismissMilliseconds = 250; // dismiss 延迟毫秒

  Loading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: _dismissMilliseconds)
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 35.0
      ..lineWidth = 2
      ..radius = 10.0
      ..progressColor = Colors.white
      ..backgroundColor = Colors.black.withOpacity(0.7)
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..maskColor = Colors.black.withOpacity(0.6)
      ..userInteractions = true
      ..dismissOnTap = false;
  }

  static void show([String? text]) {
    EasyLoading.instance.userInteractions = false; // 屏蔽交互操作
    EasyLoading.show(status: text ?? "加载中");
  }

  static void error([String? text]) {
    Future.delayed(
      const Duration(milliseconds: _milliseconds),
      () => EasyLoading.showError(text ?? "失败"),
    );
  }

  static void success([String? text]) {
    EasyLoading.instance.successWidget = Image.asset(
      AssetsImages.iconSuccess,
      width: 25,
      height: 25,
    );
    Future.delayed(
      const Duration(milliseconds: _milliseconds),
      () => EasyLoading.showSuccess(text ?? "成功"),
    );
  }

  static Future<T> wrapFuture<T>(Future<T> future) async {
    EasyLoading.instance.userInteractions = false; // 屏蔽交互操作
    EasyLoading.show(status: "");
    try {
      var value = await future;
      return value;
    } catch (e) {
      rethrow;
    }
  }

  static void toast(String text) {
    EasyLoading.showToast(text);
  }

  static void toastError(String text) {
    EasyLoading.showError(text);
  }

  static void info(String text) {
    EasyLoading.showInfo(text);
  }

  static Future<void> dismiss() async {
    await Future.delayed(
      const Duration(milliseconds: _dismissMilliseconds),
      () {
        EasyLoading.instance.userInteractions = true; // 恢复交互操作
        EasyLoading.dismiss();
      },
    );
  }
}
