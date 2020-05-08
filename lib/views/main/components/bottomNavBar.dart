import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({Key key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: _navList()
    );
  }
}


class BottomNavBarItem extends StatefulWidget {
  Map<String, dynamic> item;
  BottomNavBarItem(this.item, {Key key}) : super(key: key);

  @override
  _BottomNavBarItemState createState() => _BottomNavBarItemState(this.item);
}

class _BottomNavBarItemState extends State<BottomNavBarItem> {
   Map<String, dynamic> item;
  _BottomNavBarItemState(this.item);
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(IconData(item['icon']['default'] ,fontFamily: 'iconfont'), size: 20),
      onPressed: () {
        
      }
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
  return itemList.map((item) => BottomNavBarItem(item)).toList();
}