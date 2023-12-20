import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loar_flutter/common/im_data.dart';
import 'package:loar_flutter/common/image.dart';
import 'package:loar_flutter/page/home/provider/network_provider.dart';
import 'package:loar_flutter/page/statellite_map.dart';

import '../common/blue_tooth.dart';
import '../common/colors.dart';
import '../common/util/coord_convert.dart';
import '../common/util/images.dart';
import '../widget/satellite_painter.dart';
import 'contacts/contacts_page.dart';
import 'forum/forum_page.dart';
import 'home/home_page.dart';
import 'home/provider/im_message_provider.dart';
import 'home/provider/location_provider.dart';
import 'location/location_page.dart';
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

      ref.read(locationMapProvider).location();
      ref.read(imProvider).addImListener();
      ref.read(satelliteNotifier).getLocation();
      ref.read(satelliteNotifier).init();
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
        unselectedItemColor: AppColors.title,
        type: BottomNavigationBarType.fixed,
        // 设置未被选中时的图标颜色
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageWidget.asset(AssetsImages.iconFenXin,
                width: 24, height: 24),
            activeIcon: ImageWidget.asset(AssetsImages.iconFenXinSel,
                width: 24, height: 24),
            label: '蜂信',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: ImageWidget.asset(AssetsImages.iconTongXun,
                width: 24, height: 24),
            activeIcon: ImageWidget.asset(AssetsImages.iconTongXunSel,
                width: 24, height: 24),
            label: '通讯录',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: ImageWidget.asset(AssetsImages.iconDingWei,
                width: 24, height: 24),
            activeIcon: ImageWidget.asset(AssetsImages.iconDingWeiSel,
                width: 24, height: 24),
            label: '定位',
            backgroundColor: Colors.white,
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.sos, size: 24.0),
          //   label: 'SOS',
          //   backgroundColor: Colors.white,
          // ),
          BottomNavigationBarItem(
            icon:
                ImageWidget.asset(AssetsImages.iconWode, width: 24, height: 24),
            activeIcon: ImageWidget.asset(AssetsImages.iconWodeSel,
                width: 24, height: 24),
            label: '我的',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: ImageWidget.asset(AssetsImages.iconSheQu,
                width: 24, height: 24),
            activeIcon: ImageWidget.asset(AssetsImages.iconSheQuSel,
                width: 24, height: 24),
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
    ref.read(networkProvider).cancel();
  }
}
