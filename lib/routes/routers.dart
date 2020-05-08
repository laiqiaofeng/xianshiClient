import 'package:demo/components/CenterTitleAppBar.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import './router_handler.dart';

class Routes { //配置类
  static String root = '/'; //根目录

  static String loginPage ='/login'; //登录页

  static String registerPage = '/login/register'; // 注册页

  static String modifyPasswordPage = '/login/modifyPassword'; // 忘记秘密修改密码页

  static String homePage = '/home'; //首页页面

  static String stepPage = '/introduce'; // 解释页

  static String webviewPage = '/webview'; // webview页面

  static String categoryPage ='/categoryPage'; // 文章种类页面

  static String settingPage = '/mine/setting'; // 设置页

  static String modifyUserInfoPage = '/mine/modifyUserInfo'; // 修改用户信息
  
  static String accountSecurityPage = '/mine/accountSecurity'; // 账户安全

  static String myCollectionPage = '/mine/myCollection'; // 我的收藏

  static String updatePasswordPage = '/mine/updatePassword'; // 修改密码

  static String createPlanPage = '/plan/create';  // 创建计划页面

  static String imagePreviewPage = '/imagePreview'; // 图片预览页

  static String createNotePage = '/note/createNote'; // 创建便签页

  //静态方法
  static void configureRoutes(Router router) {//路由配置
  print(router);
    //找不到路由
    router.notFoundHandler = new Handler(
      handlerFunc: (BuildContext context,Map<String,List<String>> params){
        print('没有找到该页面');
        return Scaffold(
          appBar: CenterTitleAppBar.appBar(context, '404'),
          body: Center(
            child: Text('抱歉，没有找到该页面')
          ),
        );
      }
    );
    //整体配置
    router.define(homePage, handler: homeHander, transitionType: TransitionType.native); 
    router.define(loginPage, handler: loginHander); 
    router.define(registerPage, handler: registerHander);
    router.define(modifyPasswordPage, handler: modifyPasswordHandler, transitionType: TransitionType.fadeIn);
    router.define(stepPage, handler: stepPageHander);
    router.define(webviewPage, handler: webViewPageHander, transitionType: TransitionType.native);
    router.define(categoryPage, handler: categoryHander);
    router.define(settingPage, handler: settingHandler, transitionType: TransitionType.inFromRight);
    router.define(modifyUserInfoPage, handler: modifyUserInfoHandler, transitionType: TransitionType.inFromRight);
    router.define(accountSecurityPage, handler: accountSecurityHandler,  transitionType: TransitionType.inFromRight);
    router.define(myCollectionPage, handler: myCollectionHandler,  transitionType: TransitionType.inFromRight);
    router.define(updatePasswordPage, handler: updatePasswordHandler,  transitionType: TransitionType.inFromRight);
    router.define(createPlanPage, handler: createPlanHandler);
    router.define(imagePreviewPage, handler: imagePreviewHandler, transitionType: TransitionType.fadeIn);
    router.define(createNotePage, handler: createNoteHandler);
  }

}
