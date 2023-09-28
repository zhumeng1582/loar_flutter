import 'dart:math';
import 'dart:ui' as UI;
import 'package:flutter/material.dart';

///小球信息描述类
class Ball {
  double x; //点位X
  double y; //点位Y
  Color color; //颜色
  double r; //小球半径

  Ball({required this.color, this.x = 0, this.y = 0, this.r = 10});
}

///画板Painter
class RunBallView extends CustomPainter {
  late final List<Ball> _lisBall; //小球
  late Offset _center; //中心
  late double _radius; //半径
  late Paint mPaint; //主画笔
  late Paint bgPaint; //背景画笔
  double cos45 = 0.707;

  RunBallView(this._lisBall) {
    mPaint = Paint();
    _center = const Offset(140, 140);
    _radius = 140;
    bgPaint = Paint()..color = Colors.black;
    bgPaint.style = PaintingStyle.stroke;
    bgPaint.strokeWidth = 0.5;
  }

  double _toRadius(double degree) => degree * pi / 180;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset(0, _radius), Offset(280, _radius), bgPaint);

    canvas.drawLine(Offset(_radius, 0), Offset(_radius, 280), bgPaint);

    canvas.drawLine(Offset(_radius * (1 - cos45), _radius * (1 - cos45)),
        Offset(_radius * (1 + cos45), _radius * (1 + cos45)), bgPaint);
    canvas.drawLine(Offset(_radius * (1 + cos45), _radius * (1 - cos45)),
        Offset(_radius * (1 - cos45), _radius * (1 + cos45)), bgPaint);

    canvas.drawArc(Rect.fromCircle(center: _center, radius: _radius), 0, 6.28,
        false, bgPaint);
    canvas.drawArc(
        Rect.fromCircle(center: const Offset(140, 140), radius: _radius * 0.67),
        0,
        6.28,
        false,
        bgPaint);
    canvas.drawArc(
        Rect.fromCircle(center: const Offset(140, 140), radius: _radius * 0.33),
        0,
        6.28,
        false,
        bgPaint);


    _drawBall(canvas, _lisBall);
    _drawArcProgressPoint(canvas, _radius, _radius, _radius);
  }

  void _drawArcProgressPoint(Canvas canvas, double cx, double cy, num radius) {
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(_toRadius(0));
    canvas.translate(-cx, -cy);
    for (int i = 0; i < 24; i++) {
      num evaDegree = _toRadius(-90) + i * _toRadius(360 / 24);

      double x = cx + (radius - 15) * cos(evaDegree);
      double y = cy + (radius - 15) * sin(evaDegree);
      double x1 = cx + (radius) * cos(evaDegree);
      double y1 = cx + (radius) * sin(evaDegree);
      canvas.drawLine(Offset(x, y), Offset(x1, y1), bgPaint);
    }

    for (int i = 0; i < 24; i++) {
      var value = i * 15;
      var degree = 0.0;
      var showName = "";
      if (value == 0) {
        showName = "N";
        degree = 0;
      } else if (value == 45) {
        showName = "45";
        degree = 0;
      } else if (value == 90) {
        showName = "E";
        degree = 90;
      } else if (value == 135) {
        showName = "135";
        degree = 0;
      } else if (value == 180) {
        showName = "S";
        degree = 0;
      } else if (value == 225) {
        showName = "225";
        degree = 0;
      } else if (value == 270) {
        showName = "W";
        degree = 0;
      } else if (value == 315) {
        showName = "315";
        degree = 0;
      }
      if (showName != "") {
        canvas.translate(cx, cy);
        canvas.rotate(_toRadius(0));
        canvas.translate(-cx, -cy);
        var pb = UI.ParagraphBuilder(
            UI.ParagraphStyle(fontSize: 15, textAlign: TextAlign.start))
          ..pushStyle(UI.TextStyle(color: Colors.black))
          ..addText(showName);
        UI.Paragraph p = pb.build()
          ..layout(const UI.ParagraphConstraints(width: 30));
        num evaDegree = _toRadius(-90) + i * _toRadius(360 / 24);
        num x = cx + (radius - 20) * cos(evaDegree);
        num y = cy + (radius - 20) * sin(evaDegree);
        canvas.drawParagraph(p, Offset(x - 8, y - 10));
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  ///使用[canvas] 绘制某个[ball]
  void _drawBall(Canvas canvas, List<Ball> balls) {
    for (var ball in balls) {
      canvas.drawCircle(
          Offset(ball.x, ball.y), ball.r, mPaint..color = ball.color);
    }
  }
}
