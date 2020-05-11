
import 'package:demo/common/Global.dart';
import 'package:demo/event/event_bus.dart';
import 'package:demo/event/event_model.dart';
import 'package:demo/http/http.dart';
import 'package:demo/provider/theme.dart';
import 'package:demo/provider/user.dart';
import 'package:demo/routes/applicationRouter.dart';
import 'package:demo/routes/routers.dart';
import 'package:demo/utils/adaptUtil.dart';
import 'package:demo/utils/checkLoginUtil.dart';
import 'package:demo/views/main/mine/components/Header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class ItemOptions {
  String title;
  Icon icon;
  bool isSignOut;
  GestureTapCallback onTap;
  ItemOptions({
    this.title,
    this.icon,
    this.isSignOut = false,
    this.onTap
  }) : assert(title != null), 
       assert(icon != null),
       assert(onTap != null);

  
}

class CardOptions {
  String title;
  int count = 0;
  Color color;
  CardOptions(this.title, this.color);
}

class MinePage extends StatefulWidget {
  MinePage({Key key}) : super(key: key);

  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  ScrollController _scrollController;
  List<ItemOptions> _itemList;
  double _offset;
  List<CardOptions> _cardList;
  @override
  void initState() {
    super.initState(); 
    _getCount();
    _offset = 0;
    _cardList = [
    CardOptions('计划数', Color(0xff101010)),
    CardOptions('便签数', Color(0xff101010)),
    CardOptions('分享数', Color(0xff101010))
  ];
    _scrollController = ScrollController();
    _itemList = [
      ItemOptions(title: '我的分享', icon: Icon(Icons.wallpaper, color: Colors.white,),
      onTap: () {
        CheckLogin.checkLogin(context, () {
          ApplicationRouter.router.navigateTo(context, Routes.myCollectionPage);
        });
      }),
      ItemOptions(title: '账户安全', icon: Icon(Icons.wallpaper, color: Colors.white,), 
      onTap: () {
        CheckLogin.checkLogin(context, () {
          ApplicationRouter.router.navigateTo(context, Routes.accountSecurityPage);
        });
      }),
      ItemOptions(title: '设置', icon: Icon(IconData(0xe605, fontFamily: 'iconfont'), color: Colors.white,),
      onTap: () {
        ApplicationRouter.router.navigateTo(context, Routes.settingPage);
      }),
      ItemOptions(title: '关于App', icon: Icon(IconData(0xe602, fontFamily: 'iconfont'), color: Colors.white,), onTap: () {
        ApplicationRouter.router.navigateTo(context, '${Routes.stepPage}?hasBotton=${true}');
      }),
      ItemOptions(title: '退出登录', icon: Icon(Icons.wallpaper, color: Colors.white,), isSignOut: true, 
      onTap: () {
        print('退出登录');
        Global.profile.user = null;
        Global.saveProfile();
        setState(() {
          
        });
      }),
    ];
    _scrollController.addListener(() {
      if (_scrollController.offset < 0) {
        setState(() {
          _offset = _scrollController.offset.abs();
        });
      } else if (_scrollController.offset > 0 && _scrollController.offset < Adapt.px(200)) {
        setState(() {
          _offset = -_scrollController.offset - 40;
        });
      }
    }); 

    ApplicationEvent.event.on<UpdateNoteAndPlanCount>().listen((event) {
      if (mounted) {
        _getCount();
      }
    });
    
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Future _getCount () async {
    print('现在在请求数量');
    var user = Global.profile.user;
    if (user != null) {
      Future.wait([
      Http.getPlanCount(user.id,  extra: {'onCache': true}),
      Http.getNoteCount(user.id, extra: {'onCache': true})
    ]).then((dataList){
      print('dataList$dataList');
      _cardList[0].count = dataList[0] is int ? dataList[0] : 0;
      _cardList[1].count = dataList[1] is int ? dataList[1] : 0;
      setState(() {
        
      });
    });
    }
  }
  @override
  Widget build(BuildContext context) {
    
    return Consumer<UserModel>(
      builder: (BuildContext context, userModel,  Widget child) {
        return Material(
          color: Global.bgColor,
          child: CustomScrollView(
            //滚动方向
            scrollDirection: Axis.vertical,
            //是否反转滚动方向
            reverse: false,
            //监听事件等等控制器
            controller: _scrollController,
            //true 的话 controller 一定要为null
            primary: false,
            //滑动效果，如阻尼效果等等
            physics: const BouncingScrollPhysics(),
            //滑动控件是否在头部上面滑过去
            shrinkWrap: false,
            //0到1之间，到顶部的距离
            anchor: 0.0,
            //“预加载”的区域,0.0 为关闭预加载
            cacheExtent: 0.0,
            slivers: <Widget>[
              SliverPersistentHeader(
                pinned: true,
                floating: true,
                delegate: MineHeader(
                  offset: _offset,
                  itemList: _cardList
                ),
              ),
              SliverPadding(padding: EdgeInsets.only(top: Adapt.px(20)),),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return  AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 30.0,
                        child: FadeInAnimation(
                          child: Card(
                            elevation: 0,
                            color: Color.fromRGBO(180, 180, 180, 0.6),
                            margin: _itemList[index].isSignOut ?
                            EdgeInsets.only(top: Adapt.px(80), left: Adapt.px(60), right: Adapt.px(60), bottom: Adapt.px(20))
                            :
                            EdgeInsets.only(top: Adapt.px(20), left: Adapt.px(60), right: Adapt.px(60), bottom: Adapt.px(10)),
                            child: SizedBox(
                              height: Adapt.px(120),
                              child: FlatButton(
                                onPressed: _itemList[index].onTap, 
                                child: !_itemList[index].isSignOut ?
                                  ListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    leading: _itemList[index].icon,
                                    title: Text("${_itemList[index].title}", style: TextStyle(color:  Colors.white, fontSize: 16),),
                                    trailing: Icon(IconData(0xe65e, fontFamily: 'iconfont'), color: Colors.white, size: 16,),
                                  )
                                  :
                                  Center(
                                    child: Text("${_itemList[index].title}", style: TextStyle(color: Colors.redAccent, fontSize: 20),)
                                  )
                              )
                            )
                          )
                        ),
                      ),
                    );
                  },
                  childCount: _itemList.length
                )
              ),
              SliverPadding(padding: EdgeInsets.only(top: 20)),
              /// 这个组件一般用于最后填充，展示需要的组件
              // SliverFillRemaining()         
            ]
          ),
        );
      },
    );
  }
}