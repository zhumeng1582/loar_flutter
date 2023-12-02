import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'FriendCell.dart';
import 'HeaderView.dart';
import 'friendmodel_entity.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FriendPageState();
  }
}

class _FriendPageState extends State<FriendPage> {
  final ScrollController _scrollController = ScrollController();
  double _opacity = 0;

  FriendmodelEntity _friendmodelEntity = FriendmodelEntity(data: []);

  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/Data.json');
  }

  @override
  void initState() {
    super.initState();

    loadAsset().then((value) {
      var json = jsonDecode(value);
      _friendmodelEntity = FriendmodelEntity.fromJson(json);
      setState(() {});
    });

    _scrollController.addListener(() {
      double alph = _scrollController.offset / 200;
      if (alph < 0) {
        alph = 0;
      } else if (alph > 1) {
        alph = 1;
      }
      setState(() {
        _opacity = alph;
      });
    });
  }

  Widget _mainListViewBuilder(BuildContext context, int index) {
    return FriendCell(
      model: _friendmodelEntity.data[index],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ListView(
            padding: const EdgeInsets.only(top: 0),
            controller: _scrollController,
            children: <Widget>[
              HeaderView(),
              ListView.builder(
                padding: const EdgeInsets.only(top: 0),
                itemBuilder: _mainListViewBuilder,
                itemCount: _friendmodelEntity.data.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              )
            ],
          ),
          Opacity(
            opacity: _opacity,
            child: const CupertinoNavigationBar(
              middle: Text("朋友圈"),
            ),
          )
        ],
      ),
    );
  }
}
