import 'dart:async';
import 'dart:math';
import 'dart:ui' as UI;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../page/statellite_map.dart';

class GbgSvSatellite {
  String name;

  //编号
  int prn;

  //仰角
  int elevation;

  //方位角
  int azimuth;

  //分贝
  int snr;

  GbgSvSatellite(this.name, this.prn, this.elevation, this.azimuth, this.snr);
}

class SatelliteData {
  static Future<UI.Image> loadAssetImage(String path) async {
    // 加载资源文件
    final data = await rootBundle.load(path);
    // 把资源文件转换成Uint8List类型
    final bytes = data.buffer.asUint8List();
    // 解析Uint8List类型的数据图片
    final completer = Completer<UI.Image>();

    UI.decodeImageFromList(bytes, (image) {
      completer.complete(image);
    });
    return completer.future;
  }
}

class SatellitePainter extends CustomPainter {
  final List<GbgSvSatellite> data;

  SatellitePainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    // 在这里实现绘图逻辑
    final radius = min(size.width, size.height) / 2;
    final center = Offset(size.width / 2, size.height / 2);
    paintBackground(canvas, center, radius);
    paintOrientation(canvas, center, radius);
    paintSatellite(canvas, center, radius);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void paintOrientation(Canvas canvas, Offset center, double radius) {
    // 画东南西北方向
    final textPainterN = TextPainter(
        text: const TextSpan(text: 'N', style: TextStyle(color: Colors.black)),
        textDirection: TextDirection.ltr);
    final textPainterS = TextPainter(
        text: const TextSpan(text: 'S', style: TextStyle(color: Colors.black)),
        textDirection: TextDirection.ltr);
    final textPainterW = TextPainter(
        text: const TextSpan(text: 'W', style: TextStyle(color: Colors.black)),
        textDirection: TextDirection.ltr);
    final textPainterE = TextPainter(
        text: const TextSpan(text: 'E', style: TextStyle(color: Colors.black)),
        textDirection: TextDirection.ltr);

    textPainterN.layout();
    textPainterS.layout();
    textPainterW.layout();
    textPainterE.layout();

    textPainterN.paint(
        canvas,
        Offset(center.dx - textPainterN.width / 2,
            center.dy - radius - textPainterN.height));
    textPainterS.paint(
        canvas, Offset(center.dx - textPainterS.width / 2, center.dy + radius));
    textPainterW.paint(
        canvas,
        Offset(center.dx - radius - textPainterW.width,
            center.dy - textPainterW.height / 2));
    textPainterE.paint(canvas,
        Offset(center.dx + radius, center.dy - textPainterE.height / 2));
  }

  void paintBackground(Canvas canvas, Offset center, double radius) {
    canvas.drawColor(Colors.deepPurple, BlendMode.color);
    final paint = Paint()
      ..strokeWidth = 1.0
      ..color = Colors.black
      ..style = PaintingStyle.stroke;

    // 画外部圈圈
    canvas.drawCircle(center, radius, paint);

    // 画中间圈圈
    canvas.drawCircle(center, radius * 2 / 3, paint);

    // 画内部圈圈
    canvas.drawCircle(center, radius / 3, paint);

    // 画8条方位角等分线
    for (var i = 0; i < 8; i++) {
      final angle = pi / 4 * i;
      final dx = cos(angle) * radius;
      final dy = sin(angle) * radius;
      canvas.drawLine(center, center.translate(dx, dy), paint);
    }
  }

  void paintSatellite(Canvas canvas, Offset center, double radius) {
    // 绘制卫星
    for (var satellite in data) {
      final angle = (satellite.azimuth * pi) / 180; // 方位角转为弧度
      final len =
          cos((satellite.elevation * pi) / 180) * radius; // 用俯仰角计算卫星投影点到圆心的距离
      final dx = cos(angle) * len;
      final dy = sin(angle) * len;
      final satellitePosition = center.translate(dx, dy);
      var flag = satelliteImage[satellite.name]!;
      Rect src =
          Rect.fromLTWH(0, 0, flag.width.toDouble(), flag.height.toDouble());

      Rect dst = Rect.fromLTWH(
          satellitePosition.dx - 5, satellitePosition.dy - 5, 10, 10);
      canvas.drawImageRect(flag, src, dst, Paint());

      // 在卫星位置绘制一个小圆代表卫星
      // canvas.drawImage(satellite.flag, satellitePosition, Paint());

      // 在卫星位置写上卫星名
      final textPainter = TextPainter(
        text: TextSpan(
            text: "${satellite.prn}",
            style: const TextStyle(color: Colors.black)),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, satellitePosition);
    }
  }
}
