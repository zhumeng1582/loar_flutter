import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:loar_flutter/common/proto/LoarProto.pb.dart';
import 'lora_packet.dart';

class BlueToothConnect {
  BlueToothConnect._();

  final String _SET_SERVICE_UUID = "00F1";
  final String _SET_CHAR_UUID = "AE01";

  final String _LORA_SERVICE_UUID = "00F2";
  final String _LORA_CHAR_UUID = "AE02";

  final String _GPS_SERVICE_UUID = "00F3";
  final String _GPS_CHAR_UUID = "AE03";
  static int splitLength = 20;

  static BlueToothConnect get instance => _getInstance();
  static BlueToothConnect? _instance;
  ScanResult? device;
  BluetoothCharacteristic? gpsChar;
  BluetoothCharacteristic? loarChar;
  BluetoothCharacteristic? setChar;
  List<LoarMessage> messageQueue = [];
  Map<String, List<int>> loarData = {};

  Function? loarMessage;
  Function? gpsMessage;

  setListen(Function message) {
    loarMessage = message;
  }

  setGPSMessage(Function message) {
    gpsMessage = message;
  }

  static BlueToothConnect _getInstance() {
    _instance ??= BlueToothConnect._();
    return _instance!;
  }

  bool isConnect() {
    return BlueToothConnect.instance.device?.device.isConnected == true;
  }

  disconnect() async {
    await BlueToothConnect.instance.device?.device.disconnect();
  }

  bool isConnectDevice(ScanResult value) {
    return BlueToothConnect.instance.device?.device.remoteId ==
        value.device.remoteId;
  }

  connect(ScanResult value, Function success, Function fail) async {
    await value.device
        .connect(timeout: const Duration(seconds: 35))
        .catchError((e) {
      fail(e);
    }).then((v) {
      device = value;
    });

    var servicesList = await device?.device.discoverServices();
    var service = servicesList?.firstWhere((element) =>
        element.serviceUuid.toString().toUpperCase() == _LORA_SERVICE_UUID);
    loarChar = service?.characteristics.firstWhere((element) =>
        element.characteristicUuid.toString().toUpperCase() == _LORA_CHAR_UUID);

    var serviceGps = device?.device.servicesList.firstWhere((element) =>
        element.serviceUuid.toString().toUpperCase() == _GPS_SERVICE_UUID);
    gpsChar = serviceGps?.characteristics.firstWhere((element) =>
        element.characteristicUuid.toString().toUpperCase() == _GPS_CHAR_UUID);

    var serviceSet = device?.device.servicesList.firstWhere((element) =>
        element.serviceUuid.toString().toUpperCase() == _SET_SERVICE_UUID);
    setChar = serviceSet?.characteristics.firstWhere((element) =>
        element.characteristicUuid.toString().toUpperCase() == _SET_CHAR_UUID);

    BlueToothConnect.instance._listenLoar(loarMessage!);
    BlueToothConnect.instance._listenGps(gpsMessage!);
    BlueToothConnect.instance._listenSet(setMessage);

    device?.device.connectionState
        .listen((BluetoothConnectionState state) async {
      debugPrint("connectionState.listen----->${state.name}");
      if (state == BluetoothConnectionState.connected) {
        await _enableCommunication().then((value) {
          success();
        }).catchError((error) {
          fail(error);
        });
      } else {
        fail();
      }
    });
  }

  setLoraMode(int mode) async {
    List<int> data = [0xF3, mode];
    await _write(setChar!, data);
  }

  _enableCommunication() async {
    if (setChar != null) {
      await setLoraMode(2);
      await Future.delayed(const Duration(milliseconds: 150));
      List<int> value = [0xC2, 0x00, 0x06, 0x12, 0x34, 0x01, 0x62, 0x00, 0x18];
      await _write(loarChar!, value);
      await Future.delayed(const Duration(milliseconds: 150));
      await setLoraMode(0);
    }
  }

  sendLoraMessage() async {
    while (true) {
      if (messageQueue.isNotEmpty) {
        if (loarChar != null) {
          var sendData = messageQueue[0];
          var data = Packet.splitData(sendData.writeToBuffer(), splitLength);
          bool sendSuccess = true;
          for (int i = 0; i < data.length;) {
            await _write(loarChar!, data[i]).then((value) {
              i++; //发送成功之后发送下一条
              sendSuccess = true;
            }).catchError((error) {
              //发送失败之后重试
              sendSuccess = false;
            });
            await Future.delayed(
                Duration(milliseconds: sendSuccess ? 400 : 10));
          }
          messageQueue.remove(sendData);
        }
      } else {
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
  }

  writeLoraMessage(LoarMessage value, {bool isBroadcast = false}) {
    messageQueue.add(value);
  }

  _write(BluetoothCharacteristic c, List<int> value) async {
    if (c.properties.write) {
      await c.write(value);
    }
  }

  _listenGps(Function message) {
    if (gpsChar != null) {
      _setNotifyValue(gpsChar!, message);
    }
  }

  _listenLoar(Function message) {
    if (loarChar != null) {
      _setNotifyValue(loarChar!, (text) => {receiveData(text, message)});
    }
  }

  receiveData(List<int> data, Function message) {
    Packet packet = Packet.fromIntList(data);
    String key = packet.getMessageId();
    var temp = loarData[key] ?? [];
    temp.addAll(packet.data);
    loarData[key] = temp;
    debugPrint(
        '_read------->length data= ${data.length},temp = ${temp.length},size = ${packet.length}');

    if (temp.length == packet.length) {
      message(temp);
      loarData.remove(key);
    }
  }

  setMessage(List<int> message) {
    if (message.length == 4 && message[0] == 0xFD) {
      //0x01 最大发送500，保证数据完整性控制在200；0x00 最大发送20
      if (message[1] == 0x01) {
        splitLength = 200;
      }
    }
  }

  _listenSet(Function message) {
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
