import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:loar_flutter/common/proto/LoarProto.pb.dart';
import 'package:loar_flutter/common/proto/index.dart';

class BlueToothConnect {
  BlueToothConnect._();

  final String _SET_SERVICE_UUID = "00F1";
  final String _SET_CHAR_UUID = "AE01";

  final String _LORA_SERVICE_UUID = "00F2";
  final String _LORA_CHAR_UUID = "AE02";

  final String _GPS_SERVICE_UUID = "00F3";
  final String _GPS_CHAR_UUID = "AE03";

  static BlueToothConnect get instance => _getInstance();
  static BlueToothConnect? _instance;
  BluetoothDevice? _device;
  BluetoothCharacteristic? gpsChar;
  BluetoothCharacteristic? loarChar;
  BluetoothCharacteristic? setChar;

  static BlueToothConnect _getInstance() {
    _instance ??= BlueToothConnect._();
    return _instance!;
  }

  bool isConnect() {
    return BlueToothConnect.instance._device?.isConnected == true;
  }

  disconnect() async{
    await BlueToothConnect.instance._device?.disconnect();
  }

  connect(ScanResult value, Function success, Function fail) async {
    await value.device
        .connect(timeout: const Duration(seconds: 35))
        .catchError((e) {
      fail(e);
    }).then((v) {
      _device = value.device;
    });

    var servicesList = await _device?.discoverServices();
    var service = servicesList?.firstWhere((element) =>
        element.serviceUuid.toString().toUpperCase() == _LORA_SERVICE_UUID);
    loarChar = service?.characteristics.firstWhere((element) =>
        element.characteristicUuid.toString().toUpperCase() == _LORA_CHAR_UUID);

    var serviceGps = _device?.servicesList.firstWhere((element) =>
        element.serviceUuid.toString().toUpperCase() == _GPS_SERVICE_UUID);
    gpsChar = serviceGps?.characteristics.firstWhere((element) =>
        element.characteristicUuid.toString().toUpperCase() == _GPS_CHAR_UUID);

    var serviceSet = _device?.servicesList.firstWhere((element) =>
        element.serviceUuid.toString().toUpperCase() == _SET_SERVICE_UUID);
    setChar = serviceSet?.characteristics.firstWhere((element) =>
        element.characteristicUuid.toString().toUpperCase() == _SET_CHAR_UUID);

    _device?.connectionState.listen((BluetoothConnectionState state) {
      debugPrint("connectionState.listen----->"+state.name);
      if (state == BluetoothConnectionState.connected) {
        enableCommunication();
        success();
      }
    });
  }

  void setLedOnOff(bool on) {
    List<int> data = [0xF2, on ? 1 : 0];
    _write(setChar!, data);
  }

  void setLoraMode(int mode) {
    List<int> data = [0xF3, mode];
    _write(setChar!, data);
  }

  enableCommunication() async {
    if (setChar != null) {
      List<int> value = [0xC2, 0x00, 0x06, 0x12, 0x34, 0x01, 0x62, 0x00, 0x18];
      setLoraMode(2);
      await Future.delayed(const Duration(milliseconds: 150));
      _write(loarChar!, value);
      await Future.delayed(const Duration(milliseconds: 150));
      setLoraMode(0);
    }
  }

  writeLoraMessage(LoarMessage value) {
    if (loarChar != null) {
      _write(loarChar!, value.writeToBuffer());
    }
  }

  _writeLoraString(List<int> value) {
    if (loarChar != null) {
      _write(loarChar!, value);
    }
  }

  _write(BluetoothCharacteristic c, List<int> value) {
    if (c.properties.write) {
      debugPrint("_write------->${value}");

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

  listenSet(Function message) {
    if (setChar != null) {
      _setNotifyValue(setChar!, message);
    }
  }

  _setNotifyValue(BluetoothCharacteristic c, Function message) async {
    c.onValueReceived.listen((event) {
      message(event);
    });
    await c.setNotifyValue(true);
    if (c.properties.read) {
      await c.read();
    }
  }

  List<int> string2Int(String text) {
    return text.split('').map((char) => char.codeUnitAt(0)).toList();
  }

  double convertGPRMCToDegrees(String gprmc) {
    var degreePart = gprmc.substring(0, gprmc.length - 8);
    var minutesPart = gprmc.substring(gprmc.length - 8);

    var degrees = double.parse(degreePart);
    var minutes = double.parse(minutesPart);

    return degrees + (minutes / 60);
  }
}

class ConnectSuccess {
  success() {}

  fail() {}
}
