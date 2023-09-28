import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widget/ball_view.dart';
final satelliteNotifier = ChangeNotifierProvider<SatelliteNotifier>((ref) => SatelliteNotifier());

class SatelliteNotifier extends ChangeNotifier {
  List<Ball>  balls = [];

  random(min, max) {
    // + min  表示生成一个最小数 min 到最大数之间的是数字
    var num = Random().nextDouble() * (max - min) + min;

    return num;
  }

  initData() {
    balls.clear();
    for (int i = 0; i < 40;) {
      var x = random(0, 280);
      var y = random(0, 280);

      if (pow(x - 140,2) + pow(y - 140,2) < pow(130,2)) {
        var ball = Ball(
            color: i % 3 == 1
                ? Colors.greenAccent
                : i % 3 == 2
                ? Colors.redAccent
                : Colors.blueAccent,
            x: x,
            y: y);
        balls.add(ball);
        i++;
      }
    }
  }
}
class SatelliteMapPage extends ConsumerStatefulWidget {


  const SatelliteMapPage({super.key});

  @override
  ConsumerState<SatelliteMapPage> createState() => _SatelliteMapPage();

}
class _SatelliteMapPage extends ConsumerState<SatelliteMapPage> {

  @override
  Widget build(BuildContext context) {
    ref.watch(satelliteNotifier).initData();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("卫星地图"),
      ),
      body: CustomPaint(
        painter: RunBallView(ref.watch(satelliteNotifier).balls),
      ),
    );
  }
}