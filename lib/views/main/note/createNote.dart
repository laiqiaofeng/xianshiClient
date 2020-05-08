import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:common_utils/common_utils.dart';
import 'package:demo/common/Global.dart';
import 'package:demo/components/Dialog.dart';
import 'package:demo/event/event_bus.dart';
import 'package:demo/event/event_model.dart';
import 'package:demo/http/http.dart';
import 'package:demo/routes/applicationRouter.dart';
import 'package:demo/routes/routers.dart';
import 'package:demo/utils/adaptUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';


class CreateNote extends StatefulWidget {
  CreateNote({Key key}) : super(key: key);

  @override
  _CreateNoteState createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  ScrollController _scrollController;
  int _currentIndex;
  Color _currentColor;
  double _currentImageHeigth;
  bool _showElevation = true;
  // 用于在没有填写内容截图时去除输入框
  bool _showTextInput = true;
  bool _showFadeShadow = false;
  File _imageFile;
  FocusNode _focusNode;
  GlobalKey _repaintBoundaryKey;
  Uint8List _image;
  bool _heightChange = false;
  TextEditingController _textEditingController;
  String userId;
  String _createTime;
  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _currentColor = Global.themeColor;
    _scrollController = ScrollController();
    _currentImageHeigth = 0.4; 
    _focusNode = FocusNode();
    _repaintBoundaryKey = GlobalKey();
    _textEditingController = TextEditingController();
    userId = Global.profile.user != null ? Global.profile.user.id : '';
    _createTime = '—— ${DateUtil.formatDate(DateTime.now(), format: 'M月dd日')}';
    ApplicationEvent.event.on<NoteParamChange>().listen((event) {
      if (!mounted) return;
      setState(() {
        if (event.color != null) {
          _currentColor = event.color;
        }
        if (event.height != null) {
          _currentImageHeigth = 0.4 + event.height;
          _heightChange = true;
        }
        if (_imageFile != null && event.isDragEnd != null && _heightChange) {
          MyDialog.bottomPopupSingleButtonDialog(
            context: context,
            text: '你已经修改图片高度，是否需要重新裁剪图片？',
            buttonText: '需要',
            color: _currentColor,
            onPressed: () async {
              var image = await _getFile(_imageFile);
              if (image != null) {
                setState(() {
                  _imageFile = image;
                });
              }
            });
        }
      });
    });
  }

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery).then((data) {
      return _getFile(data);
    });
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  Future _getFile (File data) async {

    File croppedFile = await ImageCropper.cropImage(
      sourcePath: data.path,
      androidUiSettings: AndroidUiSettings(
        toolbarColor: _currentColor,
        statusBarColor	: _currentColor,
        toolbarWidgetColor	: Colors.white,
        activeControlsWidgetColor	: _currentColor,
        activeWidgetColor	: _currentColor,
        toolbarTitle: '图片裁剪',
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false
      ),
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      )
    );
    print('返回的是什么path${croppedFile.path}');
    return croppedFile ?? data;
  }

  // 截图
  Future<Uint8List> _capturePng () async {
    try {
      RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext.findRenderObject();
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      return pngBytes;
    }catch (e) {
      print(e);
    }
    return null;
  }

  // 创建note
  Future _createNote () async {

    Http.createNote(
      userId: userId, 
      content: _textEditingController.text, 
      image: _imageFile, 
      heigth: _currentImageHeigth, 
      color: _currentColor, 
      showElevation: _showElevation,
      showFadeShadow: _showFadeShadow
      ).then((data){
        print(data);
        if (data is String && data.length == 24) {
          ApplicationEvent.event.fire(NoteLoad('refresh'));
          ApplicationEvent.event.fire(UpdateNoteAndPlanCount());
          ApplicationRouter.router.pop(context);
        }
      });
   
  }

  @override
  void dispose() {

    super.dispose();
    _scrollController.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(_focusNode);
        },
        child: AnimatedContainer(
          duration: Duration(seconds: 1),
          color: _currentColor,
          width: double.infinity,
          height: Adapt.screenH(),
          child: Stack(
            children: <Widget>[
              Positioned(
                child: SingleChildScrollView(
                    physics: new BouncingScrollPhysics(),
                    child: RepaintBoundary(
                      key: _repaintBoundaryKey,
                      child: Column(
                        children: <Widget>[
                          Material(
                            elevation: _showElevation ? 10 : 0,
                            color: _currentColor,
                            child: InkWell(
                              onTap: () {
                                _getImage();
                              },
                              child: Container(
                                width: double.infinity,
                                height: Adapt.screenH() * _currentImageHeigth,
                                child: Stack(
                                  overflow: Overflow.visible,
                                  children: <Widget>[
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      left: 0,
                                      bottom: 0,
                                      child: _imageFile == null
                                      ?
                                      Center(
                                        child: Text('添加图片', style: TextStyle(color: Colors.white),),
                                      )
                                      : 
                                      Image.asset(_imageFile.path, fit: BoxFit.fill,),
                                    ),
                                    _showFadeShadow
                                     ? 
                                     Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: - Adapt.px(40),
                                      // top: 200,
                                      child:  ClipRRect(
                                        child: BackdropFilter(
                                          filter: new ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                                          child: new Container(
                                            // color: _currentColor.withOpacity(0.1),
                                            color: Colors.transparent,
                                            height: Adapt.px(60),
                                          ),
                                        ),
                                      )
                                    )
                                    :
                                    Container(),
                                    _showFadeShadow
                                     ? 
                                     Positioned(
                                      // top: 0,
                                      left: 0,
                                      right: 0,
                                      bottom: - Adapt.px(40),
                                      child: Container(
                                        height: Adapt.px(140),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                            _currentColor.withOpacity(0),
                                            // _currentColor.withOpacity(0.1),
                                             _currentColor.withOpacity(1)
                                          ], 
                                          begin: FractionalOffset(0.5, 0), end: FractionalOffset(0.5, 1))
                                        ),
                                      )
                                    )
                                    :
                                    Container(),
                                    
                                  ],
                                )
                              ),
                            )
                          ),
                          _showTextInput 
                          ? 
                          Padding(padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                          child: TextField(
                            maxLines: 3,
                            controller: _textEditingController,
                            autocorrect: true,
                            maxLength: 50,
                            decoration: InputDecoration(
                              hintText: '点击输入内容',
                              hintStyle: TextStyle(
                                color: Colors.white
                              ),
                              labelStyle: TextStyle(
                                color:Colors.white,
                              ),
                              border: InputBorder.none,
                              focusColor: Colors.white, 
                              counterStyle: TextStyle(fontSize: 12, color: Colors.white)
                            ),
                            
                          ),)
                          : 
                          Container(),
                          Padding(
                            padding: EdgeInsets.only(top: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text( _createTime, style: TextStyle(color: Colors.white),),
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: Adapt.px(160))),
                        ],
                      ),
                    )
                )
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  color: Colors.white,
                  width: Adapt.screenW(),
                  height: Adapt.px(140),
                  child: Flex(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: FlatButton(
                              padding: EdgeInsets.all(0),
                            onPressed: () {
                              MyDialog.colorSelectDialog(context: context, color: _currentColor);
                            }, 
                            child: Padding(padding: EdgeInsets.only(top: 12, bottom: 12), 
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(Icons.color_lens, color: _currentColor, size: 22,),
                                Text('背景色', style: TextStyle(fontSize: 12, color: _currentColor), maxLines: 1,)
                              ],
                            ),)
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: FlatButton(
                            onPressed: () {
                              _heightChange = false;
                              MyDialog.sliderDialog(context: context, value: _currentImageHeigth - 0.4, minValue: -0.2, maxValue: 0.3, color: _currentColor);
                            }, 
                            child: Padding(padding: EdgeInsets.only(top: 14, bottom: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(IconData(0xe6e9, fontFamily: 'iconfont'), color: _currentColor, size: 16,),
                                Text('高度', style: TextStyle(fontSize: 12, color: _currentColor),)
                              ],
                            ),)
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: FlatButton(
                            onPressed: () {
                            setState(() {
                              _showFadeShadow = false;
                              _showElevation = !_showElevation;
                            });
                            }, 
                            child: Padding(padding: EdgeInsets.only(top: 14, bottom: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(IconData(0xe61e, fontFamily: 'iconfont'), color: _showElevation ? _currentColor : _currentColor.withOpacity(0.6), size: 20,),
                                Text('阴影', style: TextStyle(fontSize: 12, color: _showElevation ? _currentColor : _currentColor.withOpacity(0.6),) ,)
                              ],
                            ),)
                          ),
                        ),
                         Expanded(
                           flex: 1,
                           child: FlatButton(
                             padding: EdgeInsets.all(0),
                            onPressed: () {
                            setState(() {
                              _showElevation = false;
                              _showFadeShadow = !_showFadeShadow;
                            });
                            }, 
                            child: Padding(padding: EdgeInsets.only(top: 12, bottom: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(IconData(0xe6fb, fontFamily: 'iconfont'), color: _showFadeShadow ? _currentColor : _currentColor.withOpacity(0.6), size: 24,),
                                Text('淡化阴影', style: TextStyle(fontSize: 12, color: _showFadeShadow ? _currentColor : _currentColor.withOpacity(0.6),) ,)
                              ],
                            ),)
                          ),
                         ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            margin: EdgeInsets.all(14),
                            child: RaisedButton(
                              color: _currentColor,
                              textColor: Colors.white,
                              onPressed: () {
                                print('_textEditingController${_textEditingController.text}');
                                if (_textEditingController.text == '' && _imageFile == null) {
                                  Fluttertoast.showToast(msg: '请添加内容', gravity: ToastGravity.TOP);
                                  return;
                                }
                                _createNote();
                                
                              }, 
                              child: Text('完成')
                            ),
                          )
                        )
                      ],
                    ),
                )
              )
            ],
          )
        ),
      )
    );
  }
}