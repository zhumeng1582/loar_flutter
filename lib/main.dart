import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:permission_handler/permission_handler.dart';

import 'common/routers/RouteObservers.dart';
import 'dart:io' show InternetAddress, Platform, SocketException;

import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFMapSDK, BMF_COORD_TYPE;

var appKey = "1106231108210776#demo";
var isConnectionSuccessful = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initMap();
  await initIm();
  tryConnection();
  if (Platform.isAndroid) {
    [
      Permission.location,
      Permission.storage,
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan
    ].request().then((status) {
      runApp(ProviderScope(child: MyApp(entryPoint: "")));
    });
  } else {
    runApp(ProviderScope(child: MyApp(entryPoint: "")));
  }
}

tryConnection() {
  Timer.periodic(const Duration(seconds: 2), (timer) async {
    try {
      final response = await InternetAddress.lookup('baidu.com');
      isConnectionSuccessful = response.isNotEmpty;
      debugPrint("---------->$isConnectionSuccessful");
    } on SocketException catch (e) {
      isConnectionSuccessful = false;
      debugPrint("---------->$isConnectionSuccessful");
    }
  });
}

Future<void> initIm() async {
  EMOptions options =
      EMOptions(appKey: appKey, autoLogin: false, debugModel: true);
  await EMClient.getInstance.init(options);
  await EMClient.getInstance.startCallback();
}

class MyApp extends StatelessWidget {
  MyApp({Key? key, required this.entryPoint}) : super(key: key) {}
  final String entryPoint;

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
              RouteObservers.didPush(entryPoint, settings),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          title: 'loar',
          // home: EasyLoading.init()(context, const LoginPage()),
          builder: (context, child) {
            child = EasyLoading.init()(context, child); // EasyLoading 初始化
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child,
            );
          },
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
