import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loar_flutter/page/home/room_list.dart';
import 'package:loar_flutter/page/record_page.dart';
import 'package:loar_flutter/page/statellite_map.dart';

import '../../common/image.dart';
import '../../common/routers/RouteNames.dart';

final homeProvider =
    ChangeNotifierProvider<HomeNotifier>((ref) => HomeNotifier());

class HomeNotifier extends ChangeNotifier {
  List<RoomItem> data = [];

  loadData() {
    data.add(RoomItem("1","聊天室1","快下班了","晚上8:49"));
    data.add(RoomItem("2","聊天室2","国庆去哪里玩","晚上7:43"));
    data.add(RoomItem("3","聊天室3","晚上开一把","晚上4:9"));
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    ref.read(homeProvider).loadData();
  }

  @override
  Widget build(BuildContext context) {
    List<RoomItem> data = ref.watch(homeProvider).data;
    return Scaffold(
      appBar: AppBar(
        title: Text("聊天"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildRoomItem(data[index]);
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

extension _Action on _HomePageState {
  room(RoomItem data) {
    Navigator.pushNamed(
      context,
      RouteNames.roomPage,
      arguments: data,
    );
  }
}

extension _UI on _HomePageState {
  _buildRoomItem(RoomItem data) {
    return InkWell(
      onTap: () => room(data),
      child: Column(
        children: [
          Row(
            children: [
              ImageWidget(
                url: data.icon,
                width: 50,
                height: 50,
                type: ImageWidgetType.network,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.name),
                    Text(data.latestMessage),
                  ],
                ),
              ),
              Text(data.time),
            ],
          ),
          const Divider(height: 10),
        ],
      ),
    );
  }
}
