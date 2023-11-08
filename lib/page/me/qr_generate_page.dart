import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../common/proto/qr_code_data.dart';

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
      appBar: AppBar(
        title: Text(getTitle()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            QrImageView(
              data: jsonEncode(widget.qrCodeData.toJson()),
              version: QrVersions.auto,
              size: 200,
            ).paddingTop(180.h),
            Text('请扫码')
          ],
        ),
      ),
    );
  }
}

extension _Action on _QRGeneratePageState {
  String getTitle() {
    return widget.qrCodeData.room?.name ??
        widget.qrCodeData.userInfo?.nickName ??
        "";
  }
}
