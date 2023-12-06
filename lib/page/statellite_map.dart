import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/common/image.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';
import 'package:loar_flutter/common/util/images.dart';

import '../widget/satellite_painter.dart';
import '../widget/common.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

final satelliteNotifier =
    ChangeNotifierProvider<SatelliteNotifier>((ref) => SatelliteNotifier());

class SatelliteNotifier extends ChangeNotifier {
  List<String> satelliteType = ["GPS", "GLONASS", "北斗", "其他"];

  Map<String, String> satelliteFlags = {
    "GPS": AssetsImages.flagUS,
    "GLONASS": AssetsImages.flagRUS,
    "北斗": AssetsImages.flagCN,
    "其他": AssetsImages.flagELse
  };
  List<SatelliteData> data = [];

  random(min, max) {
    // + min  表示生成一个最小数 min 到最大数之间的是数字
    var num = Random().nextDouble() * (max - min) + min;
    return num;
  }

  Future<ui.Image> loadAssetImage(String path) async {
    // 加载资源文件
    final data = await rootBundle.load(path);
    // 把资源文件转换成Uint8List类型
    final bytes = data.buffer.asUint8List();
    // 解析Uint8List类型的数据图片
    final completer = Completer<ui.Image>();

    ui.decodeImageFromList(bytes, (image) {
      completer.complete(image);
    });
    return completer.future;
  }

  randomInt(max) {
    // + min  表示生成一个最小数 min 到最大数之间的是数字
    var num = Random().nextInt(max);
    return num;
  }

  initData() async {
    data.clear();
    for (int i = 0; i < 10; i++) {
      int type = randomInt(4);
      String name = satelliteType[type];
      ui.Image image = await loadAssetImage(satelliteFlags[name]!);
      data.add(SatelliteData(name, i, image, random(0, 360), random(0, 90)));
    }
    notifyListeners();
  }
}

class SatelliteMapPage extends ConsumerStatefulWidget {
  const SatelliteMapPage({super.key});

  @override
  ConsumerState<SatelliteMapPage> createState() => _SatelliteMapPage();
}

class _SatelliteMapPage extends ConsumerState<SatelliteMapPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(satelliteNotifier).initData();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, "卫星星图"),
      body: Column(
        children: [
          CustomPaint(
            painter: SatellitePainter(ref.watch(satelliteNotifier).data),
            size: Size(600.w, 600.h),
          ).paddingTop(80.h).center(),
          Row(
            children: [
              satelliteStatic(ref.watch(satelliteNotifier).satelliteType[0])
                  .expanded(),
              satelliteStatic(ref.watch(satelliteNotifier).satelliteType[1])
                  .expanded(),
              satelliteStatic(ref.watch(satelliteNotifier).satelliteType[2])
                  .expanded(),
              satelliteStatic(ref.watch(satelliteNotifier).satelliteType[3])
                  .expanded(),
            ],
          ).paddingHorizontal(80.w).paddingTop(80.h)
        ],
      ),
    );
  }
}

extension _UI on _SatelliteMapPage {
  Widget satelliteStatic(String name) {
    var data = ref
        .watch(satelliteNotifier)
        .data
        .where((element) => element.name == name)
        .toList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImageWidget.asset(ref.read(satelliteNotifier).satelliteFlags[name]!,
            width: 40.w, height: 40.h, radius: 60.r),
        Text(name).paddingVertical(30.h),
        Text("${data.length}"),
      ],
    );
  }
}
