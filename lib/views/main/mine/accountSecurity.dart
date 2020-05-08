import 'package:demo/components/CenterTitleAppBar.dart';
import 'package:demo/routes/applicationRouter.dart';
import 'package:demo/routes/routers.dart';
import "package:flutter/material.dart";


class AccountSecurity extends StatefulWidget {
  AccountSecurity({Key key}) : super(key: key);

  @override
  _AccountSecurityState createState() => _AccountSecurityState();
}

class _AccountSecurityState extends State<AccountSecurity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CenterTitleAppBar.appBar(context, '账户安全'),
      body: Container(
        padding: EdgeInsets.all(14),
        child: Column(
        children: <Widget>[
          Card(
            child: ListTile(
              onTap: () {
                ApplicationRouter.router.navigateTo(context, Routes.modifyPasswordPage);
              },
              // leading: Icon(IconData(0xe62e, fontFamily: 'iconfont'), size: 20,),
              title: Text('修改密码'),
              trailing: Icon(IconData(0xe65e, fontFamily: 'iconfont'), size: 16,),
            )
          )
        ],
      ),
      )
    );
  }
}