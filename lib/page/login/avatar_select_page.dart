import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';

import '../../common/image.dart';
import '../../common/util/images.dart';

final avatarSelectProvider = ChangeNotifierProvider<AvatarSelectNotifier>(
    (ref) => AvatarSelectNotifier());

class AvatarSelectNotifier extends ChangeNotifier {
  List<String> data = [];

  initData() {
    data.clear();
    for (int i = 1; i <= 100; i++) {
      data.add(AssetsImages.getAvatar(i));
    }
    notifyListeners();
  }
}

class AvatarSelectPage extends ConsumerStatefulWidget {
  const AvatarSelectPage({super.key});

  @override
  ConsumerState<AvatarSelectPage> createState() => _AvatarSelectPageState();
}

class _AvatarSelectPageState extends ConsumerState<AvatarSelectPage> {
  @override
  void initState() {
    Future(() {
      ref.read(avatarSelectProvider).initData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> data = ref.watch(avatarSelectProvider).data;

    return Scaffold(
      appBar: AppBar(
        title: Text("选择头像"),
        centerTitle: true,
      ),
      body: GridView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildCellItem(data[index])
              .inkWell(onTap: () => {_selectAvatar(data[index])});
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, //横轴三个子widget
            childAspectRatio: 1.0 //宽高比为1时，子widget
            ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

extension _UI on _AvatarSelectPageState {
  Widget _buildCellItem(String data) {
    return ImageWidget(
      url: data,
      width: 40.w,
      height: 40.h,
      radius: 6.r,
      type: ImageWidgetType.asset,
    ).paddingVertical(5.h).paddingHorizontal(5.w);
  }
}

extension _Action on _AvatarSelectPageState {
  _selectAvatar(String data) {
    Navigator.pop(context, data);
  }
}
