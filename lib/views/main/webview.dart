import 'package:demo/routes/applicationRouter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';


class WebViewPage extends StatefulWidget {
  final String url;
  final String title;
  WebViewPage( {Key key,this.url, this.title}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState(url: this.url, title: this.title);
}

class _WebViewPageState extends State<WebViewPage> {
  final String url;
  final String title;
  _WebViewPageState({this.url, this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
       child: WebviewScaffold(
         url: this.url,
         withZoom: true,
        //  initialChild: Text('加载中'),
         appBar: AppBar(
           elevation: 1,
           leading: IconButton(
             icon: Icon(Icons.close, color: Colors.white,),
             onPressed: () {
               ApplicationRouter.router.pop(context);
             },
           ),
           title: Text(this.title, style: TextStyle(color: Colors.black,fontSize: 14)),
          //  backgroundColor: Colors.white,
         ),
       ),
    );
  }
}