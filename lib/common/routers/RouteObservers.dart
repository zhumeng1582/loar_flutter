import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/page/home/notify_page.dart';
import 'package:loar_flutter/page/home/search_page.dart';
import 'package:loar_flutter/page/login/login_page.dart';
import 'package:loar_flutter/page/login/sign_up_page.dart';
import 'package:loar_flutter/page/main_page.dart';
import 'package:loar_flutter/page/map/baidu_map_page.dart';
import 'package:loar_flutter/page/map/offline_map_page.dart';
import 'package:loar_flutter/page/me/QR_generate_page.dart';
import 'package:loar_flutter/page/me/scan_qr_page.dart';
import 'package:loar_flutter/page/me/user_info_page.dart';
import 'package:loar_flutter/page/room/chat_detail_page.dart';

import '../../page/blue/find_device_page.dart';
import '../../page/contacts/contacts_select_page.dart';
import '../../page/home/bean/conversation_bean.dart';
import '../../page/home/bean/notify_bean.dart';
import '../../page/login/avatar_select_page.dart';
import '../../page/me/me_detail_page.dart';
import '../../page/room/chat_page.dart';
import '../../page/statellite_map.dart';
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
      var conversation = settings.arguments as EMConversation;
      return MaterialPageRoute(
          settings: settings,
          builder: (_) => ChatPage(
                conversation: conversation,
              ));
    } else if (settings.name == RouteNames.roomDetail) {
      var conversation = settings.arguments as EMConversation;
      return MaterialPageRoute(
          settings: settings,
          builder: (_) => ChatDetailPage(conversation: conversation));
    } else if (settings.name == RouteNames.selectContact) {
      var userList = settings.arguments as List<String>;
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
      var userInfo = settings.arguments as EMUserInfo;
      return MaterialPageRoute(
          settings: settings, builder: (_) => UserInfoPage(userInfo: userInfo));
    } else if (settings.name == RouteNames.notifyPage) {
      var data = settings.arguments as NotifyBean;
      return MaterialPageRoute(
          settings: settings, builder: (_) => NotifyPage(data: data));
    } else if (settings.name == RouteNames.searchPage) {
      return MaterialPageRoute(
          settings: settings, builder: (_) => const SearchPage());
    } else if (settings.name == RouteNames.satelliteMapPage) {
      return MaterialPageRoute(
          settings: settings, builder: (_) => const SatelliteMapPage());
    } else if (settings.name == RouteNames.baiduMapPage) {
      return MaterialPageRoute(
          settings: settings, builder: (_) => const BaiduMapPage());
    }  else if (settings.name == RouteNames.meDetailPage) {
      return MaterialPageRoute(
          settings: settings, builder: (_) => const MeDetailPage());
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
