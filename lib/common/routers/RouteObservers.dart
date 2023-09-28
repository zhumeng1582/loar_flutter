import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    }
  }
}
