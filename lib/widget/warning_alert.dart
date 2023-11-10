import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/common/ex/ex_widget.dart';

import '../common/colors.dart';


class WarningActionSheetAlert extends StatelessWidget {
  final BuildContext context;

  /// 标题
  final String title;

  /// 中间内容
  final String content;

  /// 确定按钮文案
  final String confirmActionText;

  /// 取消按钮，如果不传则没有取消按钮
  final String? cancelActionText;

  /// 确认事件
  final VoidCallback? confirmAction;

  /// 取消事件
  final VoidCallback? cancelAction;

  final TextAlign? textAlign;

  const WarningActionSheetAlert({
    Key? key,
    required this.context,
    required this.title,
    required this.content,
    required this.confirmActionText,
    this.cancelActionText,
    this.confirmAction,
    this.cancelAction,
    this.textAlign,
  }) : super(key: key);

  static OverlayEntry? _entry;

  static void show(
      {required BuildContext context,
      required String title,
      required String content,
      required String confirmActionText,
      bool? isOverlay,
      bool? barrierDismissible,
      String? iconNamed,
      String? cancelActionText,
      String? contentEnd,
      String? contentBold,
      Size? iconSize,
      TextAlign? textAlign,
      VoidCallback? confirmAction,
      VoidCallback? cancelAction}) {
    final view = WarningActionSheetAlert(
      context: context,
      title: title,
      content: content,
      confirmActionText: confirmActionText,
      cancelActionText: cancelActionText,
      confirmAction: confirmAction,
      cancelAction: cancelAction,
    );
    if (isOverlay == true) {
      final overlay = OverlayEntry(builder: (context) {
        return view.backgroundColor(AppColors.coverFull);
      });
      _entry = overlay;
      Overlay.of(context).insert(overlay);
      return;
    }
    showDialog(
        context: context,
        barrierDismissible: barrierDismissible ?? true,
        builder: (context) {
          return view;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 100.w),
        padding:
            EdgeInsets.only(left: 55.w, right: 55.w, top: 55.w, bottom: 50.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: AppColors.background,
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          return Wrap(
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              AutoSizeText(
                title,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 34.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.title.withOpacity(0.85),
                  overflow: TextOverflow.ellipsis,
                ),
              ).constrained(maxWidth: maxWidth),
              SizedBox(height: 30.h),
              Text(content,
                  style: TextStyle(
                    height: 41 / 26,
                    color: AppColors.title,
                    fontSize: 26.sp,
                  )).width(maxWidth),
              SizedBox(
                height: 36.h,
              ),
              SizedBox(
                width: maxWidth,
                child: TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.resolveWith(
                      (states) => EdgeInsets.symmetric(vertical: 20.h),
                    ),
                    textStyle: MaterialStateProperty.resolveWith((states) =>
                        TextStyle(
                            fontSize: 30.sp, fontWeight: FontWeight.w500)),
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (_) => AppColors.commonPrimary),
                    foregroundColor:
                        MaterialStateProperty.resolveWith((_) => Colors.white),
                  ),
                  onPressed: () => _onConfirmAction(),
                  child: Text(confirmActionText),
                ),
              ),
              if (cancelActionText != null) _buildCancelButton(maxWidth)
            ],
          );
        }),
      ),
    );
  }

  Widget _buildCancelButton(double maxWidth) {
    return SizedBox(
      width: maxWidth,
      child: TextButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.resolveWith(
            (states) => EdgeInsets.symmetric(vertical: 20.h),
          ),
          textStyle: MaterialStateProperty.resolveWith((states) =>
              TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w500)),
          backgroundColor:
              MaterialStateProperty.resolveWith((_) => AppColors.background),
          foregroundColor:
              MaterialStateProperty.resolveWith((_) => AppColors.commonPrimary),
        ),
        onPressed: () => _onCancelAction(),
        child: Text(cancelActionText ?? ''),
      ),
    );
  }

  /// Event
  void _onConfirmAction() {
    Navigator.pop(context);
    if (_entry != null) {
      _entry?.remove();
      _entry = null;
    }
    confirmAction?.call();
  }

  void _onCancelAction() {
    Navigator.pop(context);
    if (_entry != null) {
      _entry?.remove();
      _entry = null;
    }
    cancelAction?.call();
  }
}
