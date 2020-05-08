import 'dart:async';
import 'dart:convert';
import 'package:demo/common/Global.dart';
import 'package:demo/components/TextField.dart';
import 'package:demo/event/event_bus.dart';
import 'package:demo/event/event_model.dart';
import 'package:demo/http/http.dart';
import 'package:demo/model/user_info.dart';
import 'package:demo/routes/applicationRouter.dart';
import 'package:demo/routes/routers.dart';
import 'package:demo/utils/adaptUtil.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String _userName;
  String _userPassword;
  GlobalKey<FormState> _formKey;
  TextEditingController _userNameController;
  TextEditingController _passwordController;
  bool _userNameFocus = false;
  double _cardSize = Adapt.px(600);
  StreamSubscription _event;
  bool _passwordVisible;
  bool _notFoundUser = false;
  bool _badPassword = false;
  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _formKey = new GlobalKey<FormState>();
    _userNameController = TextEditingController();
    _passwordController = TextEditingController();
    _event = ApplicationEvent.event.on<TextFieldFocus>().listen((event) {
      _cardSize = event.cardSize;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
    _event.cancel();
  }

  void _submit () {
    var _form = _formKey.currentState;
    if ( !_form.validate() ) return;
    String userName = _userNameController.value.text.trim();
    String password = _passwordController.value.text;
    Http.validateUserLogin(userName, password).then((data) {
      print('该data是$data');
      if (data == null) return;
      switch (data) {
        case 'notFoundUser':
          this._notFoundUser = true;
          _userNameController.clear();
          _form.validate();
          break;
        case 'badPassword': 
          _badPassword = true;
          _passwordController.clear();
          _form.validate();
          break;
        default:
          Http.getUserInfo(data).then((userInfo) async {
            Global.profile.user = userInfo;
            Global.saveProfile();
            ApplicationRouter.router.navigateTo(context, Routes.homePage, replace: true);
          });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      // height: _cardSize,
      width: _cardSize,
      child: Card(
          color: Color.fromRGBO(100, 100, 100, 0.3),
          elevation: 1,
          child: Padding(padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              // autovalidate: true,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  MyTextFiled(
                    autocorrect: true,
                    controller: _userNameController,
                    icon: IconData(0xea37, fontFamily: 'iconfont'),
                    labelText: "用户名",
                    hintText: '请输入用户名',
                    validator: (String value) {
                      if (_notFoundUser) return '没有该用户';
                      return value == '' ? '用户名不能为空' : null;
                    },
                    onTap: () {
                      ApplicationEvent.event.fire(TextFieldFocus(true, Adapt.screenW()));
                      _userNameFocus = true;
                      _notFoundUser = false;
                    },
                  ),
                  Column(
                    children: <Widget>[
                      MyTextFiled(
                        controller: _passwordController,
                        icon: IconData(0xe60c, fontFamily: 'iconfont'),
                        obscureText: !_passwordVisible,
                        validator: (String value) {
                          if (_badPassword) return '密码错误, 请重新输入';
                          return value == '' ? '密码不能为空' : null;
                        },
                        suffixIcon: IconButton(
                          icon: Icon(IconData(_passwordVisible ? 0xe608 : 0xe612, fontFamily: 'iconfont'), color: Colors.white, size: 20,),
                          onPressed: () {
                            _passwordVisible = !_passwordVisible;
                          },
                        ),
                        labelText: "密码",
                        hintText: '请输入密码',
                        onTap: () {
                          ApplicationEvent.event.fire(TextFieldFocus(true, Adapt.screenW()));
                          _badPassword = false;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton(
                            child: Text('忘记密码', style: TextStyle(color: Colors.blue),),
                            onPressed: () {

                            },
                          )
                        ] 
                      ),
                    ],
                  ),
                  SizedBox(
                    width: Adapt.px(500),
                    height: Adapt.px(100),
                    child: RaisedButton(
                      child: Text('登录', style: TextStyle(
                        fontSize: 18,
                        color: Colors.white
                      ),),
                      color: Colors.blueGrey,
                      onPressed: _submit,
                    ),
                  )
                ]
              ),
            )
          ),
        ),
    );
  }
}


