import 'package:flutter/material.dart';
import 'package:loar_flutter/widget/satellite_painter.dart';

class BarChartPainter extends CustomPainter {
  final List<GbgSvSatellite> datas;
  final double barWidth;
  final double gapWidth;
  static const double textFontSize = 9;
  double barHeight = 10;

  BarChartPainter(this.datas, this.barWidth, this.gapWidth);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    barHeight = size.height - textFontSize;
    Paint line = Paint()
      ..strokeWidth = 0.8
      ..color = Colors.grey;

    double height1 = size.height;
    double height2 = size.height - (barHeight / 4);
    double height3 = size.height - (barHeight * 2 / 4);
    double height4 = size.height - (barHeight * 3 / 4);
    double height5 = size.height - (barHeight * 4 / 4);
    canvas.drawLine(Offset(0, height1), Offset(size.width, height1), line);
    canvas.drawLine(Offset(0, height2), Offset(size.width, height2), line);
    canvas.drawLine(Offset(0, height3), Offset(size.width, height3), line);

    canvas.drawLine(Offset(0, height4), Offset(size.width, height4), line);
    canvas.drawLine(Offset(0, height5), Offset(size.width, height5), line);

    for (int i = 0; i < datas.length; i++) {
      double left = i * (barWidth + gapWidth);
      double top = size.height - (datas[i].snr / 100) * barHeight;
      double right = left + barWidth;
      double bottom = size.height;
      canvas.drawRect(Rect.fromLTRB(left, top, right, bottom), paint);

      // 为每个柱子添加数值
      const textStyle = TextStyle(
        color: Colors.black,
        fontSize: textFontSize,
      );
      final textSpan = TextSpan(
        text: datas[i].snr.toStringAsFixed(2),
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: size.width,
      );
      final offset = Offset(left, top - textPainter.height);
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(oldDelegate) => false;
}
