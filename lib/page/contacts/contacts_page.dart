import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/image.dart';
import 'contacts_list.dart';

final contactsProvider =
    ChangeNotifierProvider<ContactsNotifier>((ref) => ContactsNotifier());

class ContactsNotifier extends ChangeNotifier {
  List<UserInfo> data = [];
  loadData(){
    data.add(UserInfo());
    data.add(UserInfo());
    data.add(UserInfo());
  }
}

class ContactsPage extends ConsumerStatefulWidget {
  const ContactsPage({super.key});

  @override
  ConsumerState<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends ConsumerState<ContactsPage> {
  @override
  void initState() {
    super.initState();
    ref.read(contactsProvider).loadData();
  }
  @override
  Widget build(BuildContext context) {
    List<UserInfo> data = ref.watch(contactsProvider).data;
    return Scaffold(
      appBar: AppBar(
        title: Text("联系人"),
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

extension _UI on _ContactsPageState {
  _buildRoomItem(UserInfo data) {
    return Column(
      children: [
        Row(
          children: [
            ImageWidget(url:data.icon,width: 50,height: 50, type: ImageWidgetType.network,),
            Text(data.name),
          ],
        ),
        const Divider(height:10),
      ],
    );
  }
}
