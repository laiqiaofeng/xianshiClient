import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo/common/Global.dart';
import 'package:demo/routes/applicationRouter.dart';
import 'package:demo/routes/routers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PreviewImage extends StatefulWidget {
  String imgUrl;
  String tag;
  bool hasButton;
  BoxFit fit;
  GestureTapCallback onTap;
  PreviewImage({@required this.imgUrl, @required this.tag, this.onTap, this.hasButton = true, this.fit = BoxFit.cover, Key key}) : super(key: key);

  @override
  _PreviewImageState createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> with SingleTickerProviderStateMixin{

  String _imgUrl;
  String _defaultUrl;
  Map _defaultUrlMap = {
    'avatarUrl': 'assets/images/default_avatar.png',
    'bannerUrl': 'assets/images/loading_background.jpg'
  };
  SpinKitSquareCircle spinkit;
  @override
  void initState() {
    super.initState();
    _defaultUrl = _defaultUrlMap[widget.tag] ?? '';
    spinkit = SpinKitSquareCircle(
      color: Global.themeColor,
      size: 50.0,
      controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
    );
  }
  @override
  Widget build(BuildContext context) {
    _imgUrl = widget.imgUrl ?? '';
    return GestureDetector(
      onTap: widget.onTap ?? () {
        String url =_imgUrl;
        String tag = widget.tag;
        ApplicationRouter.router.navigateTo(context, '${Routes.imagePreviewPage}?imageUrl=${Uri.encodeComponent(url)}&tag=${Uri.encodeComponent(tag)}&hasButton=${widget.hasButton}');
      },
      child: Hero(
        tag: widget.tag, 
        child: _imgUrl.startsWith('http') ? 
        CachedNetworkImage(
            imageUrl: _imgUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Image.asset(_defaultUrl, fit: widget.fit,),
        )
        :
        Image.asset(_imgUrl, fit: widget.fit,),  
      )
    );
  }
}