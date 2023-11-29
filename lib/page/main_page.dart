import 'package:flutter/material.dart';
import 'package:flutter_bmflocation/flutter_bmflocation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/im_data.dart';
import 'package:loar_flutter/page/home/provider/network_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../common/blue_tooth.dart';
import '../common/colors.dart';
import '../common/util/coord_convert.dart';
import 'contacts/contacts_page.dart';
import 'forum/forum_page.dart';
import 'home/home_page.dart';
import 'home/provider/im_message_provider.dart';
import 'home/provider/location_provider.dart';
import 'location/location_page.dart';
import 'map/baidu_map_page.dart';
import 'me/me_page.dart';

final mainProvider =
    ChangeNotifierProvider<MainNotifier>((ref) => MainNotifier());

class MainNotifier extends ChangeNotifier {
  final List tabPages = [
    const HomePage(),
    const ContactsPage(),
    const LocationPage(),
    // const SosPage(),
    const MePage(),
    const ForumPage(),
  ]; // 列举所有 Tab 控制切换将用到的页面
  int selectedIndex = 0;

  void setSelectIndex(int selectedIndex) {
    this.selectedIndex = selectedIndex;
    notifyListeners();
  }

  Widget getCurrentWidget() {
    return tabPages[selectedIndex];
  }

  getLocation() {
    BlueToothConnect.instance
        .listenGps((message) => gpsParser(String.fromCharCodes(message)));
  }

  String text = "";

  gpsParser(String value) {
    if (value.startsWith("\$")) {
      text = "";
    }
    text += value;
    if (value.contains("*") && text.contains("GNRMC")) {
      debugPrint("-------->value = " + value);
      var split = value.split(",");
      if (split.length < 5 || split[3].isEmpty || split[5].isEmpty) {
        return;
      }

      var latitude = BlueToothConnect.instance.convertGPRMCToDegrees(split[3]);
      var longitude = BlueToothConnect.instance.convertGPRMCToDegrees(split[5]);

      var bd09Coordinate =
          CoordConvert.gcj02tobd09(Coords(latitude, longitude));
      GlobeDataManager.instance
          .setLoarPosition(bd09Coordinate.latitude, bd09Coordinate.longitude);
    }
  }
}

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(networkProvider).initState();
      await EMClient.getInstance.startCallback();

      ref.read(locationMapProvider).location();
      ref.read(imProvider).addImListener();
      ref.read(mainProvider).getLocation();
      ref.read(imProvider).init();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ref.watch(mainProvider).getCurrentWidget(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.bottomBackground,
        selectedFontSize: 14.0,
        unselectedFontSize: 14.0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        enableFeedback: true,
        //点击会产生咔嗒声，长按会产生短暂的振动
        selectedItemColor: AppColors.commonPrimary,
        // 设置被选中时的图标颜色
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        // 设置未被选中时的图标颜色
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.wechat,
              size: 24.0,
            ),
            label: '蜂信',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_page, size: 24.0),
            label: '通讯录',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.place, size: 24.0),
            label: '定位',
            backgroundColor: Colors.white,
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.sos, size: 24.0),
          //   label: 'SOS',
          //   backgroundColor: Colors.white,
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 24.0),
            label: '我的',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.comment, size: 24.0),
            label: '社区',
            backgroundColor: Colors.white,
          ),
        ],

        // 设置当前（即被选中时）页面
        currentIndex: ref.watch(mainProvider).selectedIndex,

        // 当点击其中一个[items]被触发
        onTap: (int index) {
          ref.watch(mainProvider).setSelectIndex(index);
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    ref.read(imProvider).removeImListener();
  }
}
