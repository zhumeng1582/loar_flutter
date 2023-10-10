import 'package:flutter/material.dart';
import 'package:loar_flutter/common/proto/index.dart';
import 'package:loar_flutter/page/login/sign_up_page.dart';
import 'package:loar_flutter/page/main_page.dart';
import 'package:loar_flutter/page/me/QR_generate_page.dart';
import 'package:loar_flutter/page/me/scan_qr_page.dart';
import 'package:loar_flutter/page/room/room_detail_page.dart';

import '../../page/blue/find_device_page.dart';
import '../../page/contacts/contacts_select_page.dart';
import '../../page/login/avatar_select_page.dart';
import '../../page/room/room_page.dart';
import 'RouteNames.dart';

class RouteObservers {
  RouteObservers._();

  static PageRoute? didPush(RouteSettings settings) {
    if (settings.name == RouteNames.main) {
      return MaterialPageRoute(
          settings: settings, builder: (_) => const MainPage());
    } else if (settings.name == RouteNames.signUp) {
      return MaterialPageRoute(
          settings: settings, builder: (_) => const SignUpPage());
    } else if (settings.name == RouteNames.qrGenerate) {
      var qrCodeData = settings.arguments as QrCodeData;
      return MaterialPageRoute(
          settings: settings, builder: (_) => QRGeneratePage(qrCodeData: qrCodeData));
    } else if (settings.name == RouteNames.qrScan) {
      return MaterialPageRoute(
          settings: settings, builder: (_) => ScanQRPage());
    } else if (settings.name == RouteNames.blueSearchList) {
      return MaterialPageRoute(
          settings: settings, builder: (_) => const FindDevicesScreen());
    } else if (settings.name == RouteNames.roomPage) {
      var roomId = settings.arguments as String;
      return MaterialPageRoute(
          settings: settings, builder: (_) => RoomPage(roomId: roomId));
    } else if (settings.name == RouteNames.roomDetail) {
      var roomId = settings.arguments as String;
      return MaterialPageRoute(
          settings: settings, builder: (_) => RoomDetailPage(roomId: roomId));
    } else if (settings.name == RouteNames.selectContact) {
      var roomId = settings.arguments as String;
      return MaterialPageRoute(
          settings: settings, builder: (_) => ContactsSelectPage(roomId:roomId));
    }  else if (settings.name == RouteNames.selectAvatar) {
      return MaterialPageRoute(
          settings: settings, builder: (_) => const AvatarSelectPage());
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
