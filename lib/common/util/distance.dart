import 'dart:math';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';

class Distance {
  static double getDistance(BMFCoordinate position1, BMFCoordinate position2) {
    double radLat1 = rad(position1.latitude);
    double radLat2 = rad(position1.latitude);
    double a = radLat1 - radLat2;
    double b = rad(position1.longitude) - rad(position1.longitude);
    double s = 2 *
        asin(sqrt(pow(sin(a / 2), 2) +
            cos(radLat1) * cos(radLat2) * pow(sin(b / 2), 2)));
    return s * 6378138.0; // 单位为米
  }

  static double rad(double d) {
    return d * pi / 180.0;
  }
}
