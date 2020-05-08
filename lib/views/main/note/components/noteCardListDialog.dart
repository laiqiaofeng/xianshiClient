import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:demo/event/event_bus.dart';
import 'package:demo/event/event_model.dart';
import 'package:demo/http/http.dart';
import 'package:demo/model/note.dart';
import 'package:demo/utils/adaptUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class NoteCardListDialog extends StatefulWidget {
  List<Note> noteList;
  int index;
  NoteCardListDialog(this.noteList,  this.index, {Key key}) : super(key: key);

  @override
  _NoteCardListDialogState createState() => _NoteCardListDialogState();
}

class _NoteCardListDialogState extends State<NoteCardListDialog> {

  List<Note> _noteList;
  int _currentIndex;

  @override
  void initState() {
    super.initState();
    print('初始的${widget.index}');
    _currentIndex = widget.index;
    _noteList = List.from(widget.noteList);
    ApplicationEvent.event.on<UpdateNoteListDialog>().listen((event) {
      setState(() {
        _noteList = event.noteList;
      });
    });
  }

  Future<Uint8List> _capturePng() async {

    Note note = _noteList[_currentIndex];

    RenderRepaintBoundary boundary = note.repaintBoundaryKey.currentContext.findRenderObject();

    var dpr = window.devicePixelRatio;

    var image = await boundary.toImage(pixelRatio: dpr);
    // print('image是file${image.}');
    ByteData byteData = await image.toByteData(format: ImageByteFormat.png);

    Uint8List picBytes = byteData.buffer.asUint8List();

    return picBytes;

  }

  Future _savePng ()  async{
    return _capturePng().then((data) async {
      var status = await Permission.storage.status;
      // 判断是否有存储权限
      if (status.isUndetermined) {
        await Permission.storage.request();
        // We didn't ask for permission yet.
      }
      if (data != null) {
        return ImageGallerySaver.saveImage(data);
      }
      return null;
    }).then((result) async {
      // String dir = (await getApplicationDocumentsDirectory()).path;
      print(result);
      File file = await  File(Uri.decodeComponent(result.toString().replaceFirst('file://', '')));
      return file;
    });
  }



  @override
  Widget build(BuildContext context) {
    _noteList.forEach((item) {
      item.repaintBoundaryKey = GlobalKey();
    });
    return Container(
      // width: Adapt.screenW(),
      height: Adapt.screenH() - 10,
      color: Colors.transparent,
      // margin: EdgeInsets.all(30),
      padding: EdgeInsets.only(top: 40, bottom: 40),
      child: Flex(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        direction: Axis.vertical,
        children: <Widget>[
          Expanded(
            flex: 8,
            child: Swiper(
              index: _currentIndex,
              physics: new BouncingScrollPhysics(),
              layout: SwiperLayout.DEFAULT,
              itemCount: _noteList.length,
              itemBuilder: (BuildContext context,int index){
                Note note = _noteList[index];
                return Container(
                  child: Center(
                    child: RepaintBoundary(
                      key: note.repaintBoundaryKey,
                      child: noteItemCard(note),
                    ),
                  ),
                );
              },
              loop: false,
              // pagination: SwiperPagination(),
              control: SwiperControl(
                size: 0.0
              ),
              onIndexChanged: (int index) {
                _currentIndex = index;
                print(index);
                if (index == _noteList.length - 2) {
                  // print('我要请求了');
                  ApplicationEvent.event.fire(NoteLoad('load', isUpdateNoteListDialog: true));
                }
              }
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          Expanded(
            child: Material(
              color: Colors.black87.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
              child: Container(
                width: Adapt.screenW() * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(IconData(0xe673, fontFamily: 'iconfont'), color: Colors.white, size: 24,), 
                      onPressed: () {
                        setState(() {
                          _noteList.removeAt(_currentIndex);
                        });
                        ApplicationEvent.event.fire(DeleteNote(_currentIndex));
                      }
                    ),
                    IconButton(
                      icon: Icon(IconData(0xe609, fontFamily: 'iconfont'), color: Colors.white, size: 24,), 
                      onPressed: () {
                        _savePng().then((data) {
                          if (data != null) {
                            Fluttertoast.showToast(msg: '保存成功', gravity: ToastGravity.TOP);
                          }
                        });
                      }
                    ),
                    IconButton(
                      icon: Icon(IconData(0xe654, fontFamily: 'iconfont'), color: Colors.white, size: 24,), 
                      onPressed: () {
                        Note note = _noteList[_currentIndex];
                        if (note.imageShare != null && note.imageShare != '') {
                          Share.share(note.imageShare, subject: '去学吧');
                        }else {
                          _savePng().then((data) {
                            print('现在分享${data}');
                            return Http.upload(image: data,type: 'noteImageShare', tag: 'imageShare', id: note.id );
                          }).then((data) {
                            print('现在的url$data');
                            Share.share(data, subject: '去学吧');
                          });
                        }
                        
                      }
                    )
                  ],
                ),
              ),
            )
          )
        ],
      )
    );
  }
}


Widget noteItemCard (Note note) {
  double cardWidth = Adapt.screenW() - 120;
  double cardHeigth = (cardWidth / Adapt.screenW()) * Adapt.screenH();  
  return  Material(
    borderRadius: BorderRadius.circular(4),
    color: Color(int.parse(note.color)),
    elevation: 15,
    child:  Container(
        width: cardWidth,
        child: Wrap(
          children: <Widget>[
            note.imgUrl == ''
              ?
              Container()
              :
              Material(
              elevation: note.showElevation ? 10 : 0,
              color: Color(int.parse(note.color)),
              borderRadius: BorderRadius.circular(4),
              child: InkWell(
                child: Container(
                  height:  cardHeigth * note.heigth,
                  child: Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Positioned(
                        top: 0,
                        right: 0,
                        left: 0,
                        bottom: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(4), topLeft: Radius.circular(4)),
                          child: CachedNetworkImage(
                            imageUrl: note.imgUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Center(
                              child:  Image.asset('assets/images/image_load_error.png', fit: BoxFit.cover,),
                            )
                          )
                        ),
                      ),
                        note.showFadeShadow
                        ? 
                        Positioned(
                        left: 0,
                        right: 0,
                        bottom: - Adapt.px(20),
                        // top: 200,
                        child:  ClipRRect(
                          child: BackdropFilter(
                            filter: new ImageFilter.blur(sigmaX:1, sigmaY: 1),
                            child: new Container(
                              // color: Colors.white,
                              color: Colors.transparent,
                              height: Adapt.px(35),
                            ),
                          ),
                        )
                      )
                      :
                      Container(),
                      note.showFadeShadow
                        ? 
                        Positioned(
                        // top: 0,
                        left: 0,
                        right: 0,
                        bottom: - Adapt.px(20),
                        child: Container(
                          height: Adapt.px(60),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Color(int.parse(note.color)).withOpacity(0),
                              // _currentColor.withOpacity(0.1),
                                Color(int.parse(note.color)).withOpacity(0.9)
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
            note.content != '' 
            ? 
            Container(
              margin: EdgeInsets.all(12),
              child: Center(
                child: Text( note.content, style: TextStyle(fontSize: 14, color: Colors.white),),
              )
            )
            : 
            Container(),
            Padding(
              padding: EdgeInsets.only(top: 20, right: 10, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text( "—— ${DateUtil.formatDate(DateTime.parse(note.createTime), format: 'M月dd日' )}", style: TextStyle(fontSize: 14, color: Colors.white),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
}