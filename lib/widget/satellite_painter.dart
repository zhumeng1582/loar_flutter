import 'dart:math';
import 'dart:ui' as UI;

import 'package:flutter/material.dart';

class SatelliteData {
  final String name;
  final int count;
  final double value;
  final UI.Image flag;
  final double azimuth;
  final double elevation;

  SatelliteData(this.name, this.count, this.value, this.flag, this.azimuth,
      this.elevation);
}

class SatellitePainter extends CustomPainter {
  final List<SatelliteData> data;

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
      Rect src = Rect.fromLTWH(0, 0, satellite.flag.width.toDouble(),
          satellite.flag.height.toDouble());

      Rect dst = Rect.fromLTWH(
          satellitePosition.dx - 5, satellitePosition.dy - 5, 10, 10);
      canvas.drawImageRect(satellite.flag, src, dst, Paint());

      // 在卫星位置绘制一个小圆代表卫星
      // canvas.drawImage(satellite.flag, satellitePosition, Paint());

      // 在卫星位置写上卫星名
      final textPainter = TextPainter(
        text: TextSpan(
            text: "${satellite.count}",
            style: const TextStyle(color: Colors.black)),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, satellitePosition);
    }
  }
}
