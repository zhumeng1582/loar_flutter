import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/colors.dart';


enum ButtonState {
  normal,
  disabled,
  loading,
}

class CommitButton extends StatefulWidget {
  CommitButton({
    Key? key,
    this.height,
    this.margin,
    this.fontSize,
    this.backgroundColor,
    this.highlightColor,
    this.borderColor,
    this.disabledBackgroundColor,
    this.disabledBorderColor,
    this.textColor,
    int debounceTimeMs = 200,
    required this.buttonState,
    required this.text,
    required this.tapAction,
  })  : _duration = Duration(milliseconds: debounceTimeMs),
        super(key: key);

  final double? height;
  final double? fontSize;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final Color? highlightColor;
  final Color? disabledBackgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final Color? disabledBorderColor;
  final ButtonState buttonState;
  final String text;
  final VoidCallback tapAction;
  final Duration? _duration;

  @override
  State<CommitButton> createState() => _CommitButtonState();
}

class _CommitButtonState extends State<CommitButton> {
  final ValueNotifier<bool> _isEnabled = ValueNotifier<bool>(true);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isEnabled,
      builder: (context, isEnabled, children) {
        return Container(
          margin: widget.margin ?? EdgeInsets.symmetric(horizontal: 30.w),
          width: double.maxFinite,
          height: widget.height ?? 90.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: background,
              border: Border.all(
                  color: widget.borderColor != null
                      ? btnBorderColor
                      : widget.borderColor ?? Colors.transparent,
                  width: 1.w)),
          child: TextButton(
            style: ButtonStyle(
                splashFactory: NoSplash.splashFactory,
                overlayColor: MaterialStateProperty.all(overlayColor)),
            onPressed: () {
              if (isEnabled) {
                _tapAction();
              }
            },
            child: child,
          ),
        );
      },
    );
  }

  void _tapAction() {
    if (widget.buttonState == ButtonState.normal) {
      _isEnabled.value = false;
      widget.tapAction();
      _timer = Timer(
        widget._duration ?? Duration.zero,
        () => _isEnabled.value = true,
      );
    }
  }

  Widget get child {
    if (widget.buttonState == ButtonState.loading) {
      return const CupertinoActivityIndicator();
    }
    return Text(
      widget.text,
      style: TextStyle(
          color: widget.textColor == null
              ? textColorDefault
              : widget.textColor ?? textColorDefault,
          fontSize: widget.fontSize ?? 34.sp,
          fontWeight: FontWeight.w500),
    );
  }

  Color get background {
    if (widget.buttonState == ButtonState.disabled) {
      return widget.disabledBackgroundColor ?? AppColors.buttonDisableColor;
    }
    if (widget.buttonState == ButtonState.loading) {
      return AppColors.buttonLoadingColor;
    }
    return widget.backgroundColor ?? AppColors.commonPrimary;
  }

  Color get textColorDefault {
    if (widget.buttonState == ButtonState.disabled) {
      return AppColors.buttonDisableTextColor;
    }
    return Colors.white;
  }

  Color get overlayColor {
    if (widget.buttonState == ButtonState.normal) {
      return widget.highlightColor ?? AppColors.buttonHighlightColor;
    }
    return Colors.transparent;
  }

  Color get btnBorderColor {
    if (widget.buttonState == ButtonState.disabled) {
      return widget.disabledBorderColor ?? background;
    }
    return widget.borderColor ?? background;
  }
}
