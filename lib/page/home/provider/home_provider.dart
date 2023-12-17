import 'dart:convert';

import 'package:barcode_scan2/model/android_options.dart';
import 'package:barcode_scan2/model/scan_options.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/loading.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../common/proto/qr_code_data.dart';

final homeProvider =
    ChangeNotifierProvider<HomeNotifier>((ref) => HomeNotifier());

class HomeNotifier extends ChangeNotifier {
  Future<QrCodeData?> scan() async {
    await Permission.camera.request();

    var isGranted = await Permission.camera.isGranted;
    if (isGranted) {
      var options = const ScanOptions(
          android: AndroidOptions(aspectTolerance: 0.5, useAutoFocus: true),
          //(默认已配)添加Android自动对焦
          autoEnableFlash: false,
          //true打开闪光灯, false关闭闪光灯
          strings: {
            'cancel': '退出',
            'flash_on': '开闪光灯',
            'flash_off': '关闪光灯'
          } //标题栏添加闪光灯按钮、退出按钮
      );
      var result = await BarcodeScanner.scan(options: options);
      var qrCodeData = jsonDecode(result.rawContent);
      return QrCodeData.fromJson(qrCodeData);
    } else {
      Loading.error("请在手机设置里打开摄像头权限");
    }
  }
}
