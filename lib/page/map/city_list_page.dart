import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'model/city_model.dart';

final cityListProvider =
    ChangeNotifierProvider<CityListNotifier>((ref) => CityListNotifier());

class CityListNotifier extends ChangeNotifier {
  List<CityModel> cityList = [];

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
    cityList.insertAll(0, hotCityList);

    var list = await offlineController.getOfflineCityList();
    List<CityModel> allList = [];
    if (list != null) {
      for (var element in list) {
        if (element.childCities != null && element.childCities!.isNotEmpty) {
          element.childCities?.forEach((element) {
            allList.add(CityModel(city: element));
          });
        } else {
          allList.add(CityModel(city: element));
        }
      }
      SuspensionUtil.sortListBySuspensionTag(allList);
    }
    cityList.addAll(allList);

    SuspensionUtil.setShowSuspensionStatus(cityList);
    notifyListeners();
  }
}

class CityListPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<CityListPage> createState() => _CityListPageState();
}

class _CityListPageState extends ConsumerState<CityListPage> {
  final OfflineController _offlineController = OfflineController();

  @override
  void initState() {
    super.initState();
    _offlineController.init();
    ref.read(cityListProvider).loadData(_offlineController);
  }

  Widget header() {
    return Container(
      color: Colors.white,
      height: 44.0,
      child: Row(
        children: <Widget>[
          Expanded(
              child: TextField(
            autofocus: false,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10, right: 10),
                border: InputBorder.none,
                labelStyle: TextStyle(fontSize: 14, color: Color(0xFF333333)),
                hintText: '城市中文名或拼音',
                hintStyle: TextStyle(fontSize: 14, color: Color(0xFFCCCCCC))),
          )),
          Container(
            width: 0.33,
            height: 14.0,
            color: Color(0xFFEFEFEF),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "取消",
                style: TextStyle(color: Color(0xFF999999), fontSize: 14),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var cityList = ref.read(cityListProvider).cityList;
    return Scaffold(
      appBar: AppBar(
        title: Text('选择城市'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Column(
        children: [
          header(),
          Expanded(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 15.0),
                  height: 50.0,
                  child: Text("当前城市: 成都市"),
                ),
                Expanded(
                  child: AzListView(
                    data: cityList,
                    itemCount: cityList.length,
                    itemBuilder: (BuildContext context, int index) {
                      CityModel model = cityList[index];
                      return getListItem(context, model);
                    },
                    padding: EdgeInsets.zero,
                    susItemBuilder: (BuildContext context, int index) {
                      CityModel model = cityList[index];
                      String tag = model.getSuspensionTag();
                      return getSusItem(context, tag);
                    },
                    indexBarData: ['★', ...kIndexBarData],
                  ),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }

  static Widget getSusItem(BuildContext context, String tag,
      {double susHeight = 40}) {
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
        '$tag',
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          color: Color(0xFF666666),
        ),
      ),
    );
  }

  static Widget getListItem(BuildContext context, CityModel model) {
    return ListTile(
      title: Text(model.city.cityName!),
      onTap: () {
        Navigator.pop(context, model);
      },
    );
  }
}
