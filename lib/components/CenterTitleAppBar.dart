
import 'package:demo/routes/applicationRouter.dart';
import 'package:flutter/material.dart';

class CenterTitleAppBar {
  static AppBar appBar (BuildContext context, String title, {Color color, double elevation = 0.0, VoidCallback onPressed} ) {
    return AppBar(
      backgroundColor: color,
      leading: IconButton(
        icon:  Icon(IconData(0xe611, fontFamily: 'iconfont'), size: 16, color: Colors.white,), 
        onPressed: onPressed ?? () {
          ApplicationRouter.router.pop(context);
        },
      ),
      title: Text(title, style: TextStyle(color: Colors.white)),
      centerTitle: true,
    );
  }
}