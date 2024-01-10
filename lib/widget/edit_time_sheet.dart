import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/common/ex/ex_widget.dart';

import '../common/colors.dart';
import '../common/loading.dart';
import '../common/util/images.dart';
import '../common/util/navigator.dart';
import 'bottom_sheet.dart';
import 'commit_button.dart';

class EditTimeBottomSheet extends StatefulWidget {
  final BuildContext context;
  final bool Function(String) onConfirm;
  final String data;

  const EditTimeBottomSheet({
    Key? key,
    required this.context,
    required this.data,
    required this.onConfirm,
  }) : super(key: key);

  static void show({
    required BuildContext context,
    required String data,
    required bool Function(String) onConfirm,
    TextInputType? keyboardType,
    int maxLength = 12,
  }) {
    final view = EditTimeBottomSheet(
      context: context,
      data: data,
      onConfirm: onConfirm,
    );
    ActionBottomSheet.popModal(
      context: context,
      enableDrag: false,
      child: view,
    );
  }

  @override
  State<EditTimeBottomSheet> createState() => _EditRemarkBottomSheetState();
}

class _EditRemarkBottomSheetState extends State<EditTimeBottomSheet> {
  late final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textController.text = widget.data;
    textController.addListener(_inputValueChange);
  }

  void _inputValueChange() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
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
            _buildNavBar(context, "请输入"),
            SizedBox(height: 10.h),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(
                  child: TextField(
                      keyboardType: TextInputType.number,
                      controller: textController,
                      autofocus: true,
                      style: TextStyle(
                        fontSize: 28.sp,
                        color: AppColors.title,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        counterText: "",
                        hintText: "请输入",
                        contentPadding: EdgeInsets.zero,
                        // suffix: textController.text.isNotEmpty
                        //     ? InkWell(
                        //         onTap: () => textController.clear(),
                        //         child: Image.asset(
                        //           AssetsImages.close,
                        //           width: 32.w,
                        //           height: 32.w,
                        //         ),
                        //       )
                        //     : null,
                        hintStyle: TextStyle(
                          fontSize: 28.sp,
                          color: AppColors.title.withOpacity(0.4),
                          fontWeight: FontWeight.w400,
                        ),
                      ))),
            ])
                .paddingHorizontal(15.w)
                .backgroundColor(AppColors.title.withOpacity(0.03))
                .paddingHorizontal(30.w)
                .paddingTop(5.h)
                .paddingBottom(25.h)
                .borderRadius(60.r),
            buildCommitButton()
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

  void _onConfirm() {
    bool ret = widget.onConfirm(textController.text);
    if (ret) {
      Loading.success("成功");
      Navigator.of(context).pop();
    }
  }
}

extension _UI on _EditRemarkBottomSheetState {
  CommitButton buildCommitButton() {
    return CommitButton(
      buttonState: ButtonState.normal,
      margin: EdgeInsets.only(top: 15.w, bottom: 15.w, left: 26.w, right: 26.w),
      text: "确认",
      tapAction: () => _onConfirm(),
    );
  }
}
