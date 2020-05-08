import 'package:flutter/material.dart';
// 退出拦截
class WillPopScopeRoute extends StatefulWidget {

  Widget _container;
  WillPopScopeRoute(this._container);
  
  @override
  WillPopScopeRouteState createState() {
    return new WillPopScopeRouteState();
  }
}

class WillPopScopeRouteState extends State<WillPopScopeRoute> {
  DateTime _lastPressedAt; //上次点击时间

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async {
          if (_lastPressedAt == null ||
              DateTime.now().difference(_lastPressedAt) > Duration(seconds: 1)) {
            //两次点击间隔超过1秒则重新计时
            _lastPressedAt = DateTime.now();
            return false;
          }
          return true;
        },
        child: widget._container
    );
  }
}