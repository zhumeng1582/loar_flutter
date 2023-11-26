// @Title:  LoginTextField
// @Author: tomodel
// @Update: 2023/4/14 14:15
// @Description:

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/colors.dart';
import 'custom_button.dart';

class LoginTextField extends StatefulWidget {
  const LoginTextField({
    Key? key,
    required this.controller,
    this.enabled = true,
    this.fillColor,
    this.autoFocus = false,
    this.keyboardType = TextInputType.text,
    this.hintText = '',
    this.focusNode,
    this.isInputPwd = false,
    this.isHaveDelete = true,
    this.maxLines = 1,
    this.minLines,
    this.focusedBorderColor,
    this.style,
    this.prefixIcons,
    this.suffixIcons,
  }) : super(key: key);

  /// 输入框文本编辑的控制器
  final TextEditingController controller;

  /// 是否可以输入
  final bool enabled;

  /// 是否自动获得焦点
  final bool autoFocus;

  /// 键盘样式
  final TextInputType keyboardType;

  /// 输入框提示内容
  final String hintText;

  /// 动态获得焦点和失去焦点
  final FocusNode? focusNode;

  /// 是否是密码框输入
  final bool isInputPwd;

  /// 是否有删除按钮
  final bool isHaveDelete;

  /// 按钮颜色
  final Color? focusedBorderColor;

  /// 输入框最大行数
  final int? maxLines;

  /// 输入框最小行数
  final int? minLines;

  /// 内容样式
  final TextStyle? style;
  final Color? fillColor;

  /// 前面功能按钮
  final List<Widget>? prefixIcons;

  /// 后面功能按钮
  final List<Widget>? suffixIcons;

  @override
  State<StatefulWidget> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  /// 是否密码输入框
  bool _isShowPwd = false;

  /// 控制内部clearButton 显示
  bool _isShowDelete = false;

  @override
  void initState() {
    /// 获得初始化值
    _isShowDelete = widget.controller.text.isNotEmpty;

    /// 监听输入变化
    widget.controller.addListener(isEmpty);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(isEmpty);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = buildSuffixIconData();
    return TextField(
      enabled: widget.enabled,
      autofocus: widget.autoFocus,
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: widget.isInputPwd && !_isShowPwd,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      keyboardType: widget.keyboardType,
      autocorrect: false,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      style: widget.style,
      decoration: InputDecoration(
        border: InputBorder.none,
        // contentPadding: EdgeInsets.all(25.w),
        contentPadding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 16.0),
        hintText: widget.hintText,
        hintStyle:
            TextStyle(color: AppColors.title.withOpacity(0.3), fontSize: 28.sp),
        suffixIcon: data.isEmpty ? null : _buildSuffixIcons(data),
        prefixIcon: widget.prefixIcons == null
            ? null
            : _buildPrefixIcons(widget.prefixIcons!),
        filled: true,
        fillColor: widget.fillColor ?? AppColors.inputBgColor,
      ),
    );
  }
}

extension _UI on _LoginTextFieldState {
  List<Widget> buildSuffixIconData() {
    final suffixIcons = <Widget>[];
    if (_isShowDelete && widget.isHaveDelete) {
      /// 清空按钮
      suffixIcons.add(SizedBox(
        width: 40.w,
        child: CustomButton(
          onPressed: () => widget.controller.text = '',
          icon: Icon(
            Icons.clear,
            size: 26.w,
          ),
          alignment: IconTextAlignment.iconOnly,
          // backgroundColor: appColors.background,
        ),
      ));
    }

    if (widget.isInputPwd) {
      suffixIcons.add(SizedBox(
        width: 70.w,
        child: CustomButton(
          onPressed: () {
            setState(() {
              _isShowPwd = !_isShowPwd;
            });
          },
          icon: Icon(
            _isShowPwd ? Icons.visibility : Icons.visibility_off,
            size: 30.w,
          ),
          alignment: IconTextAlignment.iconOnly,
          // backgroundColor: appColors.background,
        ),
      ));
    }

    if (widget.suffixIcons != null) {
      widget.suffixIcons?.forEach((element) {
        suffixIcons.add(element);
      });
    }
    return suffixIcons;
  }

  Widget _buildSuffixIcons(List<Widget> widgets) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: widgets,
    );
  }

  Widget _buildPrefixIcons(List<Widget> widgets) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: widgets,
    );
  }
}

extension _Action on _LoginTextFieldState {
  void isEmpty() {
    final bool isNotEmpty = widget.controller.text.isNotEmpty;

    /// 状态不一样在刷新，避免重复不必要的setState
    if (isNotEmpty != _isShowDelete) {
      setState(() {
        _isShowDelete = isNotEmpty;
      });
    }
  }
}
