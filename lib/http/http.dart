import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http_parser/http_parser.dart';
import 'package:demo/model/base.dart';
import 'package:dio/dio.dart';
import './net.dart';
import './api.dart';

import '../model/user_info.dart';

class Http {

  /*
   * COLLECT_LOG
   * collectLog 搜集日志
   * 
   */
  static Future collectLog ({String message}) async {
    var response = await Net.postHttp(Api.COLLECT_LOG, data: {"msg": message});
    return response.data;
  }

  /*
   * getUserInfo 获取用户信息 返回null或userInfo
   * @param params Map<String, dynamic> 用户名： userName，用户密码: userPassword
   * @return Future 
   */
  static Future getUserInfo (id) async {
    var response = await Net.getHttp(Api.GET_USER_INFO, data: {
      "id": id
    });
      UserInfo userInfo = UserInfo.fromJson(response.data);
    try {
      print('userInfo是${response.data}');
      return userInfo;
    }catch (e) {
      return response.ret.msg;
    } 
  }

  /*
   * getCsdnArticles 获取csdn的文章， 默认是获取推荐文章
   * @param category <String> 文章种类 default 'home'
   * @return Future 
   */
  static Future getCsdnArticles({String category = 'home', Map<String, dynamic> extra}) async {
    // type=more&category=game&shown_offset=0
    var response = await Net.getHttp(Api.GET_CSDB_DATA, data: {
      'type': 'more',
      'category': category,
      'shown_offset': 0
    },
    extra: extra);
    return response.data;
  }

  /*
   * getCsdnSwiper 获取csdn的首页轮播图 
   * @return Future 
   */
  static Future getCsdnSwiper() async {
    // type=more&category=game&shown_offset=0
    BaseData response = await Net.getHttp(Api.GET_CSDN_SWIPER);
    return response.data;
  }

   /*
   * getCsdnSoHot 获取csdn的搜索推荐热词 
   * @return Future 
   */
  static Future getCsdnSoHot () async {
    BaseData response = await Net.getHttp(Api.GET_CSDN_HOT);
    return response.data;
  }

   /*
   * getCsdnSoHot 获取csdn的搜索推荐热词 
   * @return Future 
   */
  static Future getDaiduSearchTips ({String query}) async {
    BaseData response = await Net.getHttp(Api.GET_BAIDU_TIPS, data: {
      "query": query
    });
    return response.data;
  }

  /*
   * 用户登录, 校验用户名和密码
   */
  static Future validateUserLogin (String userName, String password) async {
    BaseData responseData = await Net.postHttp(Api.VALIDATE_USER_LOGIN, data: {
      "userName": userName,
      "password": password
    });
    try {
      var userId = responseData.data;
      return userId;
    } catch (err) {
      // return err;
      // print(R);
    }
  }
  // 用户注册
  static Future userRegister ({String userName, String password, int sex = 1, String phone }) async {
    BaseData responseData = await Net.postHttp(Api.USER_REGISTER, data: {
      "userName": userName,
      "password": password,
      "sex": sex,
      "phone": phone
    });
    try {
      UserInfo userInfo = UserInfo.fromJson(responseData.data);
      return userInfo;
    }catch (e) {
      return responseData.ret.msg;
    } 
  }

  // 验证电话号码是否重复
  static Future validatePhoneNumber (String phoneNumber) async {
    BaseData response = await Net.getHttp(Api.VALIDATE_PHONE, data: {
      "phone": phoneNumber
    });
    try {
      var id = response.data;
      return id;
    } catch (err) {
      print('发生错误');
    }
  }

  // 修改用户信息
  static Future modifyUserInfo (String id, Map<String, dynamic> userInfo) async {
    BaseData response = await Net.postHttp(Api.MODIFY_USER_INFO, data: {
      "id": id,
      "userIndo": userInfo
    }, extra: {
      "noCache": true
    });
    try {
      UserInfo userInfo = UserInfo.fromJson(response.data);
      return userInfo;
    } catch (err) {
      print('发生错误');
    }
  }

  // 修改密码
  static Future updatePassword (String id, String newPassword) async {
    BaseData response = await Net.getHttp(Api.UPDATE_USER_PASSWORD, data: {
      "id": id,
      "newPassword": newPassword
    }, extra: {
      "noCache": true
    });

    try {
      var msg = response.data;
      return msg;
    } 
    catch (err) {
      print(err);
    }
  }

  // 获取计划列表
  static Future getPlanList (String userId, int pageIndex, int pageSize, String state, String planType, {Map<String, dynamic> extra}) async {
    BaseData response = await Net.getHttp(Api.GET_PLANS, data: {
      "userId": userId,
      "pageIndex":  pageIndex,
      "pageSize": pageSize,
      "planState": state,
      "planType": planType
    }, extra: extra);

    try {
      var planList = response.data;
      return planList;
    } 
    catch (err) {
      print(err);
    }
  }

  // 创建计划
  static Future createPlan ({
    @required String userId,
    @required String name,
    String remindDateTime = '',
    @required List<String> targetList,
    @required String type 
    }) async {

    var response = await Net.postHttp(Api.CREATE_PLAN, data: {
      "userId" : userId,
      "name": name,
      "remindDateTime":  remindDateTime,
      "type": type,
      "targetList": targetList
    });

    try {
      var id = response.data;
      return id;
    } 
    catch (err) {
      print(err);
    }
  }

  // 删除计划
  static Future dalatePlan  (
    String id,
    { Map<String, dynamic> extra}
  ) async {
    print('这个id是$id');
    var response = await Net.postHttp(Api.DELETE_PLAN, data: {
      "id": id
    }, extra: extra);

    try {
      var data = response.data;
      return data;
    } 
    catch (err) {
      print(err);
    }
  }

  // 更新计划
  static Future updatePlan (String id, Map<String, dynamic> updateData, { Map<String, dynamic> extra}) async {
    var response = await Net.postHttp(Api.UPDATE_PLAN, data: {
      "id": id,
      "updateData": updateData
    });

    try {
      var data = response.data;
      return data;
    } 
    catch (err) {
      print(err);
    }
  }
  
  // 创建便签
  static Future createNote ({ 
    @required String userId,
    @required String content,
    @required File image,
    @required double heigth,
    @required Color color,
    @required bool showElevation,
    @required bool showFadeShadow,
    Map<String, dynamic> extra
  }) async {
    var file;
    if (image != null) {
      String path = image.path;
      print('正常path是$path');
      String name = path.substring(path.indexOf('/') + 1, path.length);
      String suffix = path.substring(path.lastIndexOf('.') + 1, path.length);
      file = await MultipartFile.fromFile(path, filename: name, contentType:  MediaType.parse("image/$suffix"));
      
    }
    
    FormData formData = FormData.fromMap({
      "file": file,
      "userId": userId,
      "content": content,
      "height": heigth,
      "color": color.value,
      "showElevation": showElevation,
      "showFadeShadow": showFadeShadow
    });
    var response = await Net.postHttp(Api.CREATE_NOTE, data: formData);

    try {
      var data = response.data;
      return data;
    } 
    catch (err) {
      print(err);
    }
  }

  // 获取便签列表
  static Future getNoteList (String userId, {int pageIndex, int pageSize, Map<String, dynamic> extra}) async {
    var response = await Net.getHttp(Api.GET_NOTE_LIST, data: {
      "userId": userId,
      "pageIndex":  pageIndex,
      "pageSize": pageSize,
    }, extra: extra);

    try {
      var data = response.data;
      return data;
    } 
    catch (err) {
      print(err);
    }
  }

  // 删除便签
  static Future deleteNote (String noteId, String imgUrl) async {
    var response = await Net.postHttp(Api.DELETE_NOTE, data: {
      "noteId": noteId,
      "imgUrl": imgUrl
    });

    try {
      var msg = response.data;
      return msg;
    } 
    catch (err) {
      print(err);
    }
  }

  // 获取plan数量
  static Future getPlanCount (String userId,  {Map<String, dynamic> extra}) async {
    var response = await Net.getHttp(Api.GET_PLAN_COUNT, data: {
      "userId": userId,
    });

    try {
      var count = response.data;
      return count;
    } 
    catch (err) {
      print(err);
    }
  }

  // 获取note数量
  static Future getNoteCount (String userId, {Map<String, dynamic> extra}) async {
    var response = await Net.getHttp(Api.GET_NOTE_COUNT, data: {
      "userId": userId,
    }, extra: extra);

    try {
      var count = response.data;
      return count;
    } 
    catch (err) {
      print(err);
    }
  }

  // 上传
  static Future upload ({@required File image, String id, String tag, String type = 'user'}) async {
    String path = image.path;
    String name = path.substring(path.indexOf('/') + 1, path.length);
    String suffix = path.substring(path.lastIndexOf('.') + 1, path.length);

    print("file$suffix");
    var file = await MultipartFile.fromFile(path, filename: name, contentType:  MediaType.parse("image/$suffix"));
    FormData formData = FormData.fromMap({
      "file": file,
      "id": id,
      "tag": tag,
      "type": type
    });

    try {
      var response = await Net.postHttp(Api.UPLOAD, data: formData);
      if (type == 'user'){
        UserInfo userInfo = UserInfo.fromJson(response.data);
        return userInfo;
      } {
        String url = response.data;
        return url;
      }
    } 
    catch (err) {
      print(err);
    }
  }
}