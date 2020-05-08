import 'package:demo/common/Global.dart';
import 'package:demo/event/event_bus.dart';
import 'package:demo/event/event_model.dart';
import 'package:flutter/material.dart';
import 'package:demo/views/main/information/information.dart';
import 'package:demo/views/main/mine/mine.dart';
import 'package:demo/views/main/plan/plans.dart';
import 'package:demo/views/main/note/notes.dart';

class HomePage extends StatefulWidget {
  // var userInfo;
  HomePage( {Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  num _currentIndex = 0;
  bool _showNavButton = true;
  List<Widget> _tabsPage;

  @override
  initState() {
    super.initState();
    _tabsPage  = [InformationPage(), PlansPage(),  NotesPage(), MinePage()];
    ApplicationEvent.event.on<BottomNavVisible>().listen((event) {
      setState(() {
        _showNavButton = event.visible ?? true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         body: IndexedStack(
            index: _currentIndex,
            children: _tabsPage
          ),
         bottomNavigationBar: 
          _showNavButton 
          ? 
          BottomNavigationBar(
            //  selectedItemColor: Colors.blue,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            fixedColor: Global.themeColor,
            currentIndex: this._currentIndex,
            onTap: (index) {
              setState(() {
                this._currentIndex = index;
              });
            },
            items: _navList()
          )
          :
          null
       );
  }
  
}


List<dynamic> _navList () {
  List<Map<String, dynamic>> itemList = [
    {
      'title' : '资讯',
      'icon': {
         'active' : 0xe601,
      'default': 0xe771
      },
      'animation': null
    },
    {
      'title' : '计划',
      'icon': {
         'active' : 0xe648,
          'default': 0xe616
      },
      'animation': null
    },
    {
      'title' : '便签',
      'icon': {
         'active' : 0xe6d2,
          'default': 0xe6ee
      },
      'animation': null
    },
    {
      'title' : '我的',
      'icon': {
        'active' : 0xe607,
        'default': 0xe619
      },
      'animation': null
    }
  ];
  return itemList.map((item) => BottomNavigationBarItem(
      icon: Icon(IconData(item['icon']['default'] ,fontFamily: 'iconfont'), size: 18),
      activeIcon:  Icon(IconData(item['icon']['active'] ,fontFamily: 'iconfont'), size: 20),
      title: Text(item['title'], style: TextStyle(fontSize: 10),)
  )).toList();
}
