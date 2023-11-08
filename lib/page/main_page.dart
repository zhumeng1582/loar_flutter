import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loar_flutter/page/sos/sos_page.dart';

import '../common/blue_tooth.dart';
import '../common/colors.dart';
import 'contacts/contacts_page.dart';
import 'home/home_page.dart';
import 'home/provider/im_message_provider.dart';
import 'map/baidu_map_page.dart';
import 'me/me_page.dart';

final mainProvider =
    ChangeNotifierProvider<MainNotifier>((ref) => MainNotifier());

class MainNotifier extends ChangeNotifier {
  final List tabPages = [
    const HomePage(),
    const ContactsPage(),
    BaiduMapPage(),
    const SosPage(),
    const MePage(),
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
      debugPrint("定位数据------->" + text);
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
    Future(() {
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
              Icons.message,
              size: 24.0,
            ),
            label: '聊天',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_page, size: 24.0),
            label: '通讯录',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map, size: 24.0),
            label: '地图',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sos, size: 24.0),
            label: 'SOS',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 24.0),
            label: '我的',
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
