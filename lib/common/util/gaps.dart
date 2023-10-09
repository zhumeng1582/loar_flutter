// @Title:  gaps
// @Author: tomodel
// @Update: 2022/6/22 12:54
// @Description: 间隙控件

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../colors.dart';

class Gaps {

  static Widget line = Divider(
    height: 1,
    color: AppColors.line,
  );
  static Widget vLine = VerticalDivider(
    width: 1.h,
    color: AppColors.line,
  );
  static const Widget empty = SizedBox.shrink();
}
