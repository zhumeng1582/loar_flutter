import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loar_flutter/common/colors.dart';

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
          .where((element) => element.advertisementData.connectable)
          .toList();

      if (loarList.isNotEmpty) {
        scanResults = loarList;
      } else {
        scanResults = event;
      }
      if (BlueToothConnect.instance.isConnect()) {
        scanResults.insert(0, BlueToothConnect.instance.device!);
      }

      notifyListeners();
    });
  }

  failMessage(Object error) {
    final snackBar = snackBarFail(prettyException("Connect Error:", error));
    snackBarKeyB.currentState?.removeCurrentSnackBar();
    snackBarKeyB.currentState?.showSnackBar(snackBar);
  }

  goDeviceDetail(ScanResult value) async {
    if (value.device.isConnected) {
      await BlueToothConnect.instance.disconnect();
      notifyListeners();
    } else {
      BlueToothConnect.instance.connect(
          value,
          () => {
                stopScan(),
              },
          (e) => failMessage(e));
    }
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
        appBar: getAppBar(context, "连接设备"),
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

extension _Action on _FindDevicesScreenState {}

extension _UI on _FindDevicesScreenState {
  Widget getFloatingActionButton() {
    if (ref.watch(findDevicesProvider).isScanning) {
      return FloatingActionButton(
          backgroundColor: AppColors.commonPrimary,
          child: Text(
            "停止",
            style: TextStyle(color: AppColors.white),
          ),
          onPressed: () {
            ref.read(findDevicesProvider).stopScan();
          });
    } else {
      return FloatingActionButton(
          backgroundColor: AppColors.commonPrimary,
          child: Text(
            "扫描",
            style: TextStyle(color: AppColors.white),
          ),
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
        onTap: () => ref.read(findDevicesProvider).goDeviceDetail(value),
      );
      scanList.add(device);
    }
    return scanList;
  }
}
