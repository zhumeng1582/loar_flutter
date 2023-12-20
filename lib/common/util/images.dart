import 'dart:math';

class AssetsImages {
  static final microphone = _loadFromPath(named: 'microphone');
  static final voiceVolume1 = _loadFromPath(named: 'voice_volume_1');
  static final voiceVolume2 = _loadFromPath(named: 'voice_volume_2');
  static final voiceVolume3 = _loadFromPath(named: 'voice_volume_3');
  static final voiceVolume4 = _loadFromPath(named: 'voice_volume_4');
  static final voiceVolume5 = _loadFromPath(named: 'voice_volume_5');
  static final voiceVolume6 = _loadFromPath(named: 'voice_volume_6');
  static final voiceVolume7 = _loadFromPath(named: 'voice_volume_7');
  static final voiceVolumeTotal = _loadFromPath(named: 'voice_volume_total');
  static final defaultImage = _loadFromPath(named: 'defaultImage');
  static final iconMaker = _loadFromPath(named: 'iconMaker');
  static final iconMe = _loadFromPath(named: 'iconMe');
  static final iconScan = _loadFromPath(named: 'iconScan');
  static final iconInvite = _loadFromPath(named: 'iconInvite');
  static final iconSuccess = _loadFromPath(named: 'iconSuccess');
  static final iconSearch = _loadFromPath(named: 'iconSearch');
  static final iconAdd = _loadFromPath(named: 'iconAdd');
  static final iconLauncher = _loadFromPath(named: 'ic_launcher');
  static final iconBlueTooth = _loadFromPath(named: 'iconBlueTooth');
  static final iconBlueToothOpen = _loadFromPath(named: 'iconBlueToothOpen');
  static final iconDown = _loadFromPath(named: 'iconDown');
  static final iconShopping = _loadFromPath(named: 'iconShopping');
  static final iconForum = _loadFromPath(named: 'iconForum');
  static final iconPeople = _loadFromPath(named: 'iconPeople');

  static final iconDingWei = _loadFromPath(named: 'iconDingWei');
  static final iconFenXin = _loadFromPath(named: 'iconFenXin');
  static final iconSheQu = _loadFromPath(named: 'iconSheQu');
  static final iconTongXun = _loadFromPath(named: 'iconTongXun');
  static final iconWode = _loadFromPath(named: 'iconWode');

  static final iconDingWeiSel = _loadFromPath(named: 'iconDingWeiSel');
  static final iconFenXinSel = _loadFromPath(named: 'iconFenXinSel');
  static final iconSheQuSel = _loadFromPath(named: 'iconSheQuSel');
  static final iconTongXunSel = _loadFromPath(named: 'iconTongXunSel');
  static final iconWodeSel = _loadFromPath(named: 'iconWodeSel');
  static final iconDaohang = _loadFromPath(named: 'iconDaohang');

  static final iconAbout = _loadFromPath(named: 'iconAbout');
  static final iconID = _loadFromPath(named: 'iconID');
  static final iconPengYouQuan = _loadFromPath(named: 'iconPengYouQuan');
  static final iconSetting = _loadFromPath(named: 'iconSetting');
  static final iconGeRen = _loadFromPath(named: 'iconGeRen');
  static final banner = _loadFromPath(named: 'banner');
  static final button = _loadFromPath(named: 'button');
  static final flagCN = _loadFromPath(named: 'flagCN');
  static final flagUS = _loadFromPath(named: 'flagUS');
  static final flagRUS = _loadFromPath(named: 'flagRUS');
  static final flagELse = _loadFromPath(named: 'flagELse');
  static final flagOM = _loadFromPath(named: 'flagOM');
  static final flagJP = _loadFromPath(named: 'flagJP');
  static final iconFenLin = _loadFromPath(named: 'iconFenLin');
  static final iconFengWo = _loadFromPath(named: 'iconFenWo');
  static final iconFenJu = _loadFromPath(named: 'iconFenJu');
  static final iconFenXing = _loadFromPath(named: 'iconFenXing');

  static String getRandomAvatar() {
    return getAvatar(Random().nextInt(100) + 1);
  }

  static String getDefaultAvatar() {
    return getAvatar(1);
  }

  static String getAvatar(int number) {
    return _loadFromPath(named: "avatar$number");
  }

  static String _loadFromPath({required String named}) =>
      'assets/images/$named.png';

  static String loadImageFromName({required String named}) =>
      'assets/images/$named';
}
