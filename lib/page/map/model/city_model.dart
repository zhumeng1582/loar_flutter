import 'package:azlistview/azlistview.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:lpinyin/lpinyin.dart';

class CityModel extends ISuspensionBean {
  String? tagIndex;
  BMFOfflineCityRecord city;

  CityModel({required this.city, this.tagIndex}) {
    if (tagIndex == null) {
      String pinyin = PinyinHelper.getPinyinE(city.cityName!);
      String tag = pinyin.substring(0, 1).toUpperCase();
      if (RegExp('[A-Z]').hasMatch(tag)) {
        tagIndex = tag;
      } else {
        tagIndex = '#';
      }
    }
  }

  @override
  String getSuspensionTag() => tagIndex!;
}
