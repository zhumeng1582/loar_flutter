import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';
import 'package:loar_flutter/page/home/provider/im_message_provider.dart';

import '../../common/colors.dart';
import '../../common/image.dart';
import '../../common/routers/RouteNames.dart';
import '../../common/util/gaps.dart';
import '../../common/util/images.dart';
import '../home/bean/ConversationBean.dart';
import '../home/provider/home_provider.dart';

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
    List<EMUserInfo> data = ref.watch(imProvider).contacts.values.toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bottomBackground,
        title: Text("联系人"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'Scan',
            onPressed: scan,
          )
        ],
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildRoomItem(data[index]).onTap(() {
            _room(data[index]);
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

extension _UI on _ContactsPageState {
  Widget _getIcon(EMUserInfo data) {
    return ImageWidget(
      url: data.avatarUrl ?? AssetsImages.getRandomAvatar(),
      width: 80.w,
      height: 80.h,
      type: ImageWidgetType.asset,
    );
  }

  Widget _buildRoomItem(EMUserInfo data) {
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

extension _Action on _ContactsPageState {
  scan() async {
    var qrCodeData = await ref.read(homeProvider).scan();
    if (qrCodeData.userInfo != null) {

    } else if (qrCodeData.room != null) {}
  }

  _room(EMUserInfo data) {
    ConversationBean conversationBean =
        ConversationBean(data.userId, "", data.nickName ?? "", "", []);
    Navigator.pushNamed(
      context,
      RouteNames.roomPage,
      arguments: conversationBean,
    );
  }
}
