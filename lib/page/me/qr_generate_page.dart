import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/common/ex/ex_im.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';
import 'package:loar_flutter/common/util/images.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../common/image.dart';
import '../../common/proto/qr_code_data.dart';
import '../../widget/common.dart';

class QRGeneratePage extends ConsumerStatefulWidget {
  QrCodeData qrCodeData;

  QRGeneratePage({Key? key, required this.qrCodeData}) : super(key: key);

  @override
  ConsumerState<QRGeneratePage> createState() => _QRGeneratePageState();
}

class _QRGeneratePageState extends ConsumerState<QRGeneratePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, "二维码"),
      body: Center(
        child: Column(
          children: [
            Stack(
              children: [
                QrImageView(
                  data: jsonEncode(widget.qrCodeData.toJson()),
                  version: QrVersions.auto,
                  gapless: false,
                  size: 200,
                ),
                getImage()
              ],
            ).paddingTop(180.h),
            Text(getTips()).paddingTop(50.h)
          ],
        ),
      ),
    );
  }
}

extension _Action on _QRGeneratePageState {
  String getTitle() {
    return widget.qrCodeData.room?.showName ??
        widget.qrCodeData.userInfo?.name ??
        "";
  }

  String getTips() {
    if (widget.qrCodeData.room == null) {
      return "扫码上方的二维码，加我为朋友";
    } else {
      return "扫码上方的二维码，加入群聊";
    }
  }

  Widget getImage() {
    return Positioned(
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        child: Center(
          child: Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            child: ImageWidget(
              url: widget.qrCodeData.userInfo?.avatarName??AssetsImages.iconLauncher,
              width: 80.w,
              height: 80.h,
              type: ImageWidgetType.asset,
            ),
          ),
        ));
  }
}
