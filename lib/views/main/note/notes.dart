
import 'package:demo/common/Global.dart';
import 'package:demo/event/event_bus.dart';
import 'package:demo/event/event_model.dart';
import 'package:demo/provider/user.dart';
import 'package:demo/routes/applicationRouter.dart';
import 'package:demo/routes/routers.dart';
import 'package:demo/utils/adaptUtil.dart';
import 'package:demo/views/main/note/components/noteList.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import '../components/notLoginEmptyPage.dart';
import 'components/SecondFloorWidget.dart';

/// 二楼示例页面
class NotesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NotesPageState();
  }
}

class NotesPageState extends State<NotesPage>  with SingleTickerProviderStateMixin{
  LinkHeaderNotifier _linkNotifier;
  ValueNotifier<bool> _secondFloorOpen;
  EasyRefreshController _scrollController;
  bool _isLogin;
  bool _showButton = true;
  String userId;
  int _pageSize = 10;
  int _pageIndex = 1;
  bool _listFinished = false;
  @override
  void initState() {
    super.initState();
    userId = Global.profile.user != null ? Global.profile.user.id : '';
    _linkNotifier = LinkHeaderNotifier();
    _secondFloorOpen = ValueNotifier<bool>(false);
    _scrollController = EasyRefreshController();
    _secondFloorOpen.addListener(() {
      ApplicationEvent.event.fire(BottomNavVisible(!_secondFloorOpen.value));
    });

    ApplicationEvent.event.on<BottomNavVisible>().listen((event) {
      print(event.visible);
      setState(() {
        _showButton = event.visible ?? true;
      });
    });

    
  }

  @override
  void dispose() {
    super.dispose();
    _linkNotifier.dispose();
    _secondFloorOpen.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
      builder: (BuildContext context, userModel, Widget child) {
        _isLogin =  userModel.isLogin;
        return !_isLogin ? 
          Scaffold(
            appBar: AppBar(
              leading: null,
              automaticallyImplyLeading: false,
              title: Text('便签'),
              centerTitle: true,
            ),
            body: NotLoginEmptyPage(),
          )
          :
          Scaffold(
          floatingActionButton: _showButton ? 
          FloatingActionButton(
            onPressed: () {
              ApplicationRouter.router.navigateTo(context, Routes.createNotePage);
            },
            child: Icon(Icons.add, size: 32,),
            backgroundColor: Global.themeColor,
            elevation: 10,
            heroTag: 'note'
          )
          :
          null,
          body: Column(
            children: <Widget>[
              SecondFloorWidget(_linkNotifier, _secondFloorOpen),
              Expanded(
                child: EasyRefresh.custom(
                  footer: BallPulseFooter(
                    color: Global.themeColor
                  ),
                  header: LinkHeader(
                    _linkNotifier,
                    extent: 120.0,
                    triggerDistance: 140.0,
                    completeDuration: Duration(milliseconds: 500),
                  ),
                  onRefresh: () async {
                    ApplicationEvent.event.fire(NoteLoad('refresh'));
                    if (_secondFloorOpen.value) return;
                  },
                  firstRefresh: true,
                  onLoad: () async {
                     ApplicationEvent.event.fire(NoteLoad('load'));
                  },
                  controller: _scrollController,
                  slivers: <Widget>[
                    SliverAppBar(
                      floating: true,
                      snap: true,
                      stretch: true,
                      pinned: true,
                      automaticallyImplyLeading: false,
                      title: Text('便签', style: TextStyle(color: Colors.white),),
                      centerTitle: true,
                      iconTheme: IconThemeData(
                        color: Colors.white
                      ),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {

                          }, 
                          child: SizedBox(
                            width: Adapt.px(60),
                            height: Adapt.px(60),
                            child: Image.asset('assets/icons/square.png'),
                          )
                        ),
                      ],
                    ),
                    SliverFillRemaining(        // 剩余补充内容TabBarView
                      child: NoteList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}



PopupMenuItem selectView(Color color, String text, String id) {
    return new PopupMenuItem<String>(
        value: id,
        child: Container(
          width: Adapt.px(140),
          child:  new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
                Material(
                  color: color,
                  elevation: 3,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: Adapt.px(30),
                    height: Adapt.px(30),
                  ),
                ),
                new Text("$text", style: TextStyle(fontSize: 14),),
            ],
        ),
        )
    );
}
