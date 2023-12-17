import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/ex/ex_widget.dart';
import 'package:loar_flutter/common/im_data.dart';
import 'package:loar_flutter/common/ex/ex_im.dart';
import 'package:loar_flutter/page/home/provider/im_message_provider.dart';
import 'package:loar_flutter/widget/commit_button.dart';
import '../../common/image.dart';
import '../../common/loading.dart';
import '../../common/proto/qr_code_data.dart';
import '../../common/routers/RouteNames.dart';
import '../../common/util/images.dart';
import '../../widget/common.dart';
import '../../widget/edit_remark_sheet.dart';
import '../../widget/warning_alert.dart';
import '../home/provider/network_provider.dart';

final roomProvider = ChangeNotifierProvider<RoomAddDetailNotifier>(
    (ref) => RoomAddDetailNotifier());

class RoomAddDetailNotifier extends ChangeNotifier {}

class ChatAddDetailPage extends ConsumerStatefulWidget {
  EMGroup group;

  ChatAddDetailPage({super.key, required this.group});

  @override
  ConsumerState<ChatAddDetailPage> createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends ConsumerState<ChatAddDetailPage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, "聊天信息"),
      body: SafeArea(
        child: Column(
          children: getGroup(),
        ).paddingHorizontal(30.h),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

extension _Action on _RoomDetailPageState {
  joinGroup() {
    ref.read(imProvider).joinPublicGroup(widget.group.groupId);
    Navigator.pop(context);
  }
}

extension _UI on _RoomDetailPageState {
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

  List<Widget> getGroup() {
    List<Widget> list = [];
    var group = widget.group;
    list.add(_getMeItem("群名称", group.showName,
        group.owner == GlobeDataManager.instance.me?.userId));
    list.add(_getMeItem("群说明", group.description,
        group.owner == GlobeDataManager.instance.me?.userId));

    // list.add(CommitButton(
    //         buttonState: ButtonState.normal, text: "加入群聊", tapAction: joinGroup)
    //     .paddingTop(60.h));
    return list;
  }
}
