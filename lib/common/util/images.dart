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

  static String getRandomAvatar(){
    return getAvatar(Random().nextInt(100)+1);
  }
  static String getAvatar(int number){
    return _loadFromPath(named:"avatar$number");
  }

  static String _loadFromPath({required String named}) =>
      'assets/images/$named.png';
}
