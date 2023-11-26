import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/colors.dart';

AppBar getAppBar(BuildContext context, String title, {List<Widget>? actions}) {
  return AppBar(
    leading: IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    backgroundColor: AppColors.bottomBackground,
    title: Text(title),
    centerTitle: true,
    actions: actions,
  );
}
