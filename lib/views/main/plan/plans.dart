import 'package:demo/common/Global.dart';
import 'package:demo/event/event_bus.dart';
import 'package:demo/event/event_model.dart';
import 'package:demo/provider/user.dart';
import 'package:demo/routes/applicationRouter.dart';
import 'package:demo/routes/routers.dart';
import 'package:demo/utils/adaptUtil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/PlanList.dart';
import '../components/notLoginEmptyPage.dart';

/// 二楼示例页面
class PlansPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PlansPageState();
  }
}

class PlansPageState extends State<PlansPage>  with SingleTickerProviderStateMixin{
  TabController _tabController;

  String _planState; 
  bool _isLogin;
  ScrollController _scrollController;
  double _padding = 0.0;
  @override
  void initState() {
    super.initState();
    _planState = "underway";
    _scrollController = ScrollController();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController.addListener(() {
      double offset = _scrollController.offset;
      if (offset > 64) {
        offset = offset > 128 ? 128 : offset;
        setState(() {
          _padding = offset - 64;
        });
      }else {
        setState(() {
          _padding = 0;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
      builder: (BuildContext context, userModel, Widget child) {
        _isLogin =  userModel.isLogin;
        return !_isLogin ? 
          Scaffold(
            appBar: AppBar(
              title: Text('计划'),
              centerTitle: true,
            ),
            body: NotLoginEmptyPage(),
          )
          :
          Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              ApplicationRouter.router.navigateTo(context, Routes.createPlanPage);
            },
            child: Icon(Icons.add, size: 32,),
            backgroundColor: Global.themeColor,
            elevation: 10,
          ),
          body: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: false,
            //0到1之间，到顶部的距离
            anchor: 0.0,
            //“预加载”的区域,0.0 为关闭预加载
            cacheExtent: 100.0,
            slivers: <Widget>[
              SliverAppBar(
                floating: true,
                snap: true,
                pinned: true,
                stretch: false,
                elevation: 0,
                title: Text('计划', style: TextStyle(color: Colors.white),),
                centerTitle: true,
                iconTheme: IconThemeData(
                  color: Colors.white
                ),
                bottom: TabBar(
                  labelColor: Colors.white,
                  controller: _tabController,
                  indicatorPadding: EdgeInsets.only(left: 60, right: 60),
                  labelPadding: EdgeInsets.only(left: 20, right: 20),
                  indicatorColor: Global.assistThemeColor,
                  tabs: <Widget>[
                    Tab(text: '进行中'),
                    Tab(text: '已完成'),
                  ],
                  onTap: (int index) {
                    _planState = index == 0 ? 'underway' : 'finish';
                  },
                ),
                actions: <Widget>[
                  PopupMenuButton(
                    color: Colors.white,
                    offset: Offset(100, 100),
                    itemBuilder: (BuildContext context) {
                      return <PopupMenuItem<String>>[
                        selectView(Colors.black, '全部', 'AB'),
                        selectView(Colors.redAccent, '重要的', 'A'),
                        selectView(Colors.blueAccent, '轻松的', 'B'),
                      ];
                    },
                    onSelected: (String value) {
                      switch(value) {
                        case 'AB':
                          ApplicationEvent.event.fire(ChangePlanType(planType :'all'));
                          break;
                        case 'A':
                         ApplicationEvent.event.fire(ChangePlanType(planType :'important'));
                          break;
                        case 'B':
                         ApplicationEvent.event.fire(ChangePlanType(planType :'relaxed'));
                          break;
                        default:

                      }
                    },
                  )
                ],
              ),
              SliverPadding(padding: EdgeInsets.only(top: _padding)),
              SliverFillRemaining(
                child: TabBarView(
                  physics: PageScrollPhysics(),
                  controller: _tabController,
                  children: <Widget>[
                    PlanList( 'underway' , userId:  userModel.user.id),
                    PlanList( 'finish', userId: userModel.user.id,)
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}


class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar child;

  StickyTabBarDelegate({@required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: child,
    );
  }

  @override
  double get maxExtent => this.child.preferredSize.height;

  @override
  double get minExtent => this.child.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}


PopupMenuItem selectView(Color color, String text, String id) {
    return new PopupMenuItem<String>(
        value: id,
        child: Container(
          width: Adapt.px(140),
          child:  new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
                Material(
                  color: color,
                  elevation: 3,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: Adapt.px(30),
                    height: Adapt.px(30),
                  ),
                ),
                new Text(text, style: TextStyle(fontSize: 14),),
            ],
        ),
        )
    );
}
