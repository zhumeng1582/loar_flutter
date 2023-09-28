import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:loar_flutter/page/login/login_page.dart';
import 'package:loar_flutter/page/main_page.dart';

import 'common/routers/RouteObservers.dart';

void main() async{
  runApp(const ProviderScope(child: MyApp()));
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
          onGenerateRoute: (RouteSettings settings) =>
              RouteObservers.didPush(settings),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          title: 'loar',
          home: const LoginPage(),
        );
      },
    );
  }
}
