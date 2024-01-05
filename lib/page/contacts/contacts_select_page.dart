import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/ex/ex_im.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';

import '../../common/image.dart';
import '../../common/util/gaps.dart';
import '../../widget/common.dart';
import '../home/provider/im_message_provider.dart';

final contractSelectProvider = ChangeNotifierProvider<ContactsSelectNotifier>(
    (ref) => ContactsSelectNotifier());

class ContactsSelectNotifier extends ChangeNotifier {

}

class ContactsSelectPage extends ConsumerStatefulWidget {
  List<String> userList;

  ContactsSelectPage({super.key, required this.userList});

  @override
  ConsumerState<ContactsSelectPage> createState() => _ContactsSelectPageState();
}

class _ContactsSelectPageState extends ConsumerState<ContactsSelectPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> data = widget.userList;

    return Scaffold(
      appBar: getAppBar(context, "选择联系人"),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          var userInfo = ref.read(imProvider).getUserInfo(data[index]);
          if (userInfo != null) {
            return _buildCellItem(userInfo).onTap(() {
              _selectUser(userInfo);
            });
          } else {
            Container();
          }
        },
      ).paddingVertical(20.h),
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
      url: data.avatarName,
      width: 80.w,
      height: 80.h,
      radius: 6.r,
      type: ImageWidgetType.asset,
    );
  }

  Widget _buildCellItem(EMUserInfo data) {
    return Column(
      children: [
        Row(
          children: [
            _getIcon(data).paddingHorizontal(30.w),
            Text(data.name).paddingHorizontal(30.w),
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
