
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';

final loginProvider =
    ChangeNotifierProvider<LoginNotifier>((ref) => LoginNotifier());

class LoginNotifier extends ChangeNotifier {

}

class TestPage extends ConsumerStatefulWidget {
  const TestPage({super.key});

  @override
  ConsumerState<TestPage> createState() => _TestPageState();
}

class _TestPageState extends ConsumerState<TestPage> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("登陆"),
      ),
      body: SafeArea(
        child: Column(
          children: [],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

  }
}

extension _Action on _TestPageState {
}

extension _UI on _TestPageState {}
