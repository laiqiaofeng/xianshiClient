import 'dart:async';
import 'package:demo/components/EmptyPage.dart';
import 'package:demo/event/event_bus.dart';
import 'package:demo/event/event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:demo/model/article.dart';
import './articleItem.dart';


class ArticleList extends StatefulWidget {

  String category;
  ArticleList({Key key, this.category = 'home'}) : super(key: key);
  
  @override
  _ArticleListState createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {
  List<Article> _articleList = [];
  StreamSubscription _informationPageGetDataSubscription; 
  bool _isFirst = true;

  @override
  void initState() {
    super.initState();
    _informationPageGetDataSubscription = ApplicationEvent.event.on<InformationPageGetData>().listen((event) {
      setState(() {
        _isFirst = false;
      });
      if (widget.category != event.category) return;
      if (event.articleList.length > 0 && this.mounted) {
        setState(() {
          this._articleList = event.articleList;
        });
      }
    });
  }

  @override
  void dispose() {
    // 取消订阅
    super.dispose();
    print('订阅已经取消');
    _informationPageGetDataSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return (_articleList.length == 0 && !_isFirst) 
      ? 
      EmptyPage()
      : 
      Container(
      color: Color.fromRGBO(255, 255, 255, 1),
      child: AnimationLimiter(
        child: SizedBox(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: this._articleList.length,
              itemBuilder: (BuildContext context, int index) {
                Article article = this._articleList[index];
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: ArticleItem(article),
                    ),
                  ),
                );
              },
            )
        ),
      ),
    );
  }
}
