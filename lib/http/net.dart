import 'dart:async';
import 'dart:io';

import 'package:demo/common/Global.dart';
import 'package:dio/adapter.dart';

import './api.dart';
import '../model/base.dart';
import 'package:dio/dio.dart';


Map<String, dynamic> optHeader = {
  'accept-language': 'zh-cn',
  'content-type': 'application/json'
};

BaseOptions options = new BaseOptions(
  connectTimeout: 3000, 
  headers: {
    "version": "flutter-app1.0.1",
    "name": "quxueba",
    "service": "node"
  },
  baseUrl: Api.getBaseApi(),
  responseType: ResponseType.json
);

Dio dio = new Dio(options);
class Net { 

  static void init() {
    // 添加缓存插件
    dio.interceptors.add(Global.netCache);
    // 设置用户token（可能为null，代表未登录）
    dio.options.headers[HttpHeaders.authorizationHeader] = Global.profile.token;

    // 在调试模式下需要抓包调试，所以我们使用代理，并禁用HTTPS证书校验
    if (!Global.isRelease) {
      print('这是在开发环境');
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
        client.findProxy = (uri) {
          return "PROXY 192.168.124.4:3000";
      };
        //代理工具会提供一个抓包的自签名证书，会通不过证书校验，所以我们禁用证书校验
      client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      };
    }
  }
  /**
   *
    url：请求地址
    data：请求参数
    cancelToken：取消标识
   * 
   */
  static Future getHttp(String url, {Map<String, dynamic> data, Map<String, dynamic> extra, CancelToken cancelToken}) async {  
    Response response;
    print('---------------------------------------');
    print("method: get, api: ${Api.getBaseApi()}$url");
    try {
      response = await dio.get(
        url, 
        queryParameters: data, 
        cancelToken: cancelToken,
        options: Options(
          extra: extra
        ),
        onReceiveProgress: (int count, int total) {
          // print('当前已接收$count');
          // print('总数$total');
        }
      );
      BaseData baseData = BaseData.fromJson(response.data);
      return baseData;
    } on DioError catch (err) {
      formatError(err);
      return err.message;
    }
  }

  static Future postHttp(String url, {var data,  Map<String, dynamic> extra}) async {
    Response response;
    print('---------------------------------------');
    print("method: post, api: ${Api.getBaseApi()}$url");
    try {
      response = await dio.post(
        url, 
        data: data,
        options: Options(
          extra: extra
        ),
        onReceiveProgress: (int count, int total) {
          // print('当前已接收$count');
          // print('总数$total');
        });
      BaseData baseData = BaseData.fromJson(response.data);
      return baseData;
    } on DioError catch(err) {
      formatError(err);
      return err.message;
    } 
  }
}


 /*
   * error统一处理
   */
  void formatError(DioError e) {
    if (e.type == DioErrorType.CONNECT_TIMEOUT) {
      // It occurs when url is opened timeout.
      print("连接超时");
    } else if (e.type == DioErrorType.SEND_TIMEOUT) {
      // It occurs when url is sent timeout.
      print("请求超时");
    } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
      //It occurs when receiving timeout
      print("响应超时");
    } else if (e.type == DioErrorType.RESPONSE) {
      // When the server response, but with a incorrect status, such as 404, 503...
      print("出现异常");
    } else if (e.type == DioErrorType.CANCEL) {
      // When the request is cancelled, dio will throw a error with this type.
      print("请求取消");
    } else {
      //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
      print("未知错误");
    }
  }