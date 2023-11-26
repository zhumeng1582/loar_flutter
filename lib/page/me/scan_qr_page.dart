import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

import '../../widget/common.dart';

class ScanQRPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ScanQRState();
  }
}

class _ScanQRState extends State<ScanQRPage> {
  String? scanResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, "扫码二维码"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextButton(
              child: const Text("Scan Now"),
              onPressed: () async {
                var options = const ScanOptions(
                    android: AndroidOptions(
                        aspectTolerance: 0.5, useAutoFocus: true),
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
                setState(() {
                  scanResult = result.rawContent;
                });
              },
            ),
            Text(
              scanResult ?? '',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
