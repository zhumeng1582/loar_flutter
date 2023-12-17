import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/im_data.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';
import '../../common/ex/ex_userInfo.dart';
import '../../common/image.dart';
import '../../common/routers/RouteNames.dart';
import '../../common/util/images.dart';
import '../../widget/bubble_chat.dart';
import '../home/provider/im_message_provider.dart';
import '../../common/colors.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';

import '../map/model/page_type.dart';

final roomMessageProvider =
    ChangeNotifierProvider<RoomMessageNotifier>((ref) => RoomMessageNotifier());

class RoomMessageNotifier extends ChangeNotifier {}

class ChatMessagePage extends ConsumerStatefulWidget {
  String conversationId;

  ChatMessagePage({super.key, required this.conversationId});

  @override
  ConsumerState<ChatMessagePage> createState() => _RoomMessagePageState();
}

class _RoomMessagePageState extends ConsumerState<ChatMessagePage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    List<EMMessage> data =
        ref.watch(imProvider).messageMap[widget.conversationId] ?? [];
    return _buildChat(data);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}

extension _Action on _RoomMessagePageState {
  void init() async {}
}

extension _UI on _RoomMessagePageState {
  Widget _buildChat(List<EMMessage> data) {
    return Expanded(
        flex: 1,
        child: Container(
          alignment: Alignment.topCenter,
          child: ListView.builder(
            controller: _scrollController,
            itemCount: data.length,
            reverse: true,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return _buildRoomMessageItem(data[index])
                  .paddingVertical(10.w)
                  .paddingHorizontal(30.w);
            },
          ),
        ));
  }

  Widget _buildRoomMessageItem(EMMessage data) {
    if (data.from == GlobeDataManager.instance.me?.userId) {
      return _buildChatRightItem(data, _buildChatContent(data));
    } else {
      return _buildChatLeftItem(data, _buildChatContent(data));
    }
  }

  Widget _buildChatContent(EMMessage data) {
    var isSender = data.from == GlobeDataManager.instance.me?.userId;
    if (data.body is EMLocationMessageBody) {
      EMLocationMessageBody body = data.body as EMLocationMessageBody;
      return Stack(
        children: [
          BMFMapWidget(
              onBMFMapCreated: (controller) {
                controller.addMarker(BMFMarker.icon(
                    position: BMFCoordinate(body.latitude, body.longitude),
                    title: "",
                    identifier: GlobeDataManager.instance.me?.userId,
                    icon: AssetsImages.iconPeople));
              },
              mapOptions: BMFMapOptions(
                mapType: BMFMapType.Standard,
                zoomLevel: 12,
                maxZoomLevel: 21,
                minZoomLevel: 4,
                showZoomControl: false,
                center: BMFCoordinate(body.latitude, body.longitude),
              )),
          Container().onTap(() {
            var other =
                OnlineUser.create(data.from, body.latitude, body.longitude);
            Navigator.pushNamed(context, RouteNames.baiduMapPage,
                arguments: MapDataPara(PageType.navigation, other: other));
          })
        ],
      ).paddingHorizontal(20.w).height(180.h).width(540.w);
    }

    EMTextMessageBody body = data.body as EMTextMessageBody;
    var repeater = "";

    if (body.targetLanguages?.isNotEmpty == true &&
        body.targetLanguages?[0].isNotEmpty == true) {
      repeater = "---(由${body.targetLanguages}转发)";
    }
    return BubbleChat(
      text: "${body.content}$repeater",
      isSender: isSender,
      sent: isSender ? data.hasDeliverAck : false,
      color: !isSender ? Colors.grey : AppColors.bubbleBgColor,
      textStyle: TextStyle(
        fontSize: 24.sp,
      ),
    );
  }

  _buildChatLeftItem(EMMessage data, Widget child) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        userAvatar(data),
        child,
      ],
    );
  }

  _buildChatRightItem(EMMessage data, Widget child) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        child,
        userAvatar(data),
      ],
    );
  }

  Widget userAvatar(EMMessage data) {
    return ImageWidget(
      url: ref.read(imProvider).getAvatarUrl(data.from),
      width: 80.w,
      height: 80.h,
      type: ImageWidgetType.asset,
    ).onTap(() {
      var userInfo = ref.read(imProvider).allUsers[data.from];
      Navigator.pushNamed(
        context,
        RouteNames.usesInfoPage,
        arguments: userInfo,
      );
    });
  }

// _buildNotifyItem(EMMessage data) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.center,
//     children: [
//       Text(
//         "${data.sender.name}加入群聊",
//         style: TextStyle(
//           color: AppColors.title.withOpacity(0.5),
//           fontSize: 24.sp,
//         ),
//       )
//     ],
//   );
// }
}
