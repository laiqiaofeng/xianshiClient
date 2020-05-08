import 'dart:async';
import 'package:demo/event/event_model.dart';
import 'package:demo/event/event_bus.dart';
import 'package:demo/routes/applicationRouter.dart';
import 'package:demo/utils/adaptUtil.dart';
import './registerForm.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  FocusNode _blankNode;
  double _opacity;
  StreamSubscription _event;
  @override
  void initState() {
    super.initState();
    _blankNode = FocusNode();
    _opacity = 0;
    _event = ApplicationEvent.event.on<TextFieldFocus>().listen((event) {
      _opacity = event.isFocus ? 1 : 0;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(_blankNode);
        },
        child: SingleChildScrollView(
          child: Container(
            width: Adapt.screenW(),
            height: Adapt.screenH(),
            decoration: BoxDecoration(
              color: Colors.grey,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/register_background.jpg')
              )
            ),
            child: Stack(
              overflow: Overflow.clip,
              children: <Widget>[
                // 蒙层
                AnimatedOpacity(
                  duration: Duration(microseconds: 300),
                  opacity: _opacity,
                  child: Container(
                    width: Adapt.screenW(),
                    height: Adapt.screenH() - 140,
                    color: Color.fromRGBO(100, 100, 100, 0.3),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  height: Adapt.px(140),
                  child: SizedBox(
                    width: Adapt.screenW(),
                    height: Adapt.px(140),
                    child: AppBar(
                      elevation: 0,
                      bottomOpacity: 0,
                      leading: IconButton(
                        icon: Icon(IconData(0xe611, fontFamily: 'iconfont'), color: Colors.white, size: 16,),
                        onPressed: () {
                          ApplicationRouter.router.pop(context);
                        }
                      ),
                      backgroundColor: Color.fromRGBO(0, 0, 0, 1),
                      title: Text('用户注册'),
                      centerTitle: true
                    ),
                  ),
                ),
                RegisterForm()
              ],
            )
          )
        )
        ),
    );
  }
}