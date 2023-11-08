import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';

import '../../common/image.dart';
import '../../common/util/gaps.dart';
import '../../common/util/images.dart';
import '../home/provider/home_provider.dart';
import '../home/provider/im_message_provider.dart';

final contractSelectProvider = ChangeNotifierProvider<ContactsSelectNotifier>(
    (ref) => ContactsSelectNotifier());

class ContactsSelectNotifier extends ChangeNotifier {
  List<EMUserInfo> data = [];

  initData(List<EMUserInfo> data, String roomId) {
    this.data =
        data; //data.where((element) => !isInRoom(roomInfo, element)).toList();
    notifyListeners();
  }
}

class ContactsSelectPage extends ConsumerStatefulWidget {
  String roomId;

  ContactsSelectPage({super.key, required this.roomId});

  @override
  ConsumerState<ContactsSelectPage> createState() => _ContactsSelectPageState();
}

class _ContactsSelectPageState extends ConsumerState<ContactsSelectPage> {
  @override
  void initState() {
    Future(() {
      List<EMUserInfo> data = ref.watch(imProvider).contacts.values.toList();
      ref.read(contractSelectProvider).initData(data, widget.roomId);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<EMUserInfo> data = ref.watch(contractSelectProvider).data;

    return Scaffold(
      appBar: AppBar(
        title: Text("选择联系人"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildCellItem(data[index]).onTap(() {
            _selectUser(data[index]);
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

extension _UI on _ContactsSelectPageState {
  Widget _getIcon(EMUserInfo data) {
    return ImageWidget(
      url: data.avatarUrl ?? AssetsImages.getDefaultAvatar(),
      width: 40.w,
      height: 40.h,
      type: ImageWidgetType.asset,
    );
  }

  Widget _buildCellItem(EMUserInfo data) {
    return Column(
      children: [
        Row(
          children: [
            _getIcon(data).paddingHorizontal(30.w),
            Text(data.nickName ?? ""),
          ],
        ),
        Gaps.line.paddingLeft(140.w).paddingVertical(15.h)
      ],
    );
  }
}

extension _Action on _ContactsSelectPageState {
  _selectUser(EMUserInfo data) {
    Navigator.pop(context, [data]);
  }
}
