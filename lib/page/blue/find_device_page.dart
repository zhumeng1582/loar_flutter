import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loar_flutter/common/im_data.dart';

import '../../common/blue_tooth.dart';
import '../../common/routers/RouteNames.dart';
import '../../widget/common.dart';
import 'widgets.dart';

final snackBarKeyB = GlobalKey<ScaffoldMessengerState>();
final findDevicesProvider =
    ChangeNotifierProvider<FindDevicesNotifier>((ref) => FindDevicesNotifier());

class FindDevicesNotifier extends ChangeNotifier {
  bool isScanning = false;
  List<ScanResult> scanResults = [];

  FindDevicesNotifier() {
    FlutterBluePlus.isScanning.listen((event) {
      isScanning = event;
      notifyListeners();
    });

    FlutterBluePlus.scanResults.listen((event) {
      var loarList = event
          .where((element) => isLoar(element.advertisementData.serviceUuids))
          .toList();
      if (loarList.isNotEmpty) {
        scanResults = loarList;
      } else {
        scanResults = event;
      }
      notifyListeners();
    });
  }

  bool isLoar(List<Guid> serviceUuids) {
    // for (var value in serviceUuids) {
    //   if (value.str.contains("00805F9B34FB")) {
    //     return true;
    //   }
    // }
    return true;
    // return false;
  }

  void scanDevice() {
    try {
      if (FlutterBluePlus.isScanningNow == false) {
        FlutterBluePlus.startScan(
            timeout: const Duration(seconds: 15),
            androidUsesFineLocation: false);
      }
    } catch (e) {
      final snackBar = snackBarFail(prettyException("Start Scan Error:", e));
      snackBarKeyB.currentState?.removeCurrentSnackBar();
      snackBarKeyB.currentState?.showSnackBar(snackBar);
    }
  }

  void stopScan() {
    try {
      FlutterBluePlus.stopScan();
    } catch (e) {
      final snackBar = snackBarFail(prettyException("Stop Scan Error:", e));
      snackBarKeyB.currentState?.removeCurrentSnackBar();
      snackBarKeyB.currentState?.showSnackBar(snackBar);
    }
  }
}

class FindDevicesScreen extends ConsumerStatefulWidget {
  const FindDevicesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<FindDevicesScreen> createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends ConsumerState<FindDevicesScreen> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: snackBarKeyB,
      child: Scaffold(
        appBar: getAppBar(context, "查找设备"),
        body: RefreshIndicator(
          onRefresh: () {
            ref.watch(findDevicesProvider).scanDevice();
            return Future.delayed(
                const Duration(milliseconds: 500)); // show refresh icon breifly
          },
          child: SingleChildScrollView(
            child: Column(
              children: getScanList(),
            ),
          ),
        ),
        floatingActionButton: getFloatingActionButton(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

extension _Action on _FindDevicesScreenState {
  goDeviceDetail(ScanResult value) {
    BlueToothConnect.instance.connect(
        value,
        () => {
              ref.read(findDevicesProvider).stopScan(),
              Navigator.popAndPushNamed(context, RouteNames.main)
            },
        (e) => fail(e));
  }

  fail(Object error) {
    final snackBar = snackBarFail(prettyException("Connect Error:", error));
    snackBarKeyB.currentState?.removeCurrentSnackBar();
    snackBarKeyB.currentState?.showSnackBar(snackBar);
  }
}

extension _UI on _FindDevicesScreenState {
  Widget getFloatingActionButton() {
    if (ref.watch(findDevicesProvider).isScanning) {
      return FloatingActionButton(
        onPressed: () async {
          ref.read(findDevicesProvider).stopScan();
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.stop),
      );
    } else {
      return FloatingActionButton(
          child: const Text("扫描"),
          onPressed: () {
            ref.read(findDevicesProvider).scanDevice();
          });
    }
  }

  List<Widget> getScanList() {
    List<Widget> scanList = [];
    for (var value in ref.watch(findDevicesProvider).scanResults) {
      Widget device = ScanResultTile(
        result: value,
        onTap: () => goDeviceDetail(value),
      );
      scanList.add(device);
    }
    return scanList;
  }
}
