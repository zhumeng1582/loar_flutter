import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRGeneratePage extends ConsumerStatefulWidget {
  String qrCode;

  QRGeneratePage({Key? key, required this.qrCode}) : super(key: key);

  @override
  ConsumerState<QRGeneratePage> createState() => _QRGeneratePageState();
}

class _QRGeneratePageState extends ConsumerState<QRGeneratePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('二维码生成'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
      ),
      body: QrImageView(
        data: widget.qrCode, //扫描得到的内容
        version: QrVersions.auto,
        size: 200,
      ),
    );
  }
}
