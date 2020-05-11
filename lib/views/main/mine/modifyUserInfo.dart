import 'package:demo/common/Global.dart';
import 'package:demo/components/CenterTitleAppBar.dart';
import 'package:demo/components/SwitchRadio.dart';
import 'package:demo/event/event_bus.dart';
import 'package:demo/event/event_model.dart';
import 'package:demo/http/http.dart';
import 'package:demo/provider/user.dart';
import 'package:demo/routes/applicationRouter.dart';
import 'package:demo/utils/adaptUtil.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ItemOptions {
  
  ItemOptions({
    this.leftOnTap, 
    this.rightOnTap, 
    this.title, 
    this.controller, 
    this.type, 
    this.onPressed, 
    this.defalutValue,
    this.leftTitle,
    this.leftValue,
    this.rightTitle,
    this.rightValue
  });

  String title;
  VoidCallback onPressed;
  TextEditingController controller;
  String type;
  var defalutValue;
  var leftOnTap;
  var rightOnTap;
  String leftTitle; 
  String rightTitle; 
  var leftValue;
  var rightValue;
}



class ModifyUserInfoPage extends StatefulWidget {
  ModifyUserInfoPage({Key key}) : super(key: key);

  @override
  _ModifyUserInfoPageState createState() => _ModifyUserInfoPageState();
}

class _ModifyUserInfoPageState extends State<ModifyUserInfoPage> {

  List<ItemOptions> _itemList;
  FocusNode _blankNode;
  TextEditingController _userNameController;
  TextEditingController _signatureController;
  bool _hasModify;
  int _userSex;
  @override
  void initState() {
    super.initState();
    _blankNode = FocusNode();
    _userNameController = TextEditingController();
    _signatureController = TextEditingController();
    _hasModify = false;
    _userSex = 1;
    _userNameController.addListener(() {
      _hasModify = true;
    });
    _signatureController.addListener(() {
      _hasModify = true;
    });
    _itemList = [
      ItemOptions(
        title: '姓名',
        controller: _userNameController,
        type: 'text'
      ),
      ItemOptions(
        type: 'radio',
        title: '性别',
        leftOnTap: <int>(var value) {
          print('值切换$value');
        }, 
        rightOnTap: <int>(int value) {
          print('值切换$value');
        }, 
        leftTitle: '男', 
        rightTitle: "女", 
        leftValue: 1, 
        rightValue: 2,
      ),
      // ItemOptions(

      // )
    ];

    ApplicationEvent.event.on<ChooseSex>().listen((event) {
      _userSex = event.sex;
      print('性别发生改变$_userSex');
      _hasModify = true;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
      builder: (BuildContext context, userModel, Widget child) {
        String _signature =(userModel.user != null && userModel.user.signature != '') ? userModel.user.signature : '';
        String _userName = (userModel.user != null && userModel.user.userName != '') ? userModel.user.userName : '';
        String _id = userModel.user != null ? userModel.user.id : '';
        int _sex = userModel.user != null ? userModel.user.sex : 1;
        _signatureController.text = _signature;
        _userNameController.text = _userName;
        _itemList[1].defalutValue = _sex;
        _itemList[1].rightOnTap = <int>(int value) {
           FocusScope.of(context).requestFocus(_blankNode);
           ApplicationEvent.event.fire(ChooseSex(2));
        };
        _itemList[1].leftOnTap = <int>(int value) {
           FocusScope.of(context).requestFocus(_blankNode);
           ApplicationEvent.event.fire(ChooseSex(1));
        };
        return Scaffold(
          appBar: CenterTitleAppBar.appBar(context, '编辑'),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(_blankNode);
            },
            child: SingleChildScrollView(
              // color: Global.bgColor,
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  createItem(_itemList[0]),
                  Padding(padding: EdgeInsets.only(top: 5)),
                  createItem(_itemList[1]),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Material(
                    elevation: 0.4,
                    color: Colors.white, 
                    borderRadius: BorderRadius.circular(3),
                    child: Container(
                      width: Adapt.screenW(),
                      padding: EdgeInsets.all(20),
                      height: Adapt.px(400),
                      child: TextField(
                        controller: _signatureController,
                        maxLength: 100,
                        maxLines: 100,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '请输入您的个性签名 ~~'
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: Adapt.screenW(),
                    height: Adapt.px(120),
                    margin: EdgeInsets.only(top: 30),
                    child: FlatButton(
                      onPressed: () {
                        if (!_hasModify) return;
                        Http.modifyUserInfo(_id, {
                          "userName": _userNameController.text,
                          "sex": _userSex,
                          "signature": _signatureController.text
                        }).then((data) {
                          Global.profile.user.sex = _userSex;
                          Global.profile.user.signature = _signatureController.text;
                          Global.profile.user.userName = _userNameController.text;
                          Global.saveProfile();
                          // FlutterToast
                          Fluttertoast.showToast(msg: '修改成功', gravity: ToastGravity.TOP);
                        });
                      }, 
                      disabledColor: Color.fromRGBO(200, 200, 200, 1),
                      color: Colors.blue,
                      child: Center(
                        child: Text('确认修改', style: TextStyle(fontSize: 18, color: Colors.white),),
                      )
                    ),
                  )
                ],
              )
            ),
          )
        );
      },
    );
  }
}




Widget createItem (ItemOptions options) {
  return Material(
    borderRadius: BorderRadius.circular(3),
    color: Colors.white,
    elevation: 0.4,
    child: Container(
      padding: EdgeInsets.only(right:20, left: 20, top: 10, bottom: 10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("${options.title}", style: TextStyle(),),
              createFiled(options)
            ],
          )
        ],
      )
    ),
  );
}



Widget createFiled (ItemOptions options) {
  Widget filed;
  switch (options.type) {
    case "text":
      filed = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            width: Adapt.px(160),
            height: Adapt.px(100),
            child: TextField(
              controller: options.controller,
              style: TextStyle(

              ),
              maxLines: 1,
              decoration: InputDecoration(
              
                border: InputBorder.none
              ),
            ),
          ),
          Icon(IconData(0xe65e, fontFamily: 'iconfont'), size: 16, color: Colors.grey,)
        ],
      );
      break;
    case "radio": 
      filed = SwitchRadio(
        leftOnTap: options.leftOnTap, 
        rightOnTap: options.rightOnTap, 
        leftTitle: options.leftTitle, 
        rightTitle: options.rightTitle, 
        leftValue: options.leftValue, 
        rightValue: options.rightValue,
        defaultValue: options.defalutValue,);
      break;
    default:
      filed = Container();
  }
  return filed;
}