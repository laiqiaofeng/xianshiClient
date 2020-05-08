import 'dart:async';


class MyUtils {
  // 防抖
  static Function debounce (Function handler) {
    Timer timer = null;
    return () {
      if (timer != null) {
        timer.cancel();
      }
      timer = Timer(Duration(seconds: 1), () {
        handler();
      });
    };
  }

  
}