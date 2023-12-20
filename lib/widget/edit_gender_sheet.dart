import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/common/ex/ex_widget.dart';

import '../common/colors.dart';
import '../common/loading.dart';
import '../common/util/images.dart';
import '../common/util/navigator.dart';
import 'bottom_sheet.dart';
import 'commit_button.dart';

class EditGenderBottomSheet extends StatefulWidget {
  final BuildContext context;
  final ValueChanged<int>? onConfirm;
  final String data;
  final int? maxLength;

  const EditGenderBottomSheet(
      {Key? key,
      required this.context,
      required this.data,
      this.onConfirm,
      this.maxLength})
      : super(key: key);

  static void show({
    required BuildContext context,
    required String data,
    ValueChanged<int>? onConfirm,
    int maxLength = 12,
  }) {
    final view = EditGenderBottomSheet(
      context: context,
      data: data,
      onConfirm: onConfirm,
      maxLength: maxLength,
    );
    ActionBottomSheet.popModal(
      context: context,
      enableDrag: false,
      child: view,
    );
  }

  @override
  State<EditGenderBottomSheet> createState() => _EditGenderBottomSheetState();
}

class _EditGenderBottomSheetState extends State<EditGenderBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      duration: Duration.zero,
      child: Container(
        height: 347.h,
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(8.r),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
          color: AppColors.background,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildNavBar(context, "请选择性别"),
            const Text("男").padding(all: 32.w).width(double.infinity).onTap(() {
              _onConfirm(1);
            }),
            const Text("女").padding(all: 32.w).width(double.infinity).onTap(() {
              _onConfirm(2);
            }),
            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }

  /// 顶部导航
  Widget _buildNavBar(BuildContext context, String title) {
    return Container(
      height: 84.h,
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Stack(
        children: <Widget>[
          Container(),
          Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 30.sp,
                  color: AppColors.title,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () => NavigatorHelper.autoPop(context),
              child: Icon(Icons.close, size: 12.0),
            ),
          ),
        ],
      ),
    );
  }

  void _onConfirm(int value) {
    widget.onConfirm?.call(value);
    Navigator.of(context).pop();
  }
}

extension _UI on _EditGenderBottomSheetState {}
