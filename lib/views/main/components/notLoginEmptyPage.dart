import 'package:demo/routes/applicationRouter.dart';
import 'package:demo/routes/routers.dart';
import 'package:demo/utils/adaptUtil.dart';
import 'package:flutter/material.dart';

class NotLoginEmptyPage extends StatefulWidget {
  NotLoginEmptyPage({Key key}) : super(key: key);

  @override
  _NotLoginEmptyPageState createState() => _NotLoginEmptyPageState();
}

class _NotLoginEmptyPageState extends State<NotLoginEmptyPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
          onTap: () {
            ApplicationRouter.router.navigateTo(context, Routes.loginPage);
          }, 
          child: SizedBox(
            width: Adapt.screenW() * 0.8,
            height: Adapt.px(500),
            child: Column(
              children: <Widget>[
                SizedBox(
                  child: Image.asset('assets/images/notLogin.png', fit: BoxFit.cover,),
                ),
                Text('你还未登录哟 ~ , 点击登录'),
              ],
            ),
          )
      ),
    );
  }
}