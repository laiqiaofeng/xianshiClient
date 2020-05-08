import 'package:demo/common/Global.dart';
import 'package:demo/provider/profileChangeNotifier.dart';
import 'package:flutter/material.dart';

class ThemeModel extends ProfileChangeNotifier {
  // 获取当前主题，如果为设置主题，则默认使用蓝色主题
  Color get theme => Global.themeColor;

  // 获取背景颜色
  Color get bgColor => Global.bgColor;

  // 背景改变
  set bgColor(Color color) {
    if (color != bgColor) {
      profile.bgColor = color.value;
      Global.bgColor = color;
      notifyListeners();
    }
  }

  // 主题改变后，通知其依赖项，新主题会立即生效
  set theme(Color color) {
    if (color != theme) {
      profile.theme = color.value;
      Global.themeColor = color;
      notifyListeners();
    }
  }
}