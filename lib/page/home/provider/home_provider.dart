import 'dart:convert';

import 'package:barcode_scan2/model/android_options.dart';
import 'package:barcode_scan2/model/scan_options.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';

import '../../../common/proto/qr_code_data.dart';

final homeProvider =
    ChangeNotifierProvider<HomeNotifier>((ref) => HomeNotifier());

class HomeNotifier extends ChangeNotifier {
  Future<QrCodeData> scan() async {
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
    return qrCodeData as QrCodeData;
  }
}
