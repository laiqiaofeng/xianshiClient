import 'package:common_utils/common_utils.dart';
import 'package:demo/components/Dialog.dart';
import 'package:demo/event/event_bus.dart';
import 'package:demo/event/event_model.dart';
import 'package:demo/model/plan.dart';
import 'package:demo/routes/applicationRouter.dart';
import 'package:flutter/material.dart';

class PlanItem extends StatefulWidget {
  Plan plan;
  int index;
  PlanItem(this.plan, this.index, {Key key}) : super(key: key);

  @override
  _PlanItemState createState() => _PlanItemState();
}

class _PlanItemState extends State<PlanItem> {
  Plan _plan;
  bool _isFinish;
  @override
  void initState() {
    super.initState();
    _isFinish = false;
    _plan = widget.plan;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: widget.index == 0 ? 16 : 4, bottom: 4, right: 20, left: 20),
      child:  Material(
        borderRadius: BorderRadius.circular(12),
        color:  _plan.planType == 'important' ? Colors.redAccent.withOpacity(0.2) : Colors.blueAccent.withOpacity(0.2) ,
        child: InkWell(
          onTap: () {
            MyDialog.planDialog(context: context, plan: _plan);
          },
          child: Container(
            padding: EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    _plan.state == 'underway' ? IconButton(
                      icon: Icon(IconData(0xe63d, fontFamily: 'iconfont'), size: 16, color: Colors.white,), 
                      onPressed: () {
                        ApplicationEvent.event.fire(DeletePlan(widget.index, widget.plan.state,type:'update'));
                      }
                    ) : Padding(padding: EdgeInsets.only(left: 20)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(_plan.name ?? '', style: TextStyle(fontSize: 18),),
                        Text(DateUtil.formatDate(DateTime.parse(_plan.createDateTime).toUtc(), format: 'yyyy年MM月dd日 HH:mm')   ?? '', style: TextStyle(fontSize: 14, color: Colors.black54),)
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.close, size: 14, color: Colors.grey,), 
                  onPressed: () {
                    if (widget.plan.state == 'finish') {
                      MyDialog.willPopDialog(
                        context: context, 
                        hint: '是否把该任务重新设置为进行中?', 
                        text1: '确定删除', 
                        text2: '设为进行中',
                        onTap1: () {
                          ApplicationEvent.event.fire(DeletePlan(widget.index, widget.plan.state));
                        },
                        onTap2: () {
                          ApplicationEvent.event.fire(DeletePlan(widget.index, widget.plan.state, type: 'update', updateData: {
                            "state": 'underway'
                          }));
                        });
                    } else {
                      MyDialog.willPopDialog(
                        context: context, 
                        hint: '是否把该任务删除?', 
                        text1: '取消', 
                        text2: '确定',
                        onTap2: () {
                          ApplicationEvent.event.fire(DeletePlan(widget.index, widget.plan.state));
                        });
                    }
                    
                  }
                ),
              ],
            )
          ),
        )
      ),
    );
  }
}