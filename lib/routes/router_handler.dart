

import 'package:demo/views/main/mine/updatePassword.dart';
import 'package:demo/views/main/note/createNote.dart';
import 'package:demo/views/main/plan/createPlan.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

// 页面
import 'package:demo/views/main/webview.dart';
import 'package:demo/views/main/home.dart';
import 'package:demo/views/login/login.dart';
import '../views/introduce/stepPage.dart';
import 'package:demo/views/login/register.dart';
import 'package:demo/views/main/mine/accountSecurity.dart';
import 'package:demo/views/login/modifyPassword.dart';
import 'package:demo/views/main/information/categoryPage/category.dart';
import 'package:demo/views/main/mine/modifyUserInfo.dart';
import 'package:demo/views/main/mine/setting.dart';
import 'package:demo/views/main/mine/myCollection.dart';
import 'package:demo/views/main/imagePreview.dart';


// 首页路由处理函数
Handler homeHander = Handler(
  handlerFunc: (BuildContext context,Map<String,List<String>> params){
    return HomePage();

  }
);

// 登录页路由处理函数
Handler loginHander = Handler(
  handlerFunc: (BuildContext context,Map<String,List<String>> params){
    return LoginPage();
  }
);

// 注册页面
Handler registerHander = Handler(
  handlerFunc: (BuildContext context,Map<String,List<String>> params){
    return RegisterPage();
  }
);

// 介绍页路由处理函数
Handler stepPageHander = Handler(
  handlerFunc: (BuildContext context,Map<String,List<String>> params){
    bool hasBotton = params['hasBotton']?.first == 'false';
    return StepPage(hasBotton: hasBotton);
  }
);

// webView 页路由
Handler webViewPageHander = Handler(
  handlerFunc: (BuildContext context,Map<String,List<String>> params){
    String url = params['url']?.first;
    String title = params['title']?.first;
    return WebViewPage(url: url, title: title);
  }
);

// 文章类型页面
Handler categoryHander = Handler(
  handlerFunc: (BuildContext context,Map<String,List<String>> params){
    return CategoryPage();
  }
);

// 修改密码页面
Handler modifyPasswordHandler = Handler(
  handlerFunc: (BuildContext context,Map<String,List<String>> params){
    return ModifyPassword();
  }
);


// 设置页处理函数
Handler settingHandler = Handler(
  handlerFunc: (BuildContext context,Map<String,List<String>> params){
    return SettingPage();
  }
);


// 编辑用户信息
Handler modifyUserInfoHandler = Handler(
  handlerFunc: (BuildContext context,Map<String,List<String>> params){
    return ModifyUserInfoPage();
  }
);


// 账户安全页面
Handler accountSecurityHandler = Handler(
  handlerFunc: (BuildContext context,Map<String,List<String>> params){
    return AccountSecurity();
  }
);

// 我的收藏页面
Handler myCollectionHandler = Handler(
  handlerFunc: (BuildContext context,Map<String,List<String>> params){
    return MyCollection();
  }
);

// 我的收藏页面
Handler updatePasswordHandler = Handler(
  handlerFunc: (BuildContext context,Map<String,List<String>> params){
    return UpdatePassword();
  }
);

// 创建plan页面
Handler createPlanHandler = Handler(
  handlerFunc: (BuildContext context,Map<String,List<String>> params){
    return CreatePlan();
  }
);

// 创建便签
Handler createNoteHandler = Handler(
  handlerFunc: (BuildContext context,Map<String,List<String>> params){
    return CreateNote();
  }
);

// 图片预览页
Handler imagePreviewHandler = Handler(
  handlerFunc: (BuildContext context,Map<String,List<String>> params){
    String imageUrl = params['imageUrl'] != null  ?  params['imageUrl'].first : 'assets/images/default_avatar.png';
    String tag = params['tag'] != null  ? params['tag'].first : 'avatarUrl';
    bool hasButton = params['hasButton'].first != null ? params['hasButton'].first == 'true' : false;
    return ImagePreview(imgUrl: imageUrl, tag: tag, hasButton: hasButton);
  }
);
