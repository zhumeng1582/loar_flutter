import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BlueToothConnect {
  BlueToothConnect._();

  final String _SET_SERVICE_UUID = "000000F1-0000-1000-8000-00805F9B34FB";
  final String _SET_CHAR_UUID = "0000AE01-0000-1000-8000-00805F9B34FB";

  final String _LORA_SERVICE_UUID = "000000F2-0000-1000-8000-00805F9B34FB";
  final String _LORA_CHAR_UUID = "0000AE02-0000-1000-8000-00805F9B34FB";

  final String _GPS_SERVICE_UUID = "000000F3-0000-1000-8000-00805F9B34FB";
  final String _GPS_CHAR_UUID = "0000AE03-0000-1000-8000-00805F9B34FB";

  static BlueToothConnect get instance => _getInstance();
  static BlueToothConnect? _instance;
  BluetoothDevice? device;
  BluetoothCharacteristic? gpsChar;
  BluetoothCharacteristic? loarChar;
  BluetoothCharacteristic? setChar;

  static BlueToothConnect _getInstance() {
    _instance ??= BlueToothConnect._();
    return _instance!;
  }

  connect(ScanResult value, Function success, Function fail) async {
    await value.device
        .connect(timeout: const Duration(seconds: 35))
        .catchError((e) {fail(e);})
        .then((v) {device = value.device;});

    var servicesList = await device?.discoverServices();
    var service = servicesList?.firstWhere((element) =>
        element.serviceUuid.toString().toUpperCase() == _LORA_SERVICE_UUID);
    loarChar = service?.characteristics.firstWhere((element) =>
        element.characteristicUuid.toString().toUpperCase() == _LORA_CHAR_UUID);

    var serviceGps = device?.servicesList?.firstWhere((element) =>
        element.serviceUuid.toString().toUpperCase() == _GPS_SERVICE_UUID);
    gpsChar = serviceGps?.characteristics.firstWhere((element) =>
        element.characteristicUuid.toString().toUpperCase() == _GPS_CHAR_UUID);

    var serviceSet = device?.servicesList?.firstWhere((element) =>
        element.serviceUuid.toString().toUpperCase() == _SET_SERVICE_UUID);
    setChar = serviceSet?.characteristics.firstWhere((element) =>
        element.characteristicUuid.toString().toUpperCase() == _SET_CHAR_UUID);

    value.device.connectionState.listen((BluetoothConnectionState state) {
      if (state == BluetoothConnectionState.connected) {
        success();
      }
    });
  }
   void setLedOnOff(bool on) {
    List<int> data = [0xF2,on?1:0];
    _write(setChar!, data);
  }

  void setLoraMode(int mode) {
    List<int> data = [0xF3,mode];
    _write(setChar!, data);
  }
  writeSetString(String value) async {
    if (setChar != null) {
      setLoraMode(2);
      await Future.delayed(const Duration(milliseconds: 150));
      _write(setChar!, string2Int(value));
      await Future.delayed(const Duration(milliseconds: 150));
      setLoraMode(1);
    }
  }

  writeLoraString(String value) {
    if (loarChar != null) {
      _write(loarChar!, string2Int(value));
    }
  }

  _write(BluetoothCharacteristic c, List<int> value) {
    if (c.properties.write) {
      c.write(value);
    }
  }

  listenGps(Function message) {
    if (gpsChar != null) {
      _setNotifyValue(gpsChar!, message);
    }
  }

  listenLoar(Function message) {
    if (loarChar != null) {
      _setNotifyValue(loarChar!, message);
    }
  }

  _setNotifyValue(BluetoothCharacteristic c, Function message) async {
    c.onValueReceived.listen((event) {
      message(String.fromCharCodes(event));
    });
    await c.setNotifyValue(true);
    if (c.properties.read) {
      await c.read();
    }
  }

  List<int> string2Int(String text) {
    return text.split('').map((char) => char.codeUnitAt(0)).toList();
  }
}

class ConnectSuccess {
  success() {}

  fail() {}
}
