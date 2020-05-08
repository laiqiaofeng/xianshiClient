

import 'package:demo/model/user_info.dart';
import 'package:demo/provider/profileChangeNotifier.dart';

class UserModel extends ProfileChangeNotifier {
  UserInfo get user => profile.user;

  // APP是否登录(如果有用户信息，则证明登录过)
  bool get isLogin => user != null;

  //用户信息发生变化，更新用户信息并通知依赖它的子孙Widgets更新
  set user(UserInfo user) {
    if (user?.userName != profile.user?.userName) {
      profile.lastLogin = profile.user?.userName;
      profile.user = user;
      print('用户信息发生改变');
      notifyListeners();
    }
  }
}