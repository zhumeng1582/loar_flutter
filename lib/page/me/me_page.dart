import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';

import '../../common/image.dart';
import '../../common/local_info_cache.dart';
import '../../common/routers/RouteNames.dart';

final meProvider = ChangeNotifierProvider<MeNotifier>((ref) => MeNotifier());

class MeNotifier extends ChangeNotifier {}

class MePage extends ConsumerStatefulWidget {
  const MePage({super.key});

  @override
  ConsumerState<MePage> createState() => _MePageState();
}

class _MePageState extends ConsumerState<MePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _topItem(),
            _getMeItem("账号", LocalInfoCache.instance.userInfo?.userInfo.account,
                false),
            _getMeItem("二维码名片", "", true).onTap(() {
              Navigator.pushNamed(
                context,
                RouteNames.qrGenerate,
                arguments: LocalInfoCache.instance.userInfo?.userInfo.account
              );
            }),
            _getMeItem("添加好友", "", true).onTap(() {
              Navigator.pushNamed(
                  context,
                  RouteNames.qrScan
              );
            }),
          ],
        ).paddingHorizontal(30.w),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

extension _Action on _MePageState {}

extension _UI on _MePageState {
  Widget _topItem() {
    return Column(
      children: [
        ClipOval(
          child: ImageWidget(
            url: LocalInfoCache.instance.userInfo?.userInfo.icon ?? "",
            width: 50,
            height: 50,
            type: ImageWidgetType.network,
          ),
        ),
        Text(LocalInfoCache.instance.userInfo?.userInfo.name ?? ""),
        Text(
          LocalInfoCache.instance.userInfo?.userInfo.id ?? "",
          textAlign: TextAlign.right,
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }

  Widget _getMeItem(String title, String? value, bool isNewPage) {
    return Column(
      children: [
        Row(
          children: [
            Text(title),
            Expanded(child: Container()),
            Text(
              value ?? "",
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
            isNewPage
                ? Icon(
                    Icons.keyboard_arrow_right,
                    size: 43.w,
                  )
                : Container()
          ],
        ).paddingVertical(29.h),
        Divider(
          height: 0.1.h,
        ),
      ],
    );
  }
}
