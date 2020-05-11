import 'package:demo/utils/adaptUtil.dart';
import 'package:flutter/material.dart';

typedef SwitchRadioTapCallback = void Function<T>(T value);

class SwitchRadio extends StatefulWidget {

  SwitchRadio({
    Key key, 
    @required this.leftOnTap, 
    @required this.leftTitle, 
    @required this.rightOnTap, 
    @required this.rightTitle,
    @required this.leftValue,
    @required this.rightValue,
    this.defaultValue,
    this.height,
    this.width,
    this.leftActiveColor,
    this.rightActiveColor
  }) : assert(leftOnTap != null),
       assert(leftOnTap != null),
       assert(rightOnTap != null),
       assert(rightTitle != null),
       super(key: key);

  String leftTitle;
  String rightTitle;
  SwitchRadioTapCallback leftOnTap;
  SwitchRadioTapCallback rightOnTap;
  var leftValue;
  var rightValue;
  var defaultValue;
  double width;
  double height;
  Color leftActiveColor;
  Color rightActiveColor;

  @override
  _SwitchRadioState createState() => _SwitchRadioState();
}

class _SwitchRadioState extends State<SwitchRadio> {

  var _value;
  @override
  void initState() {
    _value = widget.defaultValue ?? widget.leftValue;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width ?? Adapt.px(200),
        height: widget.height ?? Adapt.px(80),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Material(
              color: _value == widget.leftValue ? (widget.leftActiveColor ?? Colors.blue) : Colors.grey,
              shadowColor: Color.fromRGBO(100, 100, 100, 0.5),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _value = widget.leftValue;
                  });
                  widget.leftOnTap(widget.leftValue);
                },
                child: Container(
                  width: Adapt.px(100),
                  height: Adapt.px(60),
                  child: Center(
                    child: Text("${widget.leftTitle}",  style: TextStyle(color: Colors.white),),
                  ),
                ),
              ),
            ),
            Material(
              color: _value == widget.rightValue ? (widget.rightActiveColor ?? Colors.redAccent) : Colors.grey,
              shadowColor: Color.fromRGBO(100, 100, 100, 0.5),
              borderRadius: BorderRadius.only(topRight: Radius.circular(4), bottomRight: Radius.circular(4)),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _value = widget.rightValue;
                  });
                  widget.rightOnTap(widget.rightValue);
                },
                child: Container(
                  width: Adapt.px(100),
                  height: Adapt.px(60),
                  child: Center(
                    child: Text("${widget.rightTitle}",  style: TextStyle(color: Colors.white),),
                  ),
                ),
              ),
            )
          ],
        ),
      );
  }
}