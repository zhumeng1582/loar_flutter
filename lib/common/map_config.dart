import 'package:amap_flutter_base/amap_flutter_base.dart';

class MapConfig {
  static const AMapApiKey amapApiKeys =
      AMapApiKey(androidKey: '11410eb4cecfe4710758acf4abca3130', iosKey: '8d49c01883b3cd56b187b3b8d2757031');
  static const AMapPrivacyStatement amapPrivacyStatement =
      AMapPrivacyStatement(hasContains: true, hasShow: true, hasAgree: true);
}
