import 'dart:async';

import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/common/colors.dart';
import 'package:loar_flutter/common/ex/ex_num.dart';
import 'package:loar_flutter/common/ex/ex_widget.dart';
import 'package:loar_flutter/common/loading.dart';

import '../../widget/common.dart';
import 'model/city_model.dart';

final offlineMapProvider =
    ChangeNotifierProvider<OfflineMapNotifier>((ref) => OfflineMapNotifier());

class OfflineMapNotifier extends ChangeNotifier {
  List<CityModel> cityList = [];
  List<BMFUpdateElement> updateList = [];

  void loadData(OfflineController offlineController) async {
    var hotList = await offlineController.getHotCityList();
    List<CityModel> hotCityList = [];
    if (hotList != null) {
      for (var element in hotList) {
        if (element.childCities != null && element.childCities!.isNotEmpty) {
          element.childCities?.forEach((element) {
            hotCityList.add(CityModel(city: element, tagIndex: '★'));
          });
        } else {
          hotCityList.add(CityModel(city: element, tagIndex: '★'));
        }
      }
    }

    var list = await offlineController.getOfflineCityList();
    List<CityModel> allList = [];
    if (list != null) {
      cityList.add(CityModel(city: list[0], tagIndex: "*"));
      list.removeAt(0);

      for (var element in list) {
        if (element.childCities != null && element.childCities!.isNotEmpty) {
          element.childCities?.forEach((element) {
            if (!hotCityList
                .any((element1) => element1.city.cityID == element.cityID)) {
              allList.add(CityModel(city: element));
            }
          });
        } else {
          if (!hotCityList
              .any((element1) => element1.city.cityID == element.cityID)) {
            allList.add(CityModel(city: element));
          }
        }
      }
      SuspensionUtil.sortListBySuspensionTag(allList);
    }

    cityList.addAll(hotCityList);
    cityList.addAll(allList);

    SuspensionUtil.setShowSuspensionStatus(cityList);
    notifyListeners();
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
    // if (progress > 0.0) {
    //   Loading.toast("下载中，请不要重复点击");
    //   return;
    // }

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
    ref.read(offlineMapProvider).loadData(_offlineController);

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      ref.read(offlineMapProvider).getAllUpdateInfo(_offlineController);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, "离线地图"),
      body: SafeArea(
        child: _buildCityList(ref.watch(offlineMapProvider).cityList),
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
  Widget _buildCityList(List<CityModel> data) {
    return Column(
      children: [
        Expanded(
          child: AzListView(
            data: data,
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              CityModel model = data[index];
              return cityCell(context, model);
            },
            padding: EdgeInsets.zero,
            susItemBuilder: (BuildContext context, int index) {
              CityModel model = data[index];
              String tag = model.getSuspensionTag();
              return getSusItem(context, tag);
            },
            indexBarData: ['★', ...kIndexBarData],
          ),
        )
      ],
    );
  }

  Widget getSusItem(BuildContext context, String tag, {double susHeight = 40}) {
    if (tag == "*") {
      return Container();
    }
    if (tag == '★') {
      tag = '★ 热门城市';
    }
    return Container(
      height: susHeight,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 16.0),
      color: Color(0xFFF3F4F5),
      alignment: Alignment.centerLeft,
      child: Text(
        tag,
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          color: Color(0xFF666666),
        ),
      ),
    );
  }

  Widget cityCell(BuildContext context, CityModel data) {
    var progress = ref.read(offlineMapProvider).getProgress(data.city.cityID!);

    return ListTile(
      title: Column(children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.city.cityName ?? "",
                    style: TextStyle(fontSize: 28.sp)),
                Text("${data.city.dataSize?.getMB}M",
                    style:
                        TextStyle(color: AppColors.downloaded, fontSize: 28.sp))
              ],
            ).expanded(),
            widgetDownLoad(progress, data).padding(all: 10.w).onTap(() => ref
                .read(offlineMapProvider)
                .setUpdateInfo(_offlineController, progress, data.city.cityID!))
          ],
        ),
        LinearProgressIndicator(
          value: progress,
          minHeight: 3,
        ),
      ]),
    );
  }

  Widget widgetDownLoad(double progress, CityModel data) {
    return progress == 0.0
        ? Text("下载",
            style: TextStyle(color: AppColors.commonPrimary, fontSize: 28.sp))
        : progress == 1
            ? Text("已下载",
                style: TextStyle(color: AppColors.downloaded, fontSize: 28.sp))
            : Text("下载中",
                style:
                    TextStyle(color: AppColors.commonPrimary, fontSize: 28.sp));
  }
}
