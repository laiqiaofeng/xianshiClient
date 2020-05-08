import 'dart:async';

import 'package:demo/event/event_bus.dart';
import 'package:demo/event/event_model.dart';
import 'package:demo/routes/applicationRouter.dart';
import 'package:demo/routes/routers.dart';
import 'package:demo/utils/adaptUtil.dart';
import 'package:flutter/material.dart';
import './loginForm.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  ScrollController _scrollController;
  FocusNode _blankNode;
  bool _isShowLogo;
  Animation _animation;
  AnimationController  _animationController;
  double _opacity;
  double _logoOpacity;
  StreamSubscription _event;
  @override
  void initState() {
    super.initState();
    _opacity = 0;
    _logoOpacity = 1;
    _isShowLogo = true;
    _scrollController = ScrollController();
    _blankNode = FocusNode();
    _animationController =  AnimationController(
        duration: const Duration(microseconds: 300), reverseDuration: const Duration(microseconds: 300), vsync: this);
    _animation= CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animation = Tween(begin: Adapt.px(380), end: Adapt.px(140)).animate(_animationController);
    _event = ApplicationEvent.event.on<TextFieldFocus>().listen((event) {
      _isShowLogo = !event.isFocus;
        if (event.isFocus) {
          _animationController.forward();
        }else {
          _animationController.reverse();
        }
        _opacity = event.isFocus ? 1 : 0;
        _logoOpacity = event.isFocus ? 0 : 1;
      // setState(() {
      //   // this._isShowLogo = !event.isFocus;
      //   // if (event.isFocus) {
      //   //   print('这是正着放');
      //   //   _animationController.forward(from: 150);
      //   // }else {
      //   //   print('这是反着放');
      //   //   _animationController.reverse();
      //   // }
      //   // _opacity = event.isFocus ? 1 : 0;
      // });
    });
  }

  @override
  void dispose() { 
    super.dispose();
    _scrollController.dispose();
    _blankNode.dispose();
    _animationController.dispose();
    _event.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SingleChildScrollView(
        controller: _scrollController,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(_blankNode);
              ApplicationEvent.event.fire(TextFieldFocus(false, Adapt.px(600)));
              setState(() {
                _opacity = 0;
              });
            },
            child: SizedBox(
            height: Adapt.screenH(),
            width: Adapt.screenW(),
            child: Stack(
              children: <Widget>[
                Container(
                  height: Adapt.screenH(),
                  width: Adapt.screenH(),
                  decoration: new BoxDecoration(
                    color: Colors.grey,
                    image: DecorationImage(
                      image: AssetImage('assets/images/login_background.jpg'),
                      fit: BoxFit.cover
                    )
                  )
                ),
                AnimatedOpacity(
                  duration: Duration(microseconds: 300),
                  opacity: _opacity,
                  child: Container(
                    height: Adapt.screenH(),
                    width: Adapt.screenH(),
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                  ),
                ),
                SizedBox(
                  width: Adapt.screenW(),
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (BuildContext context, Widget child) {
                      return Stack(
                        children: <Widget>[
                          Positioned(
                            top: 0,
                            left: 0,
                            child: SizedBox(
                              width: Adapt.screenW(),
                              height: Adapt.px(170),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  FlatButton(
                                    child: Text('注册', style: TextStyle(color: Colors.white, fontSize: 18),),
                                    onPressed: () {
                                      ApplicationRouter.router.navigateTo(context, Routes.registerPage);
                                    },
                                  )
                                ],
                              ),
                            )
                          ),
                          Positioned(
                            top: Adapt.px(220),
                            child: AnimatedOpacity(
                              opacity: _logoOpacity,
                              curve: Curves.easeIn,
                              duration: Duration(microseconds: 300),
                              child: SizedBox(
                                width: Adapt.screenW(),
                                child: Center(
                                  child: Image.asset('assets/icons/appIcon_line.png', width: 60, height: 60),
                                )
                              ),
                            )
                          ),
                          Positioned(
                            top: _animation.value,
                            child: SizedBox(
                              width: Adapt.screenW(),
                              child: Center(
                                child: LoginForm(),
                              )
                            )
                          )
                        ],
                      );
                    },
                  )
                )
              ] 
            ),
          ),
        ) 
      ) 
    );
  }
}