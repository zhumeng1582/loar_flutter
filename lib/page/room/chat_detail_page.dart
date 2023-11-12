import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:loar_flutter/common/ex/ex_widget.dart';
import 'package:loar_flutter/common/im_data.dart';
import 'package:loar_flutter/common/loading.dart';
import 'package:loar_flutter/common/ex/ex_im.dart';
import 'package:loar_flutter/page/home/provider/im_message_provider.dart';
import 'package:loar_flutter/widget/commit_button.dart';
import '../../common/image.dart';
import '../../common/proto/qr_code_data.dart';
import '../../common/routers/RouteNames.dart';
import '../../common/util/images.dart';
import '../../widget/edit_remark_sheet.dart';
import '../../widget/warning_alert.dart';
import '../home/bean/conversation_bean.dart';

final roomProvider =
    ChangeNotifierProvider<RoomDetailNotifier>((ref) => RoomDetailNotifier());

class RoomDetailNotifier extends ChangeNotifier {
  roomDetail() {}
  EMGroup? group;
  EMUserInfo? userInfo;
  List<EMUserInfo> userInfoList = [];

  Future<EMGroup> fetchGroupInfoFromServer(String groupId) async {
    return await EMClient.getInstance.groupManager
        .fetchGroupInfoFromServer(groupId, fetchMembers: true);
  }

  Future<Map<String, EMUserInfo>> fetchUserInfoById(
      List<String> userIds) async {
    return await EMClient.getInstance.userInfoManager
        .fetchUserInfoById(userIds);
  }

  Future<EMGroup> _createGroup() async {
    EMGroupOptions groupOptions = EMGroupOptions(
      style: EMGroupStyle.PrivateMemberCanInvite,
      inviteNeedConfirm: true,
      maxCount: 10,
    );

    return await EMClient.getInstance.groupManager.createGroup(
      options: groupOptions,
    );
  }

  Future<EMGroup?> addMembers(List<String> members) async {
    try {
      group ??= await _createGroup();

      await EMClient.getInstance.groupManager
          .addMembers(group!.groupId, members);
      group = await EMClient.getInstance.groupManager
          .fetchGroupInfoFromServer(group!.groupId, fetchMembers: true);
      return group;
    } on EMError catch (e) {}
  }

  getChatInfo(ConversationBean conversationBean) async {
    group = null;
    userInfo = null;

    if (conversationBean.getChatType() == ChatType.GroupChat) {
      group = await fetchGroupInfoFromServer(conversationBean.id);

      var userInfoMap = await fetchUserInfoById([
        group?.owner ?? "",
        ...group?.adminList ?? [],
        ...group?.memberList ?? []
      ]);
      userInfoList = userInfoMap.values.toList();
      userInfo = userInfoMap[group?.owner ?? ""];
    } else {
      var userInfoMap = await fetchUserInfoById([conversationBean.id]);
      userInfoList = userInfoMap.values.toList();
      userInfo = userInfoMap[conversationBean.id];
    }

    notifyListeners();
  }

  changeGroupName(String groupId, String name) async {
    try {
      await EMClient.getInstance.groupManager.changeGroupName(
        groupId,
        name,
      );
      group = await fetchGroupInfoFromServer(groupId);
      notifyListeners();
    } on EMError catch (e) {}
    return null;
  }

  changeGroupDescription(String groupId, String name) async {
    try {
      await EMClient.getInstance.groupManager.changeGroupDescription(
        groupId,
        name,
      );
      group = await fetchGroupInfoFromServer(groupId);
      notifyListeners();
    } on EMError catch (e) {}
    return null;
  }
}

class ChatDetailPage extends ConsumerStatefulWidget {
  ConversationBean conversationBean;

  ChatDetailPage({super.key, required this.conversationBean});

  @override
  ConsumerState<ChatDetailPage> createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends ConsumerState<ChatDetailPage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    ref.read(roomProvider).getChatInfo(widget.conversationBean);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("聊天信息"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _userInfoList(ref.watch(roomProvider).userInfoList),
            ...getGroup(),
          ],
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
  bool isOwner() {
    var group = ref.read(roomProvider).group;
    if (group != null) {
      return group.owner == ImDataManager.instance.me.userId;
    }
    return false;
  }

  exitGroup() {
    WarningActionSheetAlert.show(
        context: context,
        title: "提醒",
        content: isOwner() ? "您确定要解散群聊吗？" : "您确定要退出群聊吗？",
        textAlign: TextAlign.start,
        barrierDismissible: false,
        confirmActionText: "确定",
        cancelActionText: "取消",
        confirmAction: () => {confirmAction()},
        cancelAction: () => {});
  }

  confirmAction() async {
    var group = ref.read(roomProvider).group;
    if (group != null) {
      if (isOwner()) {
        await ref.read(imProvider).destroyGroup(group.groupId);
      } else {
        await ref.read(imProvider).leaveGroup(group.groupId);
      }
    }
  }

  invite(List<EMUserInfo>? data) async {
    if (data == null) {
      return;
    }

    var group = await ref
        .read(roomProvider)
        .addMembers(data.map((e) => e.userId).toList());

    ConversationBean conversationBean =
        ConversationBean(1, group?.groupId ?? "", "", group.showName, "", []);
    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteNames.roomPage,
      (route) => route.settings.name == RouteNames.main,
      arguments: conversationBean,
    );
  }

  selectUser(List<EMUserInfo> userInfo) async {
    List<String> data = [];
    if (widget.conversationBean.getConversationType() ==
        EMConversationType.Chat) {
      data.add(widget.conversationBean.id);
      ref.read(imProvider).contacts.forEach((value) {
        if (value != widget.conversationBean.id) {
          data.add(value);
        }
      });
    } else {
      EMGroup group = ref.read(roomProvider).group!;
      //排除已经在群里的用户
      ref.read(imProvider).contacts.forEach((value) {
        if (!inGroup(value, group)) {
          data.add(value);
        }
      });
    }

    Navigator.pushNamed(context, RouteNames.selectContact, arguments: data)
        .then((value) => {invite(value as List<EMUserInfo>?)});
  }

  bool inGroup(String userId, EMGroup group) {
    if (group.owner == userId) {
      return true;
    }
    if (group.memberList?.contains(userId) == true) {
      return true;
    }
    if (group.adminList?.contains(userId) == true) {
      return true;
    }
    return false;
  }

  changeName(String groupId, String? name) {
    EditRemarkBottomSheet.show(
      context: context,
      maxLength: 18,
      data: name ?? "",
      onConfirm: (value) =>
          {ref.read(roomProvider).changeGroupName(groupId, value)},
    );
  }

  changeDescription(String groupId, String? name) {
    EditRemarkBottomSheet.show(
      context: context,
      maxLength: 200,
      data: name ?? "",
      onConfirm: (value) =>
          {ref.read(roomProvider).changeGroupDescription(groupId, value)},
    );
  }
}

extension _UI on _RoomDetailPageState {
  Widget _userInfoList(List<EMUserInfo> userInfo) {
    return GridView(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5, //横轴三个子widget
            crossAxisSpacing: 10, //横轴三个子widget
            childAspectRatio: 1.0 //宽高比为1时，子widget
            ),
        children: <Widget>[
          ...userInfo.map((user) => ImageWidget(
                url: user.avatarName,
                width: 30.w,
                height: 30.h,
                type: ImageWidgetType.asset,
              )),
          ImageWidget(
            url: AssetsImages.iconAdd,
            width: 30.w,
            height: 30.h,
            type: ImageWidgetType.asset,
          ).onTap(() => selectUser(userInfo))
        ]);
  }

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
    var group = ref.watch(roomProvider).group;
    if (group != null) {
      list.add(_getMeItem("群名称", group.showName, true)
          .onTap(() => changeName(group.groupId, group.showName)));
      list.add(_getMeItem("群说明", group.description, true)
          .onTap(() => changeDescription(group.groupId, group.description)));
      list.add(_getMeItem("群二维码名片", "", true).onTap(() {
        QrCodeData qrCodeData = QrCodeData(
            userInfo: ref.read(roomProvider).userInfo,
            room: ref.read(roomProvider).group);
        Navigator.pushNamed(context, RouteNames.qrGenerate,
            arguments: qrCodeData);
      }));
      list.add(CommitButton(
              buttonState: ButtonState.normal,
              text: isOwner() ? "解散群聊" : "退出群聊",
              tapAction: exitGroup)
          .paddingTop(60.h));
    }
    return list;
  }
}
