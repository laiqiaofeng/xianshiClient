import 'package:flutter/material.dart';

class SideTabs extends StatefulWidget {
  SideTabs({Key key}) : super(key: key);

  @override
  _SideTabsState createState() => _SideTabsState();
}

class _SideTabsState extends State<SideTabs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[

        ] 
      ),
    );
  }
}


class Page extends StatefulWidget {
  Page({Key key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  static double percentVisible = 1;
  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.translationValues(0.0, 50.0 *(1.0 - percentVisible), 10.0),
    );
  }
}