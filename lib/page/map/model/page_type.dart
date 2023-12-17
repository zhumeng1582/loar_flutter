import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';

import '../../../common/ex/ex_userInfo.dart';

enum PageType {
  me,
  nearBy,
  distance,
  navigation,
}

class MapDataPara {
  PageType pageType;

  // BMFCoordinate? me;
  OnlineUser? other;

  MapDataPara(this.pageType, {this.other});
}
