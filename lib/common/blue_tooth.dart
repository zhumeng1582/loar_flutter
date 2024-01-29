import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:loar_flutter/common/proto/LoarProto.pb.dart';

class BlueToothConnect {
  BlueToothConnect._();

  final String _SET_SERVICE_UUID = "00F1";
  final String _SET_CHAR_UUID = "AE01";

  final String _LORA_SERVICE_UUID = "00F2";
  final String _LORA_CHAR_UUID = "AE02";

  final String _GPS_SERVICE_UUID = "00F3";
  final String _GPS_CHAR_UUID = "AE03";
  static int splitLength = 20;
  static bool isIdle = true;

  static BlueToothConnect get instance => _getInstance();
  static BlueToothConnect? _instance;
  ScanResult? device;
  BluetoothCharacteristic? gpsChar;
  BluetoothCharacteristic? loarChar;
  BluetoothCharacteristic? setChar;
  List<LoarMessage> messageQueue = [];

  Function? loarMessage;
  Function? gpsMessage;
  int? _version;

  String get version {
    if (_version == null) {
      return "";
    }

    return "固件版本：${_version! / 10}";
  }

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
    if (Platform.isAndroid == true) {
      var phySupport = await FlutterBluePlus.getPhySupport();
      if (phySupport.le2M) {
        splitLength = 128;
      } else {
        splitLength = 20;
      }
      debugPrint("--------->splitLength = $splitLength");
    } else {}

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
        await setCommunicationLength();
        success();
        BlueToothConnect.instance.sendLoraMessage();
      } else {
        fail();
      }
    });
  }

  setLoraMode(int mode) async {
    List<int> data = [0xF3, mode];
    await _write(setChar!, data);
  }

  setCommunicationLength() async {
    if (setChar != null) {
      List<int> data = splitLength == 20 ? [0xFD, 0x00] : [0xFD, 0x01];
      await _write(setChar!, data);
    }
  }

  sendLoraMessage() async {
    while (isConnect()) {
      if (messageQueue.isNotEmpty && loarChar != null) {
        var message = messageQueue[0];
        var sendMessage = message.writeToBuffer();
        debugPrint(
            "------------>LoraMessage send length ${sendMessage.length},:${sendMessage.toString()}");

        //请求设备是否空闲
        await _write(setChar!, [0xF5]);
        await Future.delayed(const Duration(milliseconds: 250));

        if (!isIdle) {
          await Future.delayed(const Duration(milliseconds: 400));
          continue;
        }

        for (int j = 0; j < sendMessage.length;) {
          int end = min(j + splitLength, sendMessage.length);
          var sendData = sendMessage.sublist(j, end);
          await _write(loarChar!, sendData).then((value) async {
            j += splitLength; //发送成功之后发送下一条
          }).catchError((error) async {
            //发送失败延时1ms之后重新发送
            await Future.delayed(const Duration(milliseconds: 1));
          });
        }

        await _write(setChar!, [0xF6]);
        messageQueue.remove(message);
      }
      await Future.delayed(const Duration(milliseconds: 1500));
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
    debugPrint("------------>LoraMessage receive:$data");
    message(data);
  }

  setMessage(List<int> message) {
    if (message.length == 4 && message[0] == 0xFD) {
      _version = message[2];
      // Loading.toast("固件版本：${message[2]}");
    }
    if (message.length == 2 && message[0] == 0xF5) {
      debugPrint("------->setMessage $message");
      isIdle = message[1] == 0x00;
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
