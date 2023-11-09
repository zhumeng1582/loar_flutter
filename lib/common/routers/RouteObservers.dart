import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/proto/index.dart';
import 'package:loar_flutter/page/login/login_page.dart';
import 'package:loar_flutter/page/login/sign_up_page.dart';
import 'package:loar_flutter/page/main_page.dart';
import 'package:loar_flutter/page/map/offline_map_page.dart';
import 'package:loar_flutter/page/me/QR_generate_page.dart';
import 'package:loar_flutter/page/me/scan_qr_page.dart';
import 'package:loar_flutter/page/me/user_info_page.dart';
import 'package:loar_flutter/page/room/chat_detail_page.dart';

import '../../page/blue/find_device_page.dart';
import '../../page/contacts/contacts_select_page.dart';
import '../../page/home/bean/ConversationBean.dart';
import '../../page/login/avatar_select_page.dart';
import '../../page/room/chat_page.dart';
import '../proto/qr_code_data.dart';
import 'RouteNames.dart';

class RouteObservers {
  RouteObservers._();

  static PageRoute? didPush(String entryPoint, RouteSettings settings) {
    if (settings.name == "/") {
      return MaterialPageRoute(
          settings: settings, builder: (_) => const LoginPage());
    } else if (settings.name == RouteNames.main) {
      return MaterialPageRoute(
          settings: settings, builder: (_) => const MainPage());
    } else if (settings.name == RouteNames.signUp) {
      return MaterialPageRoute(
          settings: settings, builder: (_) => const SignUpPage());
    } else if (settings.name == RouteNames.qrGenerate) {
      var qrCodeData = settings.arguments as QrCodeData;
      return MaterialPageRoute(
          settings: settings,
          builder: (_) => QRGeneratePage(qrCodeData: qrCodeData));
    } else if (settings.name == RouteNames.qrScan) {
      return MaterialPageRoute(
          settings: settings, builder: (_) => ScanQRPage());
    } else if (settings.name == RouteNames.blueSearchList) {
      return MaterialPageRoute(
          settings: settings, builder: (_) => const FindDevicesScreen());
    } else if (settings.name == RouteNames.roomPage) {
      var conversation = settings.arguments as ConversationBean;
      return MaterialPageRoute(
          settings: settings,
          builder: (_) => ChatPage(
                conversationBean: conversation,
              ));
    } else if (settings.name == RouteNames.roomDetail) {
      var conversation = settings.arguments as ConversationBean;
      return MaterialPageRoute(
          settings: settings,
          builder: (_) => ChatDetailPage(conversationBean: conversation));
    } else if (settings.name == RouteNames.selectContact) {
      var userList = settings.arguments as List<EMUserInfo>;
      return MaterialPageRoute(
          settings: settings,
          builder: (_) => ContactsSelectPage(userList: userList));
    } else if (settings.name == RouteNames.selectAvatar) {
      return MaterialPageRoute(
          settings: settings, builder: (_) => const AvatarSelectPage());
    } else if (settings.name == RouteNames.offlineMap) {
      return MaterialPageRoute(
          settings: settings, builder: (_) => const OfflineMapPage());
    } else if (settings.name == RouteNames.usesInfoPage) {
      var arguments = settings.arguments as Map;
      var userInfo = arguments["userInfo"] as EMUserInfo;
      var message = arguments["message"] as String?;
      return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              UserInfoPage(userInfo: userInfo, message: message ?? ""));
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
