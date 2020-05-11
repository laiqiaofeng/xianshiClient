import 'package:common_utils/common_utils.dart';
import 'package:demo/common/Global.dart';
import 'package:demo/components/Slider.dart';
import 'package:demo/event/event_bus.dart';
import 'package:demo/event/event_model.dart';
import 'package:demo/model/note.dart';
import 'package:demo/model/plan.dart';
import 'package:demo/routes/applicationRouter.dart';
import 'package:demo/utils/adaptUtil.dart';
import 'package:demo/views/main/note/components/noteCardListDialog.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class MyDialog {
  static YYDialog popupDialog({
    @required YYDialog yyDialog, 
    @required  Widget child,
    double height,
    Function() showCallBack,
    Function() dismissCallBack}) {
      return yyDialog
      ..width = Adapt.screenW()
      ..height = height ?? Adapt.screenH() * 0.7
      ..gravity = Gravity.bottom
      ..backgroundColor = Colors.white
      ..duration = Duration(microseconds: 375)
      ..borderRadius = 10
      ..barrierDismissible = false
      ..showCallBack = showCallBack ?? () {
        print("showCallBack invoke");
      }
      ..dismissCallBack = dismissCallBack ?? () {
        print("dismissCallBack invoke");
      }
      ..widget(child)
      ..animatedFunc = (child, animation) {
        return SizeTransition(
          child: child,
          sizeFactor: Tween(begin: 0.0, end: 1.0).animate(animation)
          // scale: Tween(begin: 0.0, end: 1.0).animate(animation),
        );
      };
  }

  static YYDialog loadingDialog ({@required BuildContext context}) {
    return YYDialog().build(context);
  }
  
  static YYDialog willPopDialog ({
    @required BuildContext context, 
    @required String hint,
    String text1,
    String text2,
    VoidCallback onTap1,
    VoidCallback onTap2
  }) {
    return YYDialog().build(context)
    ..width = 220
    ..borderRadius = 10.0
    ..text(
      padding: EdgeInsets.all(25.0),
      alignment: Alignment.center,
      text: hint,
      color: Colors.black,
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
    )
    ..divider()
    ..doubleButton(
      padding: EdgeInsets.only(top: 10.0),
      gravity: Gravity.center,
      withDivider: true,
      text1:  text1 ?? "取消",
      color1: Colors.redAccent,
      fontSize1: 14.0,
      fontWeight1: FontWeight.bold,
      onTap1: onTap1 ?? () {
        print("取消");
      },
      text2: text2 ?? "确定",
      color2: Colors.redAccent,
      fontSize2: 14.0,
      fontWeight2: FontWeight.bold,
      onTap2: onTap2 ?? () {
        print("确定");
        ApplicationRouter.router.pop(context);
      },
    )
    ..show();
  }

  static YYDialog planDialog ({@required BuildContext context, @required Plan plan}) {
    return YYDialog().build(context)
    ..width = Adapt.screenW() * 0.8
    ..borderRadius = 10.0
    ..widget(
      Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("${plan.name}"),
            Card(
              margin: EdgeInsets.only(top: 10),
              color: plan.planType == 'improtant' ? Colors.redAccent.withOpacity(0.2) : Colors.blueAccent.withOpacity(0.2) ,
              elevation: 0,
              child: ListTile(
                title: Text('日期提醒', style: TextStyle(fontSize: 14, color: Global.assistFontColor),),
                trailing: Text(DateUtil.formatDate(DateTime.parse(plan.createDateTime).toUtc(), format: 'MM月dd日 HH:mm'), style: TextStyle(color: Global.assist2FontColor),),
              ),
            ),
            AnimationLimiter(
              child: Container(
                  // padding: EdgeInsets.only(left: 20, right: 20),
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: plan.targetList.length,
                    itemBuilder: (BuildContext context, int index) {
                      String target = plan.targetList[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: Text("·$target")
                          ),
                        ),
                      );
                    },
                  )
              ),
            )
          ],
        ),
      )
    )
    ..show();
  }

  static YYDialog colorSelectDialog ({@required BuildContext context, Color color}) {
    return YYDialog().build(context)
    ..width = Adapt.screenW() * 0.8
    ..borderRadius = 10.0
    ..widget(
      Container(
        width: Adapt.screenW() * 0.6,
        height: Adapt.screenW() * 0.5,
        child: MaterialColorPicker(
          onColorChange: (Color color) {
              // Handle color changes
              ApplicationEvent.event.fire(NoteParamChange(color: color));
          },
          selectedColor: color ?? Colors.red
        ),
      )
    )
    ..show();
  }

  static YYDialog sliderDialog ({@required BuildContext context, @required value, Color color, double maxValue = 1.0, double minValue = 0.0}) {
    return YYDialog().build(context)
    ..width = Adapt.screenW()
    ..height = Adapt.screenH() * 0.2
    ..borderRadius = 10.0
    ..gravity = Gravity.bottom
    ..dismissCallBack = () {
      ApplicationEvent.event.fire(NoteParamChange(isDragEnd: true));
    }
    ..widget(
      Container(
        width: double.infinity,
        height: Adapt.screenH() * 0.2 - 20,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('滑动改变图片高度'),
            MySlider(value, maxValue, minValue, color: color,),
          ],
        ),
      )
    )
    ..show();
  }

  static YYDialog bottomPopupSingleButtonDialog ({
    @required BuildContext context, 
    Color color,
    String text,
    String buttonText,
    VoidCallback onPressed
  }) {
    YYDialog yyDialog = YYDialog().build(context);
          
            yyDialog..width = Adapt.screenW()
            ..height = Adapt.screenH() * 0.25
            ..gravity = Gravity.bottom
            ..borderRadius = 10
            ..duration = Duration(milliseconds: 200)
            ..widget(
              Container(
                height: Adapt.screenH() * 0.25 - 20,
                width: double.infinity,
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.close), 
                          onPressed: () {
                            yyDialog.dismiss();
                          })
                      ],
                    ),
                    Text("$text"),
                    Padding(padding: EdgeInsets.only(top: 16)),
                    FlatButton(
                      color: color ?? Global.themeColor,
                      onPressed: onPressed, 
                      child: Text("$buttonText" ?? "确定", style: TextStyle(color: Colors.white),))
                  ],
                ),
              )
            )
            ..show();
  }

  static YYDialog noteCardDialog ({@required BuildContext context, @required List<Note> noteList, @required int index}) {
    YYDialog yyDialog = YYDialog().build(context);
    return yyDialog
    ..width = Adapt.screenW()
    ..height = Adapt.screenH()
    ..borderRadius = 10.0
    ..backgroundColor = Colors.transparent
    ..widget(
      GestureDetector(
        onTap: () {
          yyDialog.dismiss();
        },
        child: NoteCardListDialog(noteList, index)
      )
    )
    ..animatedFunc = (Widget child, Animation<double> animation) {
      return ScaleTransition(
        child: child,
        scale: Tween(begin: 0.0, end: 1.0).animate(animation),
      );
    }
    ..show();
  }
}