import 'dart:async';
import 'dart:convert';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:demo/common/Global.dart';
import 'package:demo/components/EmptyPage.dart';
import 'package:demo/event/event_bus.dart';
import 'package:demo/event/event_model.dart';
import 'package:demo/http/http.dart';
import 'package:demo/model/plan.dart';
import 'package:demo/views/main/plan/components/PlanItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PlanList extends StatefulWidget {
  String planState;
  String userId;
  String planType;
  PlanList(this.planState, {Key key, @required this.userId, this.planType = 'all'}) : super(key: key);

  @override
  _PlanListState createState() => _PlanListState();
}

class _PlanListState extends State<PlanList> with AutomaticKeepAliveClientMixin {
  String _planType;
  String _planState;
  int _pageIndex;
  int _pageSize;
  List<Plan> _planList;
  bool _listFinished = false;
  EasyRefreshController _scrollController;
  StreamSubscription _eventDelete;
  StreamSubscription _eventChangePlanType;
  StreamSubscription _eventAddPlan;
  @override
  void initState() {
    super.initState();
    _scrollController = EasyRefreshController();
    _pageIndex = 1;
    _pageSize = 10;
    _planList = [];
    _planType = widget.planType;
    _planState = widget.planState;
    _eventDelete = ApplicationEvent.event.on<DeletePlan>().listen((event) {
      print('贱人${event.index}${event.type}${event.planState}');
      if ((event.index >= 0) && (event.index < _planList.length) && (event.planState == _planState)) {
        if (event.type == 'update'){
          _updatePlan(event.index, event.updateData ?? {"state": "finish"});
        } else {
          _deletePlan(event.index);
        }
      }
    
    });
    _eventChangePlanType = ApplicationEvent.event.on<ChangePlanType>().listen((event) {
      _planType = event.planType ?? 'all';
      getPlanList(extra: {"noCache": true}).then((dynamic planList) {
        setState(() {
          _planList = planList;
        });
      });
      // _onRefresh();
    });

    _eventAddPlan = ApplicationEvent.event.on<AddPlan>().listen((event) {
      if (event.planState == _planState) {
        _onRefresh();
      }
    });

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('类型改变${widget.planType}');
  }

  @override
  void dispose() { 
    super.dispose();
    _scrollController.dispose();
    _eventDelete.cancel();
    _eventChangePlanType.cancel();
    _eventAddPlan.cancel();
  }

  Future _deletePlan (int index) async {
    Plan plan = _planList[index];
    Http.dalatePlan(plan.id, extra: {"noCache": true}).then((data) {
      if (data == 'success') {
        setState(() {
          Fluttertoast.showToast(msg: '任务已删除', gravity: ToastGravity.TOP);
          _planList.removeAt(index);
        });
      }
    });
  }

  Future _updatePlan (int index, Map<String, dynamic> updateData) async {
    print(index);
    Plan plan = _planList[index];
    Http.updatePlan(plan.id, updateData , extra: {"noCache": true}).then((data) {
      if (data == 'success') {
        setState(() {
          _planList.removeAt(index);
        });
        Fluttertoast.showToast(msg: '修改成功', gravity: ToastGravity.TOP);
        ApplicationEvent.event.fire(AddPlan(_planState == 'finish' ? 'underway' : 'finish'));
      }
    });
  }

  Future<void> _onRefresh () async {
    print('请求了');
    _pageIndex = 1;
    getPlanList().then((dynamic planList) {
      setState(() {
        _planList = planList;
      });
    });
  }

  Future<void> _onLoad () async {
    print('请求了');
    if (_listFinished) {
      return; 
    }
    getPlanList().then((dynamic planList) {
      setState(() {
        _planList.addAll(planList);
      });
    });
      
  }

  Future getPlanList ({Map<String, dynamic> extra}) {
    return  Http.getPlanList(
      widget.userId, 
      _pageIndex, 
      _pageSize, 
      _planState, 
      _planType,
      extra: extra ?? {
        "refresh": true,
        "list": true
      }
    ).then((data) {
      var res = json.decode(json.encode(data));
      List list = res['list'] ?? [];
      int total = res['total'];
      List<Plan> planList = [];
      list.forEach((var item) {
        Plan planItem = Plan.fromJson(item);
        planList.add(planItem);
      });
      if ( total <= _pageIndex * _pageSize) {
        _listFinished = true;
      } else {
        _pageIndex ++;
      }
      return planList;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return EasyRefresh.custom(
      primary: true,
      footer: BallPulseFooter(
        color: Global.themeColor
      ),
      header: BezierCircleHeader(
        color: Global.assistThemeColor,
        backgroundColor: Global.themeColor
      ),
      onRefresh: _onRefresh,
      onLoad: _onLoad,
      controller: _scrollController,
      firstRefresh: true,
      slivers: <Widget>[
        _planList.length == 0 ?
        SliverFillRemaining(
          child: EmptyPage(hintText: _planState == 'underway' ? '暂无计划, 赶快去创建吧' : '暂无已完成计划',) ,
        )
        : 
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final Plan plan = _planList[index];
              return AnimationConfiguration.staggeredList(
                position: index,
                // 默认是使用index为key值的，会造成widget重复利用的情况
                key: Key(plan.id),
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: PlanItem(plan, index),
                  ),
                ),
              );
            },
            childCount: _planList.length,
          )
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}