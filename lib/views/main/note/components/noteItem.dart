import 'dart:ui';

import 'package:common_utils/common_utils.dart';
import 'package:demo/components/Dialog.dart';
import 'package:demo/components/PreviewImage.dart';
import 'package:demo/event/event_bus.dart';
import 'package:demo/event/event_model.dart';
import 'package:demo/model/note.dart';
import 'package:demo/utils/adaptUtil.dart';
import 'package:flutter/material.dart';

class NoteItem extends StatefulWidget {
  Note note;
  int index;
  NoteItem(this.note,  {Key key, @required this.index}) : super(key: key);

  @override
  _NoteItemState createState() => _NoteItemState();
}

class _NoteItemState extends State<NoteItem> {

  GlobalKey _repaintBoundaryKey;
  Note _note;
  double cardWidth = (Adapt.screenW() - 60) / 2;
  double cardHeigth;
  @override
  void initState() {
    super.initState();
    _repaintBoundaryKey = GlobalKey();
    _note = widget.note;
    cardHeigth = (cardWidth / Adapt.screenW()) * Adapt.screenH(); 
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      child:  Material(
        borderRadius: BorderRadius.circular(4),
        color: Color(int.parse(_note.color)),
        elevation: 10,
        child: InkWell(
          onTap: () {
            print('widgetIndex${widget.index}');
            ApplicationEvent.event.fire(ShowNoteListDialog(widget.index));
          },
          child: Container(
            width: cardWidth,
            child: Column(
              children: <Widget>[
                _note.imgUrl == ''
                  ?
                  Container()
                  :
                  Material(
                  elevation: _note.showElevation ? 10 : 0,
                  color: Color(int.parse(_note.color)),
                  borderRadius: BorderRadius.circular(4),
                  child: InkWell(
                    child: Container(
                      height:  cardHeigth * _note.heigth,
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
                              child: PreviewImage(imgUrl: _note.imgUrl,  tag: _note.id ,hasButton: false, fit: BoxFit.fill,)
                            ),
                          ),
                            _note.showFadeShadow
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
                          _note.showFadeShadow
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
                                  Color(int.parse(_note.color)).withOpacity(0),
                                  // _currentColor.withOpacity(0.1),
                                     Color(int.parse(_note.color)).withOpacity(0.9)
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
                _note.content != '' 
                ? 
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text( "${_note.content}", style: TextStyle(fontSize: 12, color: Colors.white),),
                )
                : 
                Container(),
                Padding(
                  padding: EdgeInsets.only(top: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text( "—— ${DateUtil.formatDate(DateTime.parse(_note.createTime), format: 'M月dd日' )}", style: TextStyle(fontSize: 12, color: Colors.white),),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}