import 'dart:convert';

import 'package:demo/common/Global.dart';
import 'package:demo/components/TextField.dart';
import 'package:demo/http/http.dart';
import 'package:demo/provider/user.dart';
import 'package:demo/routes/applicationRouter.dart';
import 'package:demo/routes/routers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RegisterForm extends StatefulWidget {
  RegisterForm({Key key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  int _userSex;
  bool _isRepeat = false;
  bool _isBadPhoneNumber = false;
  TextEditingController _userPasswordController;
  TextEditingController _userNameController;
  TextEditingController _againPasswordController;
  TextEditingController _phoneNumberController;
  GlobalKey<FormState> _formKey;
  @override
  void initState() {
    super.initState();
    _userSex = 1;
    _userPasswordController = TextEditingController();
    _userNameController = TextEditingController();
    _againPasswordController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }
  Widget _buildRadio (String title, int value) {
    return SizedBox(
      width: 100,
      height: 30,
      child: RadioListTile(
        value: value, 
        groupValue: _userSex,
        title: Text(title, style: TextStyle(color: Colors.white),),
        onChanged: (var value) {
          setState(() {
            _userSex = value;
          });
        }),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('我触发了');
    return Consumer<UserModel>(
      builder: (BuildContext context, userModel, Widget child) {
        return Container(
          padding: EdgeInsets.only(top: 140, left: 40, right: 40),
          child: Form(
            key: _formKey,
            autovalidate: true,
            child: Column(
              children: <Widget>[
                MyTextFiled(
                  controller: _userNameController,
                  icon: IconData(0xea37, fontFamily: 'iconfont'),
                  labelText: "用户名",
                  autocorrect: true,
                  hintText: '请输入用户名',
                  onTap: () {
                    _isRepeat = false;
                  },
                  validator: (String value) {
                    if (_isRepeat) return '用户名重复';
                    if (value.trim() == '') return '用户名不能为空';
                    return null;  
                  },
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                MyTextFiled(
                  controller: _userPasswordController,
                  icon: IconData(0xe60c, fontFamily: 'iconfont'),
                  labelText: "密码",
                  hintText: '请输入用户密码',
                  validator: (String value) {
                    if (value == '') return '密码不能为空';
                    if (value.length < 6) return '密码不能少于六位数';
                    // if (value) {}
                    return null;
                  },
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                MyTextFiled(
                  controller: _againPasswordController,
                  icon: IconData(0xe679, fontFamily: 'iconfont'),
                  labelText: "确认密码",
                  hintText: '请再次输入用户密码', 
                  validator: (String value) {
                    if (value == '') return '再次输入密码';
                    if (value != _userPasswordController.value.text) return '密码不一致';
                    return null;
                  },
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              Container(
                // width: Adapt.px(500),
                // height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _buildRadio('男', 1),
                    _buildRadio('女', 2)
                  ]
                )
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              MyTextFiled(
                controller: _phoneNumberController,
                icon: IconData(0xe666, fontFamily: 'iconfont'),
                labelText: "手机号码",
                keyboardType: TextInputType.phone,
                hintText: '请输入11位手机号码',
                validator: (String value) {
                  RegExp exp = RegExp(
              r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
                  bool matched = exp.hasMatch(value);
                  if (value == '') return '手机号码不能为空';
                  if (!matched) {
                      return '手机号格式不正确';
                  }
                  return null;
                },
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              ButtonBar(
                children: [
                  FlatButton(
                    color: Colors.blueGrey,
                    onPressed: () {
                      // _phoneNumberController.clear();
                      // _againPasswordController.clear();
                      // _userNameController.clear();
                      // _userPasswordController.clear();
                      _userSex = 1;
                      var form = _formKey.currentState;
                      form.reset();
                    },
                    child: Text('重置', style: TextStyle(fontSize: 18),),
                  ),
                  FlatButton(
                    color: Colors.blueGrey,
                    onPressed: () {
                      var _form = _formKey.currentState;
                      if (!_form.validate()){
                        return;
                      }
                      String _userName = _userNameController.text.trim();
                      String _userPassword = _userPasswordController.text;
                      String _phoneNumber = _phoneNumberController.text;
                      Http.validateUserLogin(_userName, '').then((data) {
                        if (data == 'badPassword') {
                          _isRepeat = true;
                          _userNameController.clear();
                          _form.validate();
                        } else {
                          return Http.userRegister(userName: _userName, password: _userPassword, sex: _userSex, phone: _phoneNumber);
                        }
                      }).then((userInfo) async{
                        print('userInfo$userInfo');
                          if(userInfo == null) return;
                          userModel.user = userInfo;
                          userModel.notifyListeners();
                          ApplicationRouter.router.navigateTo(context, Routes.homePage, replace: true);
                      });
                      
                    },
                    child: Text('提交', style: TextStyle(fontSize: 18),),
                  )
                ]
              )
            ]
          ),
          )
        );
      },
    );
  }
}






