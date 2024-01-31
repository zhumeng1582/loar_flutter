import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:loar_flutter/common/proto/LoarProto.pb.dart';

class BlueToothConnect {
  BlueToothConnect._();

  int start = 36;
  int end1 = 13;
  int end2 = 10;

  final String _SET_SERVICE_UUID = "00F1";
  final String _SET_CHAR_UUID = "AE01";

  final String _LORA_SERVICE_UUID = "00F2";
  final String _LORA_CHAR_UUID = "AE02";

  final String _GPS_SERVICE_UUID = "00F3";
  final String _GPS_CHAR_UUID = "AE03";
  static int splitLength = 20;
  static bool isDeviceIdle = false;

  static BlueToothConnect get instance => _getInstance();
  static BlueToothConnect? _instance;
  ScanResult? device;
  BluetoothCharacteristic? gpsChar;
  StreamSubscription? gpsSubscription;
  BluetoothCharacteristic? loarChar;
  StreamSubscription? loarSubscription;

  BluetoothCharacteristic? setChar;
  StreamSubscription? setSubscription;

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
    while (true) {
      if (!isConnect() || messageQueue.isEmpty || loarChar == null) {
        await Future.delayed(const Duration(milliseconds: 1500));
        continue;
      }

      //请求设备是否空闲
      isDeviceIdle = false;
      await _write(setChar!, [0xF5]);
      await Future.delayed(const Duration(milliseconds: 250));

      //第一次没取到在等250ms
      if (!isDeviceIdle) {
        await Future.delayed(const Duration(milliseconds: 250));
      }

      if (!isDeviceIdle) {
        continue;
      }

      var message = messageQueue[0];
      var success = await sendLoarMessage(message);
      if (success) {
        await Future.delayed(const Duration(milliseconds: 1500));
        messageQueue.remove(message);
      }
    }
  }

  Future<bool> sendLoarMessage(LoarMessage message) async {
    var sendMessage = [start, ...message.writeToBuffer(), end1, end2];
    debugPrint(
        "------------>LoraMessage send length ${sendMessage.length},:${sendMessage.toString()}");
    for (int j = 0; j < sendMessage.length;) {
      //发送过程中断开连接
      if (!isConnect()) {
        return false;
      }
      int end = min(j + splitLength, sendMessage.length);
      var sendData = sendMessage.sublist(j, end);
      await _write(loarChar!, sendData).then((value) async {
        j += splitLength; //发送成功之后发送下一条
      }).catchError((error) async {
        //发送失败延时1ms之后重新发送
        await Future.delayed(const Duration(milliseconds: 1));
      });
    }
    //发送过程中断开连接
    if (!isConnect()) {
      return false;
    }

    await _write(setChar!, [0xF6]);
    return true;
  }

  writeLoraMessage(LoarMessage value, {bool isBroadcast = false}) {
    messageQueue.add(value);
  }

  _write(BluetoothCharacteristic c, List<int> value) async {
    if (c.properties.write) {
      await c.write(value);
    }
  }

  _listenGps(Function message) async {
    if (gpsChar != null) {
      gpsSubscription?.cancel();
      gpsSubscription = await _setNotifyValue(gpsChar!, message);
    }
  }

  _listenLoar(Function message) async {
    if (loarChar != null) {
      loarSubscription?.cancel();
      loarSubscription = await _setNotifyValue(
          loarChar!, (text) => {receiveData(text, message)});
    }
  }

  List<int> receive = [];

  receiveData(List<int> data, Function message) {
    debugPrint("------------>LoraMessage receive:$data");
    if (data[0] == start) {
      receive.clear();
    }
    receive.addAll(data);

    if (data[data.length - 2] == end1 && data[data.length - 1] == end2) {
      message(receive.sublist(1, data.length - 2));
      receive.clear();
    }
  }

  setMessage(List<int> message) {
    if (message.length == 4 && message[0] == 0xFD) {
      _version = message[2];
      // Loading.toast("固件版本：${message[2]}");
    }
    if (message.length == 2 && message[0] == 0xF5) {
      debugPrint("------->setMessage $message");
      isDeviceIdle = message[1] == 0x00;
    }
  }

  _listenSet(Function message) async {
    if (setChar != null) {
      setSubscription?.cancel();
      setSubscription = await _setNotifyValue(setChar!, message);
    }
  }

  Future<StreamSubscription> _setNotifyValue(
      BluetoothCharacteristic c, Function message) async {
    var subscription = c.onValueReceived.listen((event) {
      debugPrint("------------>LoraMessage onValueReceived:$event");
      message(event);
    });
    await c.setNotifyValue(true);
    if (c.properties.read) {
      await c.read();
    }
    return subscription;
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
