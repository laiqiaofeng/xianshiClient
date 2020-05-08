import 'dart:io';

import 'package:demo/common/Global.dart';
import 'package:demo/provider/user.dart';
import 'package:demo/routes/applicationRouter.dart';
import 'package:demo/utils/adaptUtil.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:demo/http/http.dart';
import 'package:provider/provider.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';


class ImagePreview extends StatefulWidget {
  String imgUrl;
  String tag;
  bool hasButton;
  ImagePreview({@required this.imgUrl, @required this.tag, this.hasButton, Key key}) : super(key: key);

  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {

  String userId;
  String _image;
  @override
  void initState() { 
    super.initState();
    _image = widget.imgUrl;
  }

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery).then((data) {
      return _getFile(data);
    });

    Http.upload(image:image,tag: widget.tag, id: userId).then((data) {
      if (data is String || data == null) return;
      print('这里的data是$data');
      Global.profile.user = data;
      Global.saveProfile();
      Fluttertoast.showToast(
        msg: '修改成功',
        webPosition: 'top',
        gravity: ToastGravity.TOP
      );
      setState(() {
        if (widget.tag == 'avatarUrl') {
          _image = data.avatarUrl ?? '';

        } else if (widget.tag == 'bannerUrl') {
          _image = data.bannerUrl ?? '';
        }
      });
    });
  }
      
  
  Future _getFile (File data) async {

    File croppedFile = await ImageCropper.cropImage(
      sourcePath: data.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      cropStyle: CropStyle.circle,
      androidUiSettings: AndroidUiSettings(
        toolbarColor: Global.themeColor,
        statusBarColor	: Global.themeColor,
        toolbarWidgetColor	: Colors.white,
        activeControlsWidgetColor	: Global.themeColor,
        activeWidgetColor	: Global.themeColor,
        toolbarTitle: '图片裁剪',
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false
      ),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      )
    );
    return croppedFile ?? data;
  }
  @override
  Widget build(BuildContext context) {
    userId = Provider.of<UserModel>(context).user.id;
    return Scaffold(
      body: Container(
        color: Colors.black,
        child:  Container(
            width: Adapt.screenW(),
            height: Adapt.screenH(),
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Hero(
                    tag: widget.tag, 
                    child:  Center(
                      child: Container(
                      width: Adapt.screenW(),
                      height: Adapt.screenH(),
                      child: _image.startsWith('http://')
                      ? 
                      ZoomableWidget(
                        minScale: 0.3,
                        maxScale: 2.0,
                        // default factor is 1.0, use 0.0 to disable boundary
                        panLimit: 0.8,
                        child: Container(
                          child: TransitionToImage(
                            image: AdvancedNetworkImage(_image, timeoutDuration: Duration(minutes: 1)),
                            // This is the default placeholder widget at loading status,
                            // you can write your own widget with CustomPainter.
                            placeholder: CircularProgressIndicator(),
                            // This is default duration
                            duration: Duration(milliseconds: 300),
                          ),
                        ),
                      )
                      :
                      ZoomableWidget(
                        minScale: 0.3,
                        maxScale: 2.0,
                        // default factor is 1.0, use 0.0 to disable boundary
                        panLimit: 0.8,
                        child: Container(
                          child: TransitionToImage(
                            image: AssetImage(_image),
                            // This is the default placeholder widget at loading status,
                            // you can write your own widget with CustomPainter.
                            placeholder: CircularProgressIndicator(),
                            // This is default duration
                            duration: Duration(milliseconds: 300),
                          ),
                        ),
                      )
                    ),
                    )
                    ),
                ),
                widget.hasButton 
                ? 
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: Adapt.px(100),
                  child: Center(
                    child: FlatButton(
                    onPressed: () {
                      _getImage();
                    }, 
                    color: Colors.white,
                    child: Text('重新选择')
                  ),
                  )
                )
                :
                Container(),
                Positioned(
                  top: Adapt.px(80),
                  left: Adapt.px(50),
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white,), 
                    onPressed: () {
                      ApplicationRouter.router.pop(context);
                    }),
                )
              ],
            ),
          )
      ),
    );
  }
}