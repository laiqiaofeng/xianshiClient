import 'package:demo/common/Global.dart';
import 'package:demo/event/event_bus.dart';
import 'package:demo/event/event_model.dart';
import 'package:demo/http/http.dart';
import 'package:demo/model/article.dart';
import 'package:demo/views/main/information/components/articleList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CategoryAritcleList extends StatefulWidget {
  String _category;
  CategoryAritcleList(this._category, {Key key}) : super(key: key);

  @override
  _CategoryAritcleListState createState() => _CategoryAritcleListState();
}

class _CategoryAritcleListState extends State<CategoryAritcleList> with AutomaticKeepAliveClientMixin,SingleTickerProviderStateMixin {
  
  EasyRefreshController _easyRefreshController;
  List<Article> _articlesList = [];

  _CategoryAritcleListState();

  SpinKitSquareCircle spinkit;
  @override
  void initState() { 
    print(widget._category);
    super.initState();
    spinkit = SpinKitSquareCircle(
      color: Global.themeColor,
      size: 50.0,
      controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
    );
    _easyRefreshController = EasyRefreshController();
    
  }

  @override
  void dispose() {
    super.dispose();
    _articlesList.clear();
    _easyRefreshController.dispose();
  }

  Future<void> _onRefresh () async {
    await Http.getCsdnArticles(
      category: widget._category,
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
      ApplicationEvent.event.fire(InformationPageGetData(_articlesList, widget._category));
    }).catchError((e) {
      ApplicationEvent.event.fire(InformationPageGetData([], widget._category));
    });
  }

  Future<void> _onLoad () async {
    await Http.getCsdnArticles(
      category: widget._category,
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
      ApplicationEvent.event.fire(InformationPageGetData(_articlesList, widget._category));
    }).catchError((e) {
      ApplicationEvent.event.fire(InformationPageGetData(_articlesList, widget._category));
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
       child: EasyRefresh(
        firstRefresh: true,
        firstRefreshWidget: spinkit,
        controller: _easyRefreshController,
        header: BezierCircleHeader(
          color: Global.assistThemeColor,
          backgroundColor: Global.themeColor
        ),
        footer: BallPulseFooter(
          color: Global.themeColor
        ),
        child:  ArticleList( category: widget._category,),
        onRefresh: _onRefresh,
        onLoad:  _onLoad,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}