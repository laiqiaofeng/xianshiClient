import 'dart:convert';
import 'package:demo/http/net.dart';
import 'package:demo/http/netCache.dart';
import 'package:demo/model/cache_config.dart';
import 'package:demo/model/profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ENV {
  PRODUCTION,
  DEV,
}

// 可选主题色
const _themes = <Color>[
  Color(0xFF0f84f8),
  Color(0xFFFCD55A),
  Color(0xff47c880),
  Color(0xfff22c2c)
];

class Global {
  static SharedPreferences _prefs;
  // 用户的基本信息
  static Profile profile = Profile();

  // 默认字体颜色
  static Color defaultFontColor = Color(0xff333333);

  // 辅助字体颜色
  static Color assistFontColor = Color(0xff666666);

  // static 
  static Color assist2FontColor = Color(0xff999999);

  // 主题色
  static Color themeColor = Color(0xFF0f84f8);

  // 背景辅助色

  static Color assistThemeColor = Color(0xff29b4f9);

  // 背景色
  static Color bgColor = Color(0xFF444242);

  // 网络缓存对象
  static NetCache netCache = NetCache();

  // 可选的主题列表
  static List<Color> get themes => _themes;

  // 是否为release版
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  /// 通过Application设计环境变量
  static ENV env = ENV.DEV;

  //初始化全局信息，会在APP启动时（渲染myapp前）执行
  static Future init() async {
    print('初始化中');
    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs.getString("profile");
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
        themeColor = Color(profile.theme) ?? Color(0xFF0f84f8);
        bgColor = Color(profile.bgColor) ?? Colors.white;
      } catch (e) {
        print(e);
      }
    }

    // 如果没有缓存策略，设置默认缓存策略
    profile.cacheConfig = profile.cacheConfig ?? CacheConfig()
      ..enable = true
      ..maxAge = 3600
      ..maxCount = 100;

    // //初始化网络请求相关配置
    Net.init();
  }


  // 持久化Profile信息
  static saveProfile() {
    print(profile.theme);
    _prefs.setString("profile", jsonEncode(profile.toJson()));
  }


  /// 所有获取配置的唯一入口
  Map<String, String> get config {
    if (env == ENV.PRODUCTION) {
      return {};
    }
    if (env == ENV.DEV) {
      return {};
    }
    return {};
  }
    
}