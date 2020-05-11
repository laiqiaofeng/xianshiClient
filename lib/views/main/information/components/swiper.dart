

import 'package:demo/http/api.dart';
import 'package:demo/http/http.dart';
import 'package:demo/model/swiper.dart';
import 'package:demo/routes/applicationRouter.dart';
import 'package:demo/routes/routers.dart';
import 'package:demo/utils/adaptUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class SwiperComponent extends StatefulWidget {
  SwiperComponent({Key key}) : super(key: key);

  @override
  _SwiperComponentState createState() => _SwiperComponentState();
}

class _SwiperComponentState extends State<SwiperComponent> with AutomaticKeepAliveClientMixin {

  List<SwiperItem> _swiperList = [
    
  ];

  SwiperControl _swiperPlugin;
  
  @override
  void initState() {
    super.initState();
    getData();
    _swiperPlugin = SwiperControl();
  }

  Future<void> getData () async {
    await Http.getCsdnSwiper().then((data){
      List<SwiperItem> swiperList = [
        ];
      data.forEach((item) {
        SwiperItem swiperItem = SwiperItem.fromJson(item);
        swiperList.add(swiperItem);
      });
      setState(() {
        this._swiperList = swiperList;
      });
    }).catchError((e) {
      setState(() {
        _swiperList = [
          SwiperItem.fromJson({
            "imgUrl" : '${Api.RELEASE_URL}images/csdn.jpg',
            "articleUrl": '',
            "title": '数据全部来自csdn'
          })
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      margin: EdgeInsets.only(top: 6.0, bottom: 6.0),
      child: SizedBox(
      height: Adapt.px(300),
      width:  Adapt.screenW(),
      child: Swiper(
          // control: _swiperPlugin,
          itemHeight: Adapt.px(300),
          itemWidth: Adapt.screenW() * 0.8,
          containerHeight: Adapt.px(300),
          containerWidth: Adapt.screenW(),
          autoplay: true,
          // layout: SwiperLayout.TINDER,
          itemBuilder: (BuildContext context, int index) {

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(5)
              ),
              elevation: 1.0,
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: <Widget>[
                  SizedBox(
                    height: Adapt.px(300),
                    width: Adapt.screenW() * 0.8,
                    child: Image.network(
                      this._swiperList[index].imgUrl,
                      fit: BoxFit.cover,
                    )
                  ),
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: Container(
                      height: Adapt.px(40),
                      width: Adapt.screenW() * 0.8,
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      child: Center(
                        child: Text(
                          "${this._swiperList[index].title}", 
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
                            textBaseline: TextBaseline.ideographic
                            ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    )
                  )
                ]
              )
            );
          },
          itemCount: this._swiperList.length,
          viewportFraction: 0.8,
          scale: 0.9,
          onTap: (int index) {
            String url = this._swiperList[index].articleUrl;
            String title = this._swiperList[index].title;
            if (url == '') return;
            ApplicationRouter.router.navigateTo(context, '${Routes.webviewPage}?url=${Uri.encodeComponent(url)}&title=${Uri.encodeComponent(title)}', );
          }
      ),
    ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

