import 'package:demo/common/Global.dart';
import 'package:demo/components/PreviewImage.dart';
import 'package:demo/http/http.dart';
import 'package:demo/provider/user.dart';
import 'package:demo/routes/applicationRouter.dart';
import 'package:demo/routes/routers.dart';
import 'package:demo/utils/adaptUtil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../mine.dart';





class MineHeader extends SliverPersistentHeaderDelegate {

  double _avatarSize = Adapt.px(260);
  double offset = 0;
  List itemList;
  MineHeader({
    this.offset,
    this.itemList
  });

  

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Consumer<UserModel>(
      builder: (BuildContext context, userModel, Widget child) {
        String _bannerUrl;
        String _avatarUrl;
        String _userName;
        bool _isLogin;
        int _sex;
        if (userModel.user == null) {
          _bannerUrl = 'assets/images/loading_background.jpg';
          _avatarUrl = 'assets/images/default_avatar.png';
          _isLogin = userModel.isLogin;
          _userName = '';
          _sex = 1;
        }else {
          _bannerUrl = userModel.user.bannerUrl != '' ? userModel.user.bannerUrl : 'assets/images/loading_background.jpg';
          _avatarUrl = userModel.user.avatarUrl != '' ? userModel.user.avatarUrl : 'assets/images/default_avatar.png';
          _isLogin = userModel.isLogin;
          _userName = userModel.user.userName != '' ? userModel.user.userName : '';
          _sex = userModel.user.sex;
        }
        return Container(
          height: maxExtent,
          color: Color(0xFF444242),
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  color: Colors.blue,
                  width: Adapt.screenW(),
                  height: maxExtent - Adapt.px(360),
                  child: PreviewImage(imgUrl: _bannerUrl, tag: 'bannerUrl',)
                ),
              ),
              Positioned(
                top:  maxExtent - Adapt.px(420),
                left: 0,
                child: Container(
                  width: Adapt.screenW(),
                  padding: EdgeInsets.only(left: 20, right: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                       ClipRRect(
                        borderRadius: BorderRadius.circular(_avatarSize),
                        child: Container(
                          width: _avatarSize,
                          height: _avatarSize,
                          padding: EdgeInsets.all(6),
                          color: Color(0xFF444242),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(_avatarSize),
                            // child: ZoomableImage(new AssetImage(_avatarUrl), scale: 16.0),
                            child: PreviewImage(imgUrl: _avatarUrl, tag: 'avatarUrl',hasButton: userModel.isLogin, )
                          )
                        )
                      ),
                      SizedBox(
                        width: Adapt.px(200),
                        child: Text(_userName, style: TextStyle(color: Colors.white, fontSize: 14),overflow: TextOverflow.ellipsis,),
                      ),
                      SizedBox(
                        width: Adapt.px(120),
                        height: Adapt.px(60),
                        child: RaisedButton(
                          textColor: Colors.white,
                          color: Global.themeColor,
                          onPressed: () {
                            if(_isLogin) {
                              ApplicationRouter.router.navigateTo(context, Routes.modifyUserInfoPage);
                            }else {
                              ApplicationRouter.router.navigateTo(context, Routes.loginPage, replace: true);
                            }
                          }, 
                          padding: EdgeInsets.all(0),
                          child: Text(_isLogin ? '编辑信息' : '点击登录', style: TextStyle(fontSize: 12),)
                        )
                      )
                    ],
                  )
                ),
              ),
              Positioned(
                top: maxExtent - Adapt.px(250),
                left: Adapt.px(240),
                child:sexWidget(_sex, _isLogin),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  width: Adapt.screenW(),
                  height: Adapt.px(160),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      createCard(itemList[0]),
                      createCard(itemList[1]),
                      createCard(itemList[2])
                    ],
                  )
                )
              )
            ],
          )
        );
      },
    );
  }

  @override
  double get maxExtent => Adapt.px(680) + offset;

  @override
  double get minExtent => Adapt.px(680) + offset;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
  
}



Widget createCard (CardOptions cardOptions) {
  return Material(
    color: Color(0xffeeeeee),
    elevation: 10,
    borderRadius: BorderRadius.circular(4),
    child: InkWell(
      onTap: () {},
      child: Container(
          width: Adapt.px(200),
          height: Adapt.px(126),
          padding: EdgeInsets.all(4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("${cardOptions.count}", style: TextStyle(color: cardOptions.color, fontSize: 20, fontWeight: FontWeight.bold),),
              Text(cardOptions.title, style: TextStyle(color: Color(0xff757575)),)
            ],
          ),
        ),
    ),
  );
}


Widget sexWidget (int sex, bool isLogin) {
  if (isLogin) {
    String sexIconUrl;
    if (sex == 1) {
      sexIconUrl = 'assets/icons/sex_1.png';
    }else if (sex == 2){
      sexIconUrl = 'assets/icons/sex_2.png';
    }
    return Container(
      width: Adapt.px(45),
      height: Adapt.px(45),
      child: Image.asset(sexIconUrl, fit:BoxFit.cover)
    );
  }
  return Container();
}