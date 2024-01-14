import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_bmflocation/flutter_bmflocation.dart';
import 'package:loar_flutter/common/im_data.dart';

final locationMapProvider =
    ChangeNotifierProvider<LocationMapNotifier>((ref) => LocationMapNotifier());

class LocationMapNotifier extends ChangeNotifier {
  final LocationFlutterPlugin _locationPlugin = LocationFlutterPlugin();
  final BaiduLocationIOSOption _iosOption =
      BaiduLocationIOSOption(coordType: BMFLocationCoordType.bd09ll);
  final BaiduLocationAndroidOption _androidOption =
      BaiduLocationAndroidOption(coordType: BMFLocationCoordType.bd09ll);

}
