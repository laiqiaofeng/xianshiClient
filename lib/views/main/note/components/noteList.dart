import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:demo/common/Global.dart';
import 'package:demo/components/Dialog.dart';
import 'package:demo/components/EmptyPage.dart';
import 'package:demo/event/event_bus.dart';
import 'package:demo/event/event_model.dart';
import 'package:demo/http/http.dart';
import 'package:demo/model/note.dart';
import 'package:demo/utils/adaptUtil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:demo/views/main/note/components/noteItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NoteList extends StatefulWidget {
  NoteList({Key key}) : super(key: key);

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {

  int _pageSize = 1000;
  int _pageIndex = 1;
  bool _listFinished = false;
  String userId;
  List<Note> _noteList ;
  Map<String, List<Note>> _noteGroupMap = {};
  var _dateList;
  ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _noteList = [];
    _scrollController = ScrollController();
    userId = Global.profile.user != null ? Global.profile.user.id : '';
    // _onRefresh();
    ApplicationEvent.event.on<NoteLoad>().listen((event) {
      if (event.type == 'load') {
        _onLoad(event.isUpdateNoteListDialog);
      }else if (event.type == 'refresh') {
        _onRefresh();
      }
    });

    ApplicationEvent.event.on<ShowNoteListDialog>().listen((event) {
      MyDialog.noteCardDialog(context: context, noteList: _noteList, index: event.index);
    });

    ApplicationEvent.event.on<DeleteNote>().listen((event) {
      // print('删除${event.index}');
      // print('现在的noteList${_noteList.length}');
      Note note = _noteList[event.index];
      Http.deleteNote(note.id, note.imgUrl).then((data) {
        setState(() { 
          _noteList.removeAt(event.index); 
        });
        Fluttertoast.showToast(msg: "删除成功", gravity: ToastGravity.TOP);
      });       
    });
  }

  Future<void> _onRefresh () async {
    print('跟新了');
    _pageIndex = 1;
    _getNoteList(extra: {
      'refresh': true,
      'list': true,
      // "noCache": true
    }).then(( noteList) {
      setState(() {
        _noteList = noteList;
        print('//////////////////////////////////////////////');
        print(_noteList.length);
      });
    });
  }

  Future<void> _onLoad (bool isUpdateNoteListDialog) async {
    print('请求了');
    if (_listFinished) {
      return; 
    }
    _getNoteList(extra: {
      // "noCache": true
    }).then((dynamic noteList) {
      setState(() {
        _noteList.addAll(noteList);
        if (isUpdateNoteListDialog) {
          ApplicationEvent.event.fire(UpdateNoteListDialog(_noteList));
        }
      });
    });
  }

  Future _getNoteList ({Map<String, dynamic> extra}) async {
    return Http.getNoteList(userId, pageIndex: _pageIndex, pageSize: _pageSize, extra: extra).then((data) {
      // print('请求到的数据是$data');
      var res = json.decode(json.encode(data));
      List list = res['list'] ?? [];
      int total = res['total'];
      List<Note> noteList = [];
      list.forEach((var item) {
        Note planItem = Note.fromJson(item);
        noteList.add(planItem);
      });
      if ( total <= _pageIndex * _pageSize) {
        _listFinished = true;
      } else {
        _pageIndex ++;
      }
      return noteList;
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return  _noteList.length == 0 
        ?
        EmptyPage(hintText:'暂无便签，快去创建吧 ~',)
        :
        new StaggeredGridView.countBuilder(
            crossAxisCount: 4,
            // shrinkWrap: true,
            controller: _scrollController,
            padding: EdgeInsets.all(20),
            physics:  new BouncingScrollPhysics(),
            itemCount: _noteList.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                key: Key(_noteList[index].id),
                child: NoteItem(_noteList[index], index: index,),
              );
            },
            staggeredTileBuilder: (int index) {
              // return StaggeredTile.fit(4);
              Note note = _noteList[index];
              double cardWidth = ( Adapt.screenW() - 60 ) / 2;
              // 手机屏幕宽高比
              double proportion = Adapt.screenW() / Adapt.screenH();
              double heigthTile = 1.15;
              // print('cardWidth$cardWidth');
              // 字体大小占比
              // 一行字体高度 / card * 2
              double fontSize = 18 / cardWidth * 2;
              if (note.imgUrl != "" && note.content != '') {
                heigthTile = 2 / proportion * note.heigth + (note.content.length * 12 / (cardWidth - 20)).ceil() * fontSize + 0.7;
              } else if (note.imgUrl != '') {
                heigthTile = 2 / proportion * note.heigth + 0.5;
              } else if (note.content != '') {
                heigthTile = (note.content.length * 12 / (cardWidth - 20)).ceil() * fontSize + 0.9;
              }

              heigthTile = double.parse(heigthTile.toStringAsFixed(2));
              return StaggeredTile.count(2, heigthTile);
            },
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 6.0,
          
    );
  }
}








