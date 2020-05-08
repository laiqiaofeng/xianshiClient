// 修改密码
import 'package:demo/common/Global.dart';
import 'package:demo/components/CenterTitleAppBar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:demo/http/http.dart';
import 'package:demo/provider/user.dart';
import 'package:demo/routes/applicationRouter.dart';
import 'package:demo/utils/adaptUtil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModifyPassword extends StatefulWidget {
  ModifyPassword({Key key}) : super(key: key);

  @override
  _ModifyPasswordState createState() => _ModifyPasswordState();
}

class _ModifyPasswordState extends State<ModifyPassword> {

  TextEditingController _oldPasswordController;
  TextEditingController _newPasswordController;
  FocusNode _focusNode;
  bool _isCorrect;

  @override
  void initState() {
    super.initState();
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _focusNode = FocusNode();
    _isCorrect = false;
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
      builder: (BuildContext context, userModel, Widget child) {
        String _password = userModel.user != null ? userModel.user.password : ''; 
        return Scaffold(
          appBar: CenterTitleAppBar.appBar(context, '修改密码'),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(_focusNode);
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: Form(
                autovalidate: true,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _oldPasswordController,
                      decoration: InputDecoration(
                        labelText: '旧密码',
                        hintText: '请输入旧密码',
                        // focusedBorder: UnderlineInputBorder(
                        //   borderSide: BorderSide(
                        //     color: Colors.blue
                        //   )
                        // ),
                      ),
                      validator: (String value) {
                        if (value == '') return '密码不能为空';
                        if (value != _password) { 
                          _isCorrect = false;
                          return '密码错误';
                        }
                        _isCorrect = true;
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _newPasswordController,
                      decoration: InputDecoration(
                        labelText: '新密码',
                        hintText: '请输入新密码'
                      ),
                      validator: (String value) {
                        if (value == '') return '密码不能为空';
                        if (value.length < 6) return '密码长度不能小于六位';
                        if (value == _oldPasswordController.text) return '新密码不能与旧密码相同';
                        return null;
                      },
                    ),
                    Builder(
                      builder: (BuildContext context) {
                        return Container(
                          margin: EdgeInsets.only(top: 30),
                          width: Adapt.screenW(),
                          height: Adapt.px(100),
                          child: FlatButton(
                            color: Colors.blue,
                            onPressed: () async {
                              if (Form.of(context).validate()) {
                                String id = userModel.user != null ? userModel.user.id : '';
                                Http.updatePassword(id, _newPasswordController.text).then((data) {
                                  // userModel.user.password = _newPasswordController.text;
                                  Global.profile.user.password = _newPasswordController.text;
                                  Global.saveProfile();
                                  Fluttertoast.showToast(
                                      msg: "修改成功",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.blueAccent,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                  ApplicationRouter.router.pop(context);
                                });
                              }
                            }, 
                            child: Text('确认修改密码', style: TextStyle(color: Colors.white, fontSize: 18),))
                        );
                      }
                    )
                  ],
                ),
              )
            ),
          )
        );
      }
    );
  }
}