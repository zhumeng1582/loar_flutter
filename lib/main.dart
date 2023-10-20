import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_bmflocation/flutter_bmflocation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/page/login/login_page.dart';
import 'package:permission_handler/permission_handler.dart';

import 'common/routers/RouteObservers.dart';
import 'dart:io' show Platform;

import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFMapSDK, BMF_COORD_TYPE;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initMap();
  if (Platform.isAndroid) {
    [
      Permission.location,
      Permission.storage,
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan
    ].request().then((status) {
      runApp(const ProviderScope(child: MyApp()));
    });
  } else {
    runApp(const ProviderScope(child: MyApp()));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(750, 1624),
      // 设计稿中设备的尺寸(单位随意,建议dp,但在使用过程中必须保持一致)
      splitScreenMode: false,
      // 支持分屏尺寸
      minTextAdapt: false,
      // 是否根据宽度/高度中的最小值适配文字
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return MaterialApp(
          // localizationsDelegates: [
          //   GlobalMaterialLocalizations.delegate,
          //   GlobalWidgetsLocalizations.delegate,
          // ],
          // supportedLocales: [
          //   const Locale('zh', 'CH'),
          // ],
          onGenerateRoute: (RouteSettings settings) =>
              RouteObservers.didPush(settings),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          title: 'loar',
          home: EasyLoading.init()(context, const LoginPage()),
        );
      },
    );
  }
}

void initMap() async {
  BMFMapSDK.setAgreePrivacy(true);

  if (Platform.isAndroid) {
    await BMFAndroidVersion.initAndroidVersion();
    // Android 目前不支持接口设置Apikey,
    // 请在主工程的Manifest文件里设置，详细配置方法请参考官网(https://lbsyun.baidu.com/)demo
    BMFMapSDK.setCoordType(BMF_COORD_TYPE.BD09LL);
    Map? map = await BMFMapVersion.nativeMapVersion;
    print('获取原生地图版本号：$map');
  } else {
    BMFMapSDK.setApiKeyAndCoordType(
        'we6iOj29YBaaGjdxcrqMdXFSBXSeEG7g', BMF_COORD_TYPE.BD09LL);
  }
}
