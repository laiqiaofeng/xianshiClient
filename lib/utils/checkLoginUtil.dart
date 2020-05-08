import 'package:demo/common/Global.dart';
import 'package:demo/routes/applicationRouter.dart';
import 'package:demo/routes/routers.dart';
import 'package:flutter/cupertino.dart';

class CheckLogin {
  static checkLogin ( BuildContext context, Function handler,) {
    bool isLogin = Global.profile.user != null;
    if (!isLogin) {
      ApplicationRouter.router.navigateTo(context, Routes.loginPage);
      return;
    }
    handler();
  }
}