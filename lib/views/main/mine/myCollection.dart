import 'package:demo/components/CenterTitleAppBar.dart';
import 'package:demo/components/EmptyPage.dart';
import 'package:flutter/material.dart';

class MyCollection extends StatefulWidget {
  MyCollection({Key key}) : super(key: key);

  @override
  _MyCollectionState createState() => _MyCollectionState();
}

class _MyCollectionState extends State<MyCollection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CenterTitleAppBar.appBar(context, '我的分享'),
      body: Center(
        child: EmptyPage(hintText: '还没有分享记录哟 ~',),
      )
    );
  }
}