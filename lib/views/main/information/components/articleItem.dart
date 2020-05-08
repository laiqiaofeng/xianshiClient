import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo/model/article.dart';
import 'package:demo/routes/applicationRouter.dart';
import 'package:demo/routes/routers.dart';
import 'package:demo/utils/adaptUtil.dart';
import 'package:flutter/material.dart';


class ArticleItem extends StatefulWidget {
  Article article;
  ArticleItem(this.article, {Key key}) : super(key: key);

  @override
  _ArticleItemState createState() => _ArticleItemState(this.article);
}

class _ArticleItemState extends State<ArticleItem> {
  Article article;
  _ArticleItemState(this.article);


  void _onCardTap () {
    String url = this.article.url;
    String title = this.article.title;
    print('${Routes.webviewPage}?url=${Uri.encodeComponent(url)}&title=${Uri.encodeComponent(title)}');
    ApplicationRouter.router.navigateTo(context,  '${Routes.webviewPage}?url=${Uri.encodeComponent(url)}&title=${Uri.encodeComponent(title)}');
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: _onCardTap,
        child: Container(
          // height: 80,
          width: Adapt.screenW(),
          // margin: EdgeInsetsGeometry.lerp(100, 100, 100)
          // 设置阴影
          padding: EdgeInsets.only(left: 20, right: 20, top: 10),
          margin: EdgeInsets.all(0),
          //设置圆角
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(this.article.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              Text(this.article.desc, maxLines: 3, overflow: TextOverflow.ellipsis,),
              Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: this.article.avatar,
                          placeholder: (context, url) => Icon(Icons.av_timer),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          width: 24,
                          height: 24,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left: 10)),
                      Text(this.article.nickname, style: TextStyle(fontSize: 12),)
                    ]
                  ),
                  Row(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(IconData(0xe66f, fontFamily: 'iconfont'), size: 12, color: Color.fromRGBO(100, 100, 100, 0.8)),
                          Padding(padding: EdgeInsets.only(left: 5)),
                          Text("${this.article.digg}", style: TextStyle(
                            fontSize: 10,
                            color: Color.fromRGBO(100, 100, 100, 0.8)
                          ),)
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(left: 10)),
                      Row(
                        children: <Widget>[
                           Icon(IconData(0xe687, fontFamily: 'iconfont'), size: 12, color: Color.fromRGBO(100, 100, 100, 0.8),),
                          Padding(padding: EdgeInsets.only(left: 5)),
                          Text("${this.article.views}", style: TextStyle(
                            fontSize: 10,
                            color: Color.fromRGBO(100, 100, 100, 0.8)
                          ),)
                        ],
                      ),
                       Padding(padding: EdgeInsets.only(left: 10)),
                      Row(
                        children: <Widget>[
                          Icon(IconData(0xe60f, fontFamily: 'iconfont'), size: 12, color: Color.fromRGBO(100, 100, 100, 0.8),),
                          Padding(padding: EdgeInsets.only(left: 5)),
                          Text("${this.article.comments}", style: TextStyle(
                            fontSize: 10,
                            color: Color.fromRGBO(100, 100, 100, 0.8)
                          ),)
                        ],
                      )
                    ]
                  )
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              Divider(
                height: 0,
              )
            ]
          ),
        )
      ),
    );
  }
}