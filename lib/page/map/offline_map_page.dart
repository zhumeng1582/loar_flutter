import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/common/ex/ex_num.dart';
import 'package:loar_flutter/common/loading.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';

final offlineMapProvider =
    ChangeNotifierProvider<OfflineMapNotifier>((ref) => OfflineMapNotifier());

class OfflineMapNotifier extends ChangeNotifier {
  List<BMFOfflineCityRecord> cityList = [];
  List<BMFUpdateElement> updateList = [];

  getOfflineCityList(OfflineController offlineController) async {
    var list = await offlineController.getOfflineCityList();

    if (list != null) {
      // for (var element in list) {
      //   if (element.childCities != null && element.childCities!.isNotEmpty) {
      //     cityList.addAll(element.childCities!);
      //   } else {
      //     cityList.add(element);
      //   }
      // }
      cityList = list;
      notifyListeners();
    }
  }

  getAllUpdateInfo(OfflineController offlineController) async {
    List<BMFUpdateElement>? update = await offlineController.getAllUpdateInfo();
    if (update != null) {
      updateList = update;
      notifyListeners();
    }
  }

  double getProgress(int cityId) {
    if (updateList.any((element) => element.cityID == cityId)) {
      var ratio =
          updateList.firstWhere((element) => element.cityID == cityId).ratio ??
              0;
      return ratio.toDouble() / 100;
    }
    return 0;
  }

  void setUpdateInfo(
      OfflineController offlineController, double progress, int cityID) async {
    if (progress == 1) {
      Loading.toast("已下载，请不要重复点击");
      return;
    }
    if (progress > 0.0) {
      Loading.toast("下载中，请不要重复点击");
      return;
    }

    Loading.show();
    var success = await offlineController.startOfflineMap(cityID);
    Loading.dismiss();
    if (!success) {
      Loading.toast("请求下载失败,请稍后再试");
    } else {
      //设置为1，防止用户以为没有下载
      if (updateList.any((element) => element.cityID == cityID)) {
        updateList.firstWhere((element) => element.cityID == cityID).ratio = 1;
        notifyListeners();
      }
    }
  }
}

class OfflineMapPage extends ConsumerStatefulWidget {
  const OfflineMapPage({super.key});

  @override
  ConsumerState<OfflineMapPage> createState() => _OfflineMapPageState();
}

class _OfflineMapPageState extends ConsumerState<OfflineMapPage> {
  // 创建离线地图管理类
  final OfflineController _offlineController = OfflineController();
  late Timer timer;

  @override
  void initState() {
    super.initState();
    // 离线地图管理类初始化
    _offlineController.init();
    // 离线地图管理类注册回调
    _offlineController.onGetOfflineMapStateBack(
        callback: _onGetOfflineMapStateBack);
    ref.read(offlineMapProvider).getOfflineCityList(_offlineController);

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      ref.read(offlineMapProvider).getAllUpdateInfo(_offlineController);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("离线地图"),
      ),
      body: SafeArea(
        child: _buildCityList(ref.watch(offlineMapProvider).cityList)
            .paddingHorizontal(30.w),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}

extension _Action on _OfflineMapPageState {
  // 下载回调
  void _onGetOfflineMapStateBack(int? state, int? cityID) {
    print("------->下载 state= ${state},cityId =  ${cityID}");

    switch (state) {
      case OfflineController.TYPE_DOWNLOAD_UPDATE:
        // _setUpdateInfo(cityID!);
        // 处理下载进度更新提示
        break;

      case OfflineController.TYPE_NEW_OFFLINE:
        // 有新离线地图安装
        break;

      case OfflineController.TYPE_VER_UPDATE:
        _offlineController.updateOfflineMap(cityID!);
        break;

      default:
        break;
    }
  }
}

extension _UI on _OfflineMapPageState {
  Widget _buildCityList(List<BMFOfflineCityRecord> data) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              if (data[index].childCities != null &&
                  data[index].childCities!.isNotEmpty) {
                return ExpansionTile(
                  title: Text(data[index].cityName ?? ""),
                  children: getCityCellList(data[index]),
                );
              } else {
                return cityCell(data[index]);
              }
            },
          ),
        )
      ],
    );
  }

  List<Widget> getCityCellList(BMFOfflineCityRecord data) {
    return data.childCities!.map((e) => cityCell(e)).toList();
  }

  Column cityCell(BMFOfflineCityRecord data) {
    var progress = ref.read(offlineMapProvider).getProgress(data.cityID!);
    return Column(children: [
      Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data.cityName ?? ""),
              Text("${data.dataSize?.getMB}M")
            ],
          ).expanded(),
          Icon(
            Icons.download,
            color: progress == 0.0 ? Colors.black : Colors.grey,
            size: 50.w,
          ).padding(all: 10.w).onTap(() => ref
              .read(offlineMapProvider)
              .setUpdateInfo(_offlineController, progress, data.cityID!)),
        ],
      ),
      LinearProgressIndicator(
        value: progress,
      ),
    ]);
  }
}
