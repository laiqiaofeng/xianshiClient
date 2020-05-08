import 'package:demo/common/Global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../../routes/applicationRouter.dart';



class StepPage extends StatefulWidget {
  bool hasBotton;
  StepPage({Key key, @required this.hasBotton}) : super(key: key);
  @override
  _StepPageState createState() => _StepPageState();
}

class _StepPageState extends State<StepPage> {

  List<PageViewModel> pages;

  List<Widget> _pages = List(3);
  
  @override
  void initState() {
    super.initState();
    pages = [
      PageViewModel(
          const Color(0xFFcd344f),
          //'assets/mountain.png',
          'assets/icons/developer.png',
          '关于闲时开发人员',
          '''【闲时】 是由赖乔锋（一名前端小菜鸡）,用业余时间开发的一款,用于指定计划的app,目的很简单, 用来学习flutter这个跨平台UI框架''',
          false
          ),
      PageViewModel(
          const Color(0xFF638de3),
          //'assets/world.png',
          'assets/icons/appIcon.png',
          '关于闲时功能',
          '''
          1. 查看IT行业的资讯（内容来自csdn）
          2. 指定学习或工作计划
          3. 制作小便签
          ''',
          false
          ),
      PageViewModel(
        const Color(0xFFFF682D),
        'assets/icons/expect.png',
        '关于期望',
        '''保住头发''',
        widget.hasBotton ? true : false
      ),
    ];
    for(int i = 0; i < pages.length; i ++) {
      print('这是一个hasBotton${widget.hasBotton}');
      this._pages[i] = Page(pages[i]);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: ,
      body: Swiper(
        index: 0,
        layout: SwiperLayout.DEFAULT,
        itemCount: this._pages.length,
        itemBuilder: (BuildContext context,int index){
          return this._pages[index];
        },
        loop: false,
        pagination: SwiperPagination(),
        control: SwiperControl(
          size: 0.0
        ),
      ),
    );
  }
}




class Page extends StatefulWidget {
  PageViewModel pageViewModel;
  Page(this.pageViewModel, {Key key}) : super(key:key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          color: widget.pageViewModel.color,
        ),
        Column(
          verticalDirection: VerticalDirection.down,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(10.0),),
            Image.asset(widget.pageViewModel.heroAssetPath, width: 100, height: 100,),
            Text(widget.pageViewModel.title, style: TextStyle(fontSize: 24),),
            Padding(padding: EdgeInsets.all(30),
            child: Text(widget.pageViewModel.body,  style: TextStyle(fontSize: 14, letterSpacing: 2, ), softWrap: true,),  ),
            !widget.pageViewModel.hasBotton ? Text('') : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: 20)),
                RaisedButton(
                  color: Global.themeColor,
                  textColor: Colors.white,
                  child: Text('登录体验'),
                  onPressed:()  async {
                    ApplicationRouter.router.navigateTo(context, '/login', replace: true);
                  }
                ),
                RaisedButton(
                  child: Text('随便看看'),
                  onPressed:()  async {
                    ApplicationRouter.router.navigateTo(context, '/home', replace: true);
                  }
                ),
                 Padding(padding: EdgeInsets.only(right: 20)),
              ]
            ),
            Padding(padding: EdgeInsets.all(40.0),),
          ]
        )
      ]
    );
  }
}

class PageViewModel {
  final Color color;
  final String heroAssetPath;
  final String title;
  final String body;
  final bool hasBotton;
  const PageViewModel(
    this.color,
    this.heroAssetPath,
    this.title,
    this.body,
    this.hasBotton
  );
}