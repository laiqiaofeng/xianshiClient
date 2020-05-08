import 'dart:collection';
import 'package:demo/common/Global.dart';
import 'package:dio/dio.dart';

// 定义一个拦截器, 缓存该缓存的http请求
class NetCache extends Interceptor {
  // 为确保迭代器顺序和对象插入时间一致顺序一致，使用LinkedHashMap
  // linkedHashMap 是一个按插入时间排序的 map
  var netCacheList = LinkedHashMap<String, CacheObject>();

  @override
  Future onRequest(RequestOptions options) async {
    // 如果配置中不缓存，直接返回options
    if (!Global.profile.cacheConfig.enable) return options;

    // refresh标记是否是"下拉刷新"
    bool refresh = options.extra["refresh"] == true;

   
    //如果是下拉刷新，先删除相关缓存
    if (refresh) {
      if (options.extra['list'] == true) {
        // 如果是列表， 所有url中包含当前path的缓存全部删除
        netCacheList.removeWhere((String key,  CacheObject v) => key.contains(options.path));
      }else {
        delete(options.path);
      }
      return options;

    }
      // 如果可以缓存并使用get方法
      if (options.extra['noCache'] != true && options.method.toLowerCase() == 'get') {
        // 如果设置了cacheKey，使用cacheKey， 否则使用uri
        String key = options.extra['cacheKey'] ?? options.uri.toString();
        // 查看是否已经缓存
        var ob = netCacheList[key];
        if (ob != null) {
          // 如果有缓存过， 查看是否过期
          if ((DateTime.now().millisecondsSinceEpoch - ob.timeStamp) / 1000 < Global.profile.cacheConfig.maxAge) {
            // 如果没有过期， 返回缓存数据
            return netCacheList[key].response;
          } else {
            // 如果过期， 删除缓存, 并不返回，继续请求服务器
            netCacheList.remove(key);
          }
        }
      }
      
      // return options;
  }


  @override
  Future onError(DioError err) async {
    // 错误状态不缓存
  }

  @override
  onResponse(Response response) async {
    // 如果启用缓存，将返回结果保存到缓存
    if (Global.profile.cacheConfig.enable) {
      _saveCache(response);
    }
  }

  _saveCache (Response obj) {
    RequestOptions options = obj.request;
    if (options.extra['noCache'] != true && options.method.toLowerCase() == 'get') {
      if (netCacheList.length > Global.profile.cacheConfig.maxCount) {
        // 删除最先缓存的数据
        netCacheList.remove(netCacheList.keys.first);
      }
      String key = options.extra['cacheKey'] ?? options.uri.toString();
      netCacheList[key] = CacheObject(obj);
    }
  }
  void delete (String key) {
    netCacheList.remove(key);
  }
  
}

class CacheObject {
  // 传入一个response 对象，并获取当前时间
  CacheObject(this.response) : timeStamp = DateTime.now().millisecondsSinceEpoch;

  int timeStamp;
  Response response;

  // 操作符重载函数，对比两个 CacheObject 实例 是会对比 hashCode
  @override
  bool operator ==(other) {
    return response.hashCode == other.hashCode;
  }
  // 将uri最为缓存key值
  @override
  int get hashCode => response.realUri.hashCode;
}