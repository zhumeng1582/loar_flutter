import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../common/colors.dart';


class ActionBottomSheet {
  // 标准 - 底部弹出 - 模式对话框
  static Future<void> normal({
    required BuildContext context,
    Widget? child,
    EdgeInsetsGeometry? contentPadding,
    bool enableDrag = true,
  }) async {
    /// 弹出底部模式对话框
    return await showMaterialModalBottomSheet(
      // 上下文 context
      context: context,
      // 背景透明
      backgroundColor: Colors.transparent,
      // 启用拖拽
      enableDrag: enableDrag,
      // 内容
      builder: (context) => SafeArea(
        minimum: const EdgeInsets.all(10),
        child: AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 150),
          child: Container(
            padding: contentPadding ?? const EdgeInsets.all(10),
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            // 弹出视图内容区
            child: child,
          ),
        ),
      ),
    );
  }

  // 底部弹出 popModal
  static Future<void> popModalFuture({
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsets? safeAreaMinimum,
    bool enableDrag = true,
  }) {
    return showMaterialModalBottomSheet(
      context: context,
      backgroundColor: AppColors.coverFull,
      duration: const Duration(milliseconds: 250),
      enableDrag: enableDrag,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.r), topRight: Radius.circular(40.r))),
      builder: (context) => child,
    );
  }
  // 底部弹出 popModal
  static popModal({
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsets? safeAreaMinimum,
    bool enableDrag = true,
  }) async{
     showMaterialModalBottomSheet(
      context: context,
      backgroundColor: AppColors.coverFull,
      duration: const Duration(milliseconds: 250),
      enableDrag: enableDrag,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.r), topRight: Radius.circular(40.r))),
      builder: (context) => child,
    );
  }
}
