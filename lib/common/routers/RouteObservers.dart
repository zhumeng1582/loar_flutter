import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loar_flutter/page/login/sign_up_page.dart';
import 'package:loar_flutter/page/main_page.dart';
import 'package:loar_flutter/page/me/QR_generate_page.dart';
import 'package:loar_flutter/page/me/scan_qr_page.dart';

import '../../page/blue/find_device_page.dart';
import '../../page/home/room_list.dart';
import '../../page/room/room_page.dart';
import 'RouteNames.dart';

class RouteObservers {
  RouteObservers._();

  static PageRoute? didPush(RouteSettings settings) {
    if (settings.name == RouteNames.roomPage) {
      var roomItem = settings.arguments as RoomItem;
      return MaterialPageRoute(
          settings: settings, builder: (_) => RoomPage(roomItem: roomItem));
    } else if (settings.name == RouteNames.main) {
      return MaterialPageRoute(
          settings: settings, builder: (_) => const MainPage());
    } else if (settings.name == RouteNames.signUp) {
      return MaterialPageRoute(
          settings: settings, builder: (_) => const SignUpPage());
    } else if (settings.name == RouteNames.qrGenerate) {
      var qrCode = settings.arguments as String;
      return MaterialPageRoute(
          settings: settings, builder: (_) => QRGeneratePage(qrCode: qrCode));
    } else if (settings.name == RouteNames.qrScan) {
      return MaterialPageRoute(
          settings: settings, builder: (_) => ScanQRPage());
    } else if (settings.name == RouteNames.blueSearchList) {
      return MaterialPageRoute(
          settings: settings, builder: (_) => const FindDevicesScreen());
    } else if (settings.name == RouteNames.deviceScreen) {
      // BluetoothDevice device = settings.arguments as BluetoothDevice;
      // return MaterialPageRoute(
      //     settings: settings,
      //     builder: (_) => DeviceScreen(
      //           device: device,
      //         ));
    }
  }
}
