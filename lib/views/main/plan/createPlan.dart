
import 'dart:async';
import 'package:demo/http/http.dart';
import 'package:demo/model/plan.dart';
import 'package:demo/provider/user.dart';
import 'package:demo/routes/applicationRouter.dart';
import 'package:flustars/flustars.dart'; 
import 'package:demo/components/CenterTitleAppBar.dart';
import 'package:demo/components/Dialog.dart';
import 'package:demo/event/event_bus.dart';
import 'package:demo/event/event_model.dart';
import 'package:demo/utils/adaptUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'components/TargetDialog.dart';

class CreatePlan extends StatefulWidget {
  CreatePlan({Key key}) : super(key: key);

  @override
  _CreatePlanState createState() => _CreatePlanState();
}

class _CreatePlanState extends State<CreatePlan> {

  FocusNode _focusNode;
  ScrollController _scrollController;
  TextEditingController _planNameController;
  String _type;
  List<String> _targetList;
  YYDialog _yyDialog;
  StreamSubscription _event;
  String _remindDate = '';
  String _remindTime = '';
  double _scale;
  GlobalKey<FormState> _formKey;
  String _userId;
  @override
  void initState() {
    super.initState();
    _scale = 0;
    _formKey = GlobalKey<FormState>();
    _yyDialog = YYDialog().build(context);  
    _yyDialog = MyDialog.popupDialog(yyDialog: _yyDialog, child: TargetDialog(yydialog: _yyDialog,));
    _targetList = [];
    _type = 'important';
    _focusNode = FocusNode();
    _scrollController = ScrollController();
    _planNameController = TextEditingController();
    _event = ApplicationEvent.event.on<AddPlanTarget>().listen((event) {
      if (event.context != '') {
        setState(() {
        _targetList.add(event.context);
      });
      }
    });
  }


  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _event.cancel();
    _scrollController.dispose();
    _planNameController.dispose();
    _yyDialog.dismiss();
  }
  
Widget _createTypeRadio (Color color, String type, String name) {
  return GestureDetector(
    onTap: () {
      FocusScope.of(context).requestFocus(_focusNode);
      setState(() {
        _type = type;
      });
    },
    child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.all(5),
        width: Adapt.px(160),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(20),
              color: _type == type ? color : Colors.grey,
              child: Container(
                width: Adapt.px(40),
                height: Adapt.px(40),
              ),
            ),
            Text("$name")
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _userId = Provider.of<UserModel>(context).user == null ? '' : Provider.of<UserModel>(context).user.id;
    return Scaffold(
      appBar: CenterTitleAppBar.appBar(context, '添加计划', onPressed: () {
        MyDialog.willPopDialog(context: context, hint: "退出将不会保存编辑内容, 确认退出吗?");
      }),
      backgroundColor: Color(0xffeeeeee),
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(_focusNode);
          },
          child: ListView(
             //滑动效果，如阻尼效果等等
            physics: const BouncingScrollPhysics(),
            //滑动控件是否在头部上面滑过去
            shrinkWrap: false,
            controller: _scrollController,
            padding: EdgeInsets.all(10),
            children : <Widget>[
              Card(
                elevation: 0.4,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Form(
                    key: _formKey,
                    autovalidate: true,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _planNameController,
                          decoration: InputDecoration(
                            labelText: "输入计划名称:",
                            // border: UnderlineInputBorder(
                            //   borderRadius: BorderRadius.circular(2)
                            // )
                            border: InputBorder.none
                          ),
                          validator: (String value) {
                            if (value == '') return '名称不能为空';
                            if (value.length > 10) return '名称过长'; 
                            return null;
                          },
                        ),
                      ],
                    )
                  )
                )
              ),
              Card(
                elevation: 0.4,
                margin: EdgeInsets.only(top: 5, left: 3, right: 3),
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('选择计划类型:', style: TextStyle(fontSize: 16, color: Colors.black54),),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          _createTypeRadio(Colors.redAccent, 'important', '重要的'),
                          _createTypeRadio(Colors.blueAccent, 'relaxed', '轻松的')
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 0.4,
                margin: EdgeInsets.only(top: 8, left: 3, right: 3),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('添加计划目的:', style: TextStyle(fontSize: 16, color: Colors.black54),),
                      // Padding(padding: EdgeInsets.only(top: 20)),
                      ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _targetList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return createTargetCard(_targetList[index], index);
                      }),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      Center(
                        child: SizedBox(
                          width: Adapt.px(160),
                          height: Adapt.px(100),
                          child: FlatButton(
                            onPressed: () {
                              _yyDialog.show();
                            },   
                            color: Colors.transparent,
                            child: Material(
                              borderRadius: BorderRadius.circular(30),
                              color: Color.fromRGBO(10, 10, 10, 0.1),
                              child: Container(
                                width: 40,
                                height: 40,
                                child: Icon(Icons.add, size: 30, color: Colors.blueAccent,),
                              )
                            ),
                          )
                        )
                      )
                    ],
                  ),
                )
              ),
              Card(
                elevation: 0.4,
                margin: EdgeInsets.only(top: 8, left: 3, right: 3),
                child: Container(
                  // padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      FlatButton(
                        onPressed: () async {
                          FocusScope.of(context).requestFocus(_focusNode);
                          var date = await showDatePicker(
                            context: context, 
                            initialDatePickerMode: DatePickerMode.day,
                            initialDate: DateTime.now(), 
                            firstDate: DateTime(DateTime.now().year), 
                            lastDate: DateTime(DateTime.now().year + 1),
                            // locale: Locale()
                          );
                          setState(() {
                            _remindDate = DateUtil.formatDate(date, format: 'yyyy-MM-dd');
                            if (_remindDate != '') {
                              _scale = 1;
                            }
                          });
                        }, 
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          textBaseline: TextBaseline.ideographic,
                          children: <Widget>[
                            Icon( _remindDate == null ? Icons.add : IconData(0xe63c, fontFamily: 'iconfont'), color: Colors.blueAccent, size: 18,),
                            Padding(padding: EdgeInsets.only(left: 10)),
                            Container(
                              height: 20,
                              margin: EdgeInsets.only(top: 4),
                              child: Center(
                                child: Text((_remindDate == null || _remindDate =='') ? '添加日期提醒' : _remindDate, style: TextStyle(
                                  color: Colors.grey, 
                                  fontSize: 16, 
                                  height: 1, )),
                              ),
                            )
                          ],
                        )
                      ),
                      
                    ],
                  ),
                ),
              ),
              Transform.scale(
                scale: _scale,
                child: Card(
                elevation: 0.4,
                margin: EdgeInsets.only(top: 8, left: 3, right: 3),
                child: Container(
                  // padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      FlatButton(
                        onPressed: () async {
                          FocusScope.of(context).requestFocus(_focusNode);
                          var time = await showTimePicker(
                            context: context, 
                            initialTime: TimeOfDay.now()
                          );
                          setState(() {
                            _remindTime = time.format(context);
                          });
                        }, 
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          textBaseline: TextBaseline.ideographic,
                          children: <Widget>[
                            Icon( _remindTime == null ? Icons.add : IconData(0xe616, fontFamily: 'iconfont'), color: Colors.blueAccent, size: 18,),
                            Padding(padding: EdgeInsets.only(left: 10)),
                            Container(
                              height: 20,
                              margin: EdgeInsets.only(top: 4),
                              child: Center(
                                child: Text((_remindTime == null || _remindTime =='') ? '添加时间提醒' : _remindTime, style: TextStyle(
                                  color: Colors.grey, 
                                  fontSize: 16, 
                                  height: 1, )),
                              ),
                            )
                          ],
                        )
                      ),
                      
                    ],
                  ),
                ),
              ),
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.only(top: 20, left: 3, right: 3),
                  width: Adapt.screenW(),
                  height: Adapt.px(140),
                  child: RaisedButton(
                    color: Colors.blueAccent,
                    onPressed: () {
                      FocusScope.of(context).requestFocus(_focusNode);
                      var _form = _formKey.currentState;
                      if (_form.validate() && _targetList.length != 0) {
                        Http.createPlan(
                          userId: _userId, 
                          name: _planNameController.text, 
                          targetList: _targetList, 
                          type: _type,
                          remindDateTime: '$_remindDate ${_remindTime ?? '10:00'}'
                        ).then((data) {
                          print(data);
                          if (data != null) {
                            Fluttertoast.showToast(msg: '创建成功', gravity: ToastGravity.TOP);
                            ApplicationRouter.router.pop(context);
                            ApplicationEvent.event.fire(AddPlan('underway'));
                            ApplicationEvent.event.fire(UpdateNoteAndPlanCount());
                          }
                          
                        });
                      } else {
                        Fluttertoast.showToast(msg: '请正确填写名称或添加目标', gravity: ToastGravity.TOP);
                      }
                    }, 
                    child: Text('确定添加', style: TextStyle(color: Colors.white, fontSize: 18),)
                  ),
                ),
              )   
            ],
          ),
        ),
      );
  }
  Widget createTargetCard (String target, int index) {
    return SizedBox(
      child: ListTile(
        title: Text("$target"),
        trailing: IconButton(
          icon: Icon(Icons.close, size: 16), 
          onPressed: () {
            setState(() {
              _targetList.removeRange(index, index + 1);
            });
          } 
        )
      ),
    );
  }
}


class Target {
  String context = '';
  Target({this.context});
}

