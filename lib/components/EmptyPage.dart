
import 'package:demo/utils/adaptUtil.dart';
import 'package:flutter/material.dart';

class EmptyPage extends StatefulWidget {
  EmptyPage({Key key, this.hintText = '暂无数据', this.onTap}) : super(key: key);
  String hintText;
  GestureTapCallback onTap;
  @override
  _EmptyPageState createState() => _EmptyPageState();
}

class _EmptyPageState extends State<EmptyPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap ?? () {},
      child: Container(
        padding: EdgeInsets.only(top: 80, bottom: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: Adapt.px(200),
              height: Adapt.px(200),
              child: Image.asset('assets/images/empty.png'),
            ),
            Padding(padding: EdgeInsets.only(top: 15)),
            Text("${widget.hintText}", style: TextStyle(color: Colors.grey),)
          ],
        ),
      ),
    );
  }
}