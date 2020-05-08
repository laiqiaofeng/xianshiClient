class Api {
  static const String RELEASE_URL = 'http://39.97.255.65:3000/'; // 服务器地址

  static const String TEST_URL = 'http://rap2.taobao.org:38080/app/mock/239177/'; // 测试地址

  static const String COLLECT_LOG = 'log/collectLog'; // 搜集日志

  static const String GET_CSDB_DATA = 'csdn/articles'; // 获取CSDN文章

  static const String GET_CSDN_SWIPER = 'csdn/swiper'; // 获取csdn的轮播图

  static const String GET_CSDN_HOT = 'csdn/soHotWord'; // 获取csdn 热词

  static const String GET_BAIDU_TIPS = 'baidu/searchTips'; // 获取百度搜索提示词条

  static const String VALIDATE_USER_LOGIN = 'user/validateLogin'; // 校验用户登录

  static const String VALIDATE_PHONE = 'user/validatePhone'; // 校验用户注册电话号码
  
  static const String GET_USER_INFO = 'user/getUserinfo'; // 获取用户信息api

  static const String USER_REGISTER = 'user/register'; // 用户注册

  static const String MODIFY_USER_INFO = 'user/modifyUserInfo'; // 修改用户信息

  static const String UPDATE_USER_PASSWORD = 'user/updatePassword'; // 修改用户密码

  static const String GET_PLANS = 'plan/planList'; // 获取计划列表

  static const String CREATE_PLAN = 'plan/createPlan'; //  创建计划

  static const String DELETE_PLAN = 'plan/deletePlan'; // 删除计划

  static const String UPDATE_PLAN = 'plan/updatePlan'; // 更新状态 

  static const String CREATE_NOTE =  'note/createNote'; // 创建便签

  static const String DELETE_NOTE = 'note/deleteNote'; // 删除便签

  static const String GET_NOTE_LIST = 'note/getNoteList'; // 获取便签列表

  static const String GET_NOTE_COUNT = 'note/getNoteCount'; // 获取note数量

  static const String GET_PLAN_COUNT = 'plan/getPlanCount'; // 获取plan数量

  static const String UPLOAD = 'upload'; // 上传


  static String getBaseApi () {
    bool _inProduction = const bool.fromEnvironment("dart.vm.product");
    // String _baseUrl = _inProduction ? RELEASE_URL : TEST_URL;
    String _baseUrl = RELEASE_URL;
    return _baseUrl;
  }
}