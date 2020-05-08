import 'package:demo/event/event_bus.dart';
import 'package:demo/event/event_model.dart';
import 'package:demo/utils/adaptUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';


class TargetDialog extends StatefulWidget {
  YYDialog yydialog;
  TargetDialog({@required this.yydialog,  key}) : super(key: key);

  @override
  _TargetDialogState createState() => _TargetDialogState();
}

class _TargetDialogState extends State<TargetDialog> {
  FocusNode _focusNode;
  TextEditingController _contextController;
  String _context = '';
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _contextController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _contextController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Column(
         children: <Widget>[
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  widget.yydialog?.dismiss();
                }, 
                child: Text('取消')
              ),
              FlatButton(
                onPressed: _context == '' ? null : () {
                  print(_contextController.text);
                  ApplicationEvent.event.fire(AddPlanTarget(context: _context));
                  widget.yydialog?.dismiss();
                }, 
                child: Text('保存', style: TextStyle(fontWeight: FontWeight.bold, color: _context == '' ? Colors.grey : Colors.blueAccent),)
              ),
              
            ],
          ),
          Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                width: Adapt.screenW(),
                // height: Adapt.screenH() * 2,
                child: TextField(
                  focusNode: _focusNode,
                  controller: _contextController,
                  maxLines: 1,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: '添加目标',
                    
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _context = value;
                    });
                  },
                ),
              ),
         ],
       ),
    );
  }
}