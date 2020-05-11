
import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo/event/event_bus.dart';
import 'package:demo/event/event_model.dart';
import 'package:demo/provider/user.dart';
import 'package:demo/routes/applicationRouter.dart';
import 'package:demo/routes/routers.dart';
import 'package:demo/utils/adaptUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';

/// 二楼视图
class SecondFloorWidget extends StatefulWidget {
  // Header连接通知器
  final LinkHeaderNotifier linkNotifier;
  // 二楼开启状态
  final ValueNotifier<bool> secondFloorOpen;

  const SecondFloorWidget(this.linkNotifier, this.secondFloorOpen, {Key key})
      : super(key: key);

  @override
  SecondFloorWidgetState createState() {
    return SecondFloorWidgetState();
  }
}

class SecondFloorWidgetState extends State<SecondFloorWidget> {
  // 触发二楼高度
  final double _openSecondFloorExtent = 100.0;
  // 指示器值
  double _indicatorValue = 0.0;
  // 二楼高度
  double _secondFloor = 0.0;
  // 显示展开收起动画
  bool _toggleAnimation = true;
  Duration _toggleAnimationDuration = Duration(milliseconds: 300);
  // 二楼是否打开
  bool _isOpen = false;

  // 背景
  String _backgroundImgUrl;

  // 是否有个性签名
  bool _hasSignature = false;

  String _signature;



  String _defaultUrl = 'assets/images/loading_background.jpg';
  RefreshMode get _refreshState => widget.linkNotifier.refreshState;
  double get _pulledExtent => widget.linkNotifier.pulledExtent;

  @override
  void initState() {
    super.initState();
    widget.linkNotifier.addListener(onLinkNotify);
  }

  void onLinkNotify() {
    setState(() {
      if (_refreshState == RefreshMode.armed ||
          _refreshState == RefreshMode.refresh) {
        _indicatorValue = null;
        // 判断是否到展开二楼
        if (widget.secondFloorOpen.value && !_toggleAnimation) {
          _isOpen = true;
          _secondFloor = Adapt.screenH();
          _toggleAnimation = true;
          Future.delayed(_toggleAnimationDuration, () {
            if (mounted) {
              setState(() {
                _toggleAnimation = false;
              });
            }
          });
        }
      } else if (_refreshState == RefreshMode.refreshed ||
          _refreshState == RefreshMode.done) {
        _indicatorValue = 1.0;
      } else {
        if (_refreshState == RefreshMode.inactive) {
          _indicatorValue = 0.0;
          _toggleAnimation = true;
          Future.delayed(_toggleAnimationDuration, () {
            if (mounted) {
              setState(() {
                _toggleAnimation = false;
              });
            }
          });
        } else {
          double indicatorValue = _pulledExtent / 70.0 * 0.8;
          _indicatorValue = indicatorValue < 0.8 ? indicatorValue : 0.8;
          // 判断是否到达打开二楼高度
          if (_refreshState == RefreshMode.drag) {
            if (_pulledExtent >= _openSecondFloorExtent) {
              widget.secondFloorOpen.value = true;
            } else {
              widget.secondFloorOpen.value = false;
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserModel>(context).user;
    _signature = user != null ? user.signature : '还没有个性签名哟, 点击前往设置 ~~';
    _backgroundImgUrl = user != null ? user.bannerUrl : 'assets/images/loading_background.jpg';
    return WillPopScope(
      onWillPop: () {
        if (_isOpen) {
          setState(() {
            _isOpen = false;
            _toggleAnimation = true;
            Future.delayed(_toggleAnimationDuration, () {
              if (mounted) {
                setState(() {
                  _toggleAnimation = false;
                });
              }
            });
          });
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: GestureDetector(
        onVerticalDragUpdate: (DragUpdateDetails details) {
          double dy = details.delta.dy;
          if (dy < 0 && _secondFloor <= Adapt.screenH()) {
            setState(() {
            _secondFloor += dy;
            });
            if (_secondFloor < Adapt.screenH() - 180) {
                _isOpen = false;
                ApplicationEvent.event.fire(BottomNavVisible(true));
              if (_isOpen) {
                // ApplicationRouter.router.pop(context);
              }
            }
          }
        },
        onVerticalDragEnd: (DragEndDetails dateil) {
          setState(() {
            _secondFloor = Adapt.screenH();
          });
        },
        child: AnimatedContainer(
          height: _isOpen
              ? _secondFloor
              : _refreshState == RefreshMode.inactive ? 0.0 : _pulledExtent,
          color: Colors.white,
          duration: _toggleAnimation
              ? _toggleAnimationDuration
              : Duration(milliseconds: 300),
          child: Stack(
            children: <Widget>[
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: _backgroundImgUrl.startsWith('http') ? 
                    CachedNetworkImage(
                        imageUrl: _backgroundImgUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Image.asset(_defaultUrl, fit: BoxFit.cover,),
                    )
                    :
                    Image.asset(_backgroundImgUrl, fit: BoxFit.cover,), 
                ),
              ),
              // _isOpen
              //     ? AppBar(
              //         backgroundColor: Color.fromRGBO(100, 100, 100, 0.3),
              //         elevation: 0.0,
              //       )
              //     : Container(),
              Positioned(
                top: 100,
                left: 0,
                right: 0,
                child: Material(
                  color: Color.fromRGBO(3, 3, 3, 0.1),
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {
                      ApplicationRouter.router.navigateTo(context, Routes.modifyUserInfoPage);
                    },
                    child: AnimatedOpacity(
                      opacity: _isOpen ? 1 : 0, 
                      duration: _toggleAnimation
                        ? _toggleAnimationDuration
                        : Duration(milliseconds: 300),
                      child:  Center(
                        child: Container(
                          // height: 300,
                          margin: EdgeInsets.all(20),
                          padding: EdgeInsets.all(20),
                          alignment: Alignment.center,
                          width: double.infinity,
                          child: Text("$_signature", style: TextStyle(fontFamily: "雪云体", color: Colors.white, fontSize: 32),),
                        ),
                      ),
                    )
                  ),
                )
              ),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: AnimatedCrossFade(
                  firstChild: Center(
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                        bottom: 20.0,
                        top: 10.0,
                      ),
                      width: 24.0,
                      height: 24.0,
                      child: Offstage(
                        offstage: widget.secondFloorOpen.value,
                        child: CircularProgressIndicator(
                          value: _indicatorValue,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                          strokeWidth: 2.4,
                        ),
                      ),
                    ),
                  ),
                  secondChild: Center(
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                        bottom: 20.0,
                        top: 10.0,
                      ),
                      child: Offstage(
                        offstage: !widget.secondFloorOpen.value,
                        child: Text(
                          '欢迎来到2楼',
                          style: TextStyle(fontSize: 18.0, color: Colors.white, fontFamily: "雪云体"),
                        ),
                      ),
                    ),
                  ),
                  crossFadeState: widget.secondFloorOpen.value
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: Duration(milliseconds: 300),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}