import 'package:demo/common/Global.dart';
import 'package:demo/routes/applicationRouter.dart';
import 'package:demo/utils/adaptUtil.dart';
import 'package:demo/views/main/information/categoryPage/categoryArticleList.dart';
import 'package:demo/views/main/information/searchPage/search.dart';
import 'package:flutter/material.dart';

List<Map<String, String>> articleCategory = [
  {
    "name": '推荐',
    "value": 'home'
  },
  {
     "name": '前端',
    "value": 'web'
  },
  {
     "name": 'java',
    "value": 'jave'
  },
   {
     "name": '数据库',
    "value": 'db'
  }
];

class CategoryPage extends StatefulWidget  {
  CategoryPage({Key key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> with SingleTickerProviderStateMixin {

  ScrollController _scrollViewController;
  TabController _tabController;
  List<Tab> _tabsList;
  List<CategoryAritcleList> _pageList;
  @override
  void initState() { 
    super.initState();
    _scrollViewController = ScrollController();
    List resultList = _setTabs();
    _tabsList = resultList[0];
    _pageList = resultList[1];
    _tabController = TabController(length: _tabsList.length, vsync: this);

    
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _scrollViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(IconData(0xe611, fontFamily: 'iconfont'), color: Colors.grey, size: 16,),
          onPressed: () {
            ApplicationRouter.router.pop(context);
          },
        ),
        title: SizedBox(
          width: Adapt.screenW() * 0.6,
          height: Adapt.px(60),
          child: FlatButton(
            color: Color.fromRGBO(180, 180, 180, 0.1),
            onPressed: () {
              showSearch(context: context, delegate: InformationSearchPage());
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))
            ), 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(IconData(0xe662, fontFamily: 'iconfont'), size: 14, ),
                Padding(padding: EdgeInsets.only(left: 10)),
                Text('搜索', style: TextStyle(fontSize: 14, color: Colors.grey),)
              ],
            )
          )
        ),
        elevation: 0.0,
        // bottomOpacity: 0,
        backgroundColor: Colors.white,
        bottom: TabBar(
          isScrollable: true,
          indicatorColor: Global.themeColor,
          labelColor: Colors.black,
          controller: _tabController,
          tabs: _tabsList
        ),
        // leading: Icon(Icons.ac_unit),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _pageList
      ),
    );
  }
}




List<List> _setTabs () {  
  List<Tab> tabs = [];
  List<CategoryAritcleList> pageList = [];
  articleCategory.forEach((item) {
    tabs.add(Tab(
      text: item['name'],
    ));
    pageList.add(CategoryAritcleList(item['value']));
  });
  return [tabs, pageList];
}