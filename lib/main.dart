import 'package:demo/http/http.dart';
import 'package:demo/common/Global.dart';
import 'package:demo/provider/theme.dart';
import 'package:demo/provider/user.dart';
import 'package:demo/views/login/login.dart';
import 'package:demo/views/main/note/createNote.dart';
import 'package:demo/views/main/plan/createPlan.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import './routes/routers.dart';
import './routes/applicationRouter.dart';
import './event/event_bus.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// 页面
import './views/introduce/stepPage.dart';
import './views/main/home.dart';


// 搜集错误日志

void collectLog(String line){
    // ... //收集日志
    Http.collectLog(message: line);
}

void reportErrorAndLog(FlutterErrorDetails details){
    // ... //上报错误和日志逻辑
}

FlutterErrorDetails makeDetails(Object obj, StackTrace stack){
    return FlutterErrorDetails(stack: stack);
}


void main () {
  // 先初始化Global 数据再加载myapp
  WidgetsFlutterBinding.ensureInitialized();
  // 强制竖屏
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  Global.init().then((e) => runApp(MyApp()));
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
}

final ThemeData myTheme = new ThemeData(
  accentColor: Colors.deepOrangeAccent,
  accentTextTheme: TextTheme(body1: TextStyle(color: Colors.amber)),
  fontFamily: 'text'
);


class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  _MyAppState ()  {
    final eventBus = new EventBus();
    ApplicationEvent.event = eventBus;
   
  }
  @override
  void initState()  {
    super.initState();
  }

  Widget showWelcomePage(bool isLogin) {
    print('有没有登录${isLogin}');
    // return CreateNote();
    return isLogin ? HomePage() : StepPage(hasBotton: true,);
  }
  @override
  Widget build(BuildContext context) {
    final router = Router();
    Routes.configureRoutes(router);
    ApplicationRouter.router = router;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ThemeModel()),
        ChangeNotifierProvider.value(value: UserModel()),
      ],
      child: Consumer2<ThemeModel, UserModel>(
        builder: (BuildContext context, themeModel, userModel, Widget child) {
          
          return MaterialApp(
            // title: '首页',
            themeMode: ThemeMode.system,
            debugShowCheckedModeBanner: false,
            color: Colors.white,
            localizationsDelegates: [
              // 本地化的代理类
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [
                const Locale('en', 'US'), // 美国英语
                const Locale('zh', 'CN'), // 中文简体
                //其它Locales
            ],
            locale: Locale('zh', 'CN'),
            // 指定主题
            theme: ThemeData(
              primaryColor: themeModel.theme,
              accentTextTheme: TextTheme(body1: TextStyle(color: Colors.amber)),
              fontFamily: 'text'
            ),
            // 指定启动页面
            home:  showWelcomePage(userModel.isLogin),
            // 默认路由
            initialRoute: '/',
            onGenerateRoute: ApplicationRouter.router.generator,
          );
        }
      ),
    );
  }
}
