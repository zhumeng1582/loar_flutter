import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/common/ex/ex_string.dart';
import 'package:loar_flutter/common/image.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';
import 'package:loar_flutter/common/util/images.dart';

import '../common/blue_tooth.dart';
import '../common/im_data.dart';
import '../common/util/coord_convert.dart';
import '../widget/bar_chart_painter.dart';
import '../widget/satellite_painter.dart';
import '../widget/common.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as UI;

Map<String, String> satelliteFlags = {
  "GPGSV": AssetsImages.flagUS,
  "GLGSV": AssetsImages.flagRUS,
  "GAGSV": AssetsImages.flagOM,
  "GQGSV": AssetsImages.flagJP,
  "GBGSV": AssetsImages.flagCN
};
Map<String, UI.Image> satelliteImage = {};
List<String> satelliteType = ["GPGSV", "GBGSV", "GLGSV", "GAGSV", "GQGSV"];
Map<String, String> satelliteName = {
  "GPGSV": "GPS",
  "GLGSV": "GLONASS",
  "GAGSV": "Galileo",
  "GQGSV": "QZSS",
  "GBGSV": "Beidou"
};

final satelliteNotifier =
    ChangeNotifierProvider<SatelliteNotifier>((ref) => SatelliteNotifier());

class GbgSv {
  int total;
  List<GbgSvSatellite> satellites;

  GbgSv(this.total, this.satellites);
}

class SatelliteNotifier extends ChangeNotifier {
  var svgData = <String, GbgSv>{};

  List<GbgSvSatellite> getAllStateList() {
    List<GbgSvSatellite> bars = [];
    svgData.values.forEach((element) {
      bars.addAll(element.satellites);
    });
    return bars;
  }

  init() async {
    satelliteFlags.forEach((key, value) async {
      satelliteImage[key] = await SatelliteData.loadAssetImage(value);
    });
  }

  void para(String gbgSvData) {
    List<String> gbgSvItems = gbgSvData.split(',');
    var type = gbgSvItems[0].replaceAll("\$", "");
    if (!satelliteType.contains(type)) {
      return;
    }
    if (gbgSvItems.contains("")) {
      return;
    }
    print("statellite--->${gbgSvData}");

    GbgSv gbgSv = svgData[type] ?? GbgSv(0, []);
    //新数据来了，清除之前的数据
    if (gbgSvItems[2] == "1") {
      gbgSv.satellites.clear();
    }

    var list = List<GbgSvSatellite>.generate(
        ((gbgSvItems.length - 5) / 4).toInt(), (index) {
      return GbgSvSatellite(
        type,
        gbgSvItems[4 + index * 4].toInt,
        gbgSvItems[5 + index * 4].toInt,
        gbgSvItems[6 + index * 4].toInt,
        gbgSvItems[7 + index * 4].toInt,
      );
    });
    gbgSv.total = int.parse(gbgSvItems[3]);
    gbgSv.satellites.addAll(list);
    svgData[type] = gbgSv;
    notifyListeners();
  }

  getLocation() {
    BlueToothConnect.instance
        .listenGps((message) => gpsParser(String.fromCharCodes(message)));
  }

  gpsParser(String value) {
    if (value.contains("GNRMC")) {
      var split = value.split(",");
      if (split.length < 5 || split[3].isEmpty || split[5].isEmpty) {
        return;
      }

      var latitude = BlueToothConnect.instance.convertGPRMCToDegrees(split[3]);
      var longitude = BlueToothConnect.instance.convertGPRMCToDegrees(split[5]);

      var bd09Coordinate =
          CoordConvert.gcj02tobd09(Coords(latitude, longitude));
      GlobeDataManager.instance
          .setLoarPosition(bd09Coordinate.latitude, bd09Coordinate.longitude);
    } else {
      para(value);
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<GbgSvSatellite> data = ref.watch(satelliteNotifier).getAllStateList();
    var barsWidth = data.length * 55.w;

    return Scaffold(
      appBar: getAppBar(context, "星图"),
      body: Column(
        children: [
          CustomPaint(
            painter: SatellitePainter(data),
            size: Size(600.w, 600.h),
          ).paddingTop(50.h).center(),
          CustomScrollView(
            scrollDirection: Axis.horizontal,
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: CustomPaint(
                  painter: BarChartPainter(data, 45.w, 10.w),
                  size: Size(max(barsWidth, 690.w), 400.h),
                ),
              ),
            ],
          ).height(400.h).paddingTop(40.h),
          Row(
            children: [
              satelliteStatic(satelliteType[0]).expanded(),
              satelliteStatic(satelliteType[1]).expanded(),
              satelliteStatic(satelliteType[2]).expanded(),
              satelliteStatic(satelliteType[3]).expanded(),
              satelliteStatic(satelliteType[4]).expanded(),
            ],
          ).paddingTop(40.h)
        ],
      ).paddingHorizontal(30.w),
    );
  }
}

extension _UI on _SatelliteMapPage {
  Widget satelliteStatic(String name) {
    var data = ref.watch(satelliteNotifier).svgData[name];
    var showName = satelliteName[name] ?? "";
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImageWidget.asset(satelliteFlags[name]!,
            width: 80.w, height: 80.h, radius: 60.r),
        Text(showName).paddingVertical(30.h),
        Text("${data?.satellites.length ?? "0"}"),
      ],
    );
  }
}
