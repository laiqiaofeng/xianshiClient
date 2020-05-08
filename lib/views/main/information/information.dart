import 'package:demo/common/Global.dart';
import 'package:demo/event/event_model.dart';
import 'package:demo/model/article.dart';
import 'package:demo/routes/applicationRouter.dart';
import 'package:demo/routes/routers.dart';
import 'package:demo/utils/adaptUtil.dart';
import 'package:demo/views/main/information/searchPage/search.dart';
import 'package:flutter/material.dart';
import 'package:demo/http/http.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'components/articleList.dart';
import 'components/swiper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:demo/event/event_bus.dart';


class InformationPage extends StatefulWidget {
  InformationPage({Key key}) : super(key: key);

  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin  {

  List<Article> _articlesList = [];
  EasyRefreshController _controller;
  SpinKitSquareCircle spinkit;
  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
    spinkit = SpinKitSquareCircle(
      color: Global.themeColor,
      size: 50.0,
      controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
    );
  }

   @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _onRefresh () async {
    await Http.getCsdnArticles(
      extra: {
        "refresh": true,
        "list": true
      }
    ).then((data){
      List<Article> articlesList = [];
      data.forEach((item) {
        Article article = Article.fromJson(item);
        articlesList.add(article);
      });
      this._articlesList = articlesList;
      ApplicationEvent.event.fire(InformationPageGetData(_articlesList, 'home'));
    }).catchError((e) {
      ApplicationEvent.event.fire(InformationPageGetData([], 'home'));
    });
  }

  Future<void> _onLoad () async {
    await Http.getCsdnArticles(
      extra: {
        "noCache": true
      }
    ).then((data){
      List<Article> articlesList = [];
      data.forEach((item) {
        Article article = Article.fromJson(item);
        articlesList.add(article);
      });
      this._articlesList.addAll(articlesList);
      ApplicationEvent.event.fire(InformationPageGetData(_articlesList, 'home'));
    }).catchError((e) {
      ApplicationEvent.event.fire(InformationPageGetData(_articlesList, 'home'));
    });
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        leading: null,
        automaticallyImplyLeading: false,
        title: SizedBox(
          width: Adapt.screenW() * 0.95,
          height: Adapt.px(70),
          child: FlatButton(
            color: Color.fromRGBO(250, 250, 250, 0.7),
            onPressed: () {
              showSearch(context: context, delegate: InformationSearchPage());
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4))
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
      ),
      body: Container(
        color: Color.fromRGBO(255, 255, 255, 1),
        child: Stack(
          children: <Widget>[
            EasyRefresh(
              firstRefresh: true,
              firstRefreshWidget: spinkit,
              controller: _controller,
              header: BezierCircleHeader(
                color: Global.assistThemeColor,
                backgroundColor: Global.themeColor
              ),
              footer: BallPulseFooter(
                color: Global.themeColor
              ),
              child: ListView(
                children: <Widget>[
                  SwiperComponent(),
                  ListTile(
                    title: Text(
                      '为你推荐',
                      style: TextStyle(
                        fontSize: Adapt.px(34),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: SizedBox(
                      width: Adapt.px(200),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text('查看更多'),
                          Padding(padding: EdgeInsets.only(left: Adapt.px(20))),
                          Icon(Icons.arrow_right)
                        ],
                      )
                    ),
                    onTap: () {
                      ApplicationRouter.router.navigateTo(context, Routes.categoryPage);
                    }
                  ),
                  Divider(height: 0,),
                  ArticleList()
                ]
              ),
              onRefresh: _onRefresh,
              onLoad: _onLoad,
            ),
          ]
        )
      )
    );
  }

 @override
  bool get wantKeepAlive => true;
}


