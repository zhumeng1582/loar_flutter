import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loar_flutter/page/home/home_page.dart';

import '../../common/image.dart';
import '../../common/proto/index.dart';
import '../../common/routers/RouteNames.dart';


class ContactsPage extends ConsumerStatefulWidget {
  const ContactsPage({super.key});

  @override
  ConsumerState<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends ConsumerState<ContactsPage> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    List<UserInfo> data = ref.watch(homeProvider).userInfoList.userList;
    return Scaffold(
      appBar: AppBar(
        title: Text("联系人"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'Scan',
            onPressed: ref.read(homeProvider).scan,
          )
        ],
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

extension _UI on _ContactsPageState {
  _buildRoomItem(UserInfo data) {
    return InkWell(
      onTap: () => _room(data),
      child: Column(
        children: [
          Row(
            children: [
              ImageWidget(url:data.icon,width: 50,height: 50, type: ImageWidgetType.network,),
              Text(data.name),
            ],
          ),
          const Divider(height:10),
        ],
      ),
    );
  }
}

extension _Action on _ContactsPageState {
  _room(UserInfo data) {
    Navigator.pushNamed(
      context,
      RouteNames.roomPage,
      arguments: data.id,
    );
  }
}