import 'package:demo/http/http.dart';
import 'package:demo/routes/applicationRouter.dart';
import 'package:demo/routes/routers.dart';
import 'package:flutter/material.dart';


class InformationSearchPage extends SearchDelegate<String> {
  String searchFieldLabel = '请输入关键字';

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
      
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(IconData(0xe611, fontFamily: 'iconfont'), size: 14,),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Text('contailer')
    );
  }

  
  @override
  Widget buildSuggestions(BuildContext context) {
    // this.getData();
    return FutureBuilder(
      future: _getData(query),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        List resultList = [];
        if (snapshot.hasData) {
          resultList = snapshot.data;
        }
        print('这里的data又是什么${snapshot.data}');
        return ListView.builder(
          itemCount: resultList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text("${resultList[index]['value']}"),
              onTap: () {
                String url = "https://so.csdn.net/so/search/s.do?q=${Uri.encodeComponent(resultList[index]['value'])}&t=&u=";
                String title = resultList[index]['value'];
                ApplicationRouter.router.navigateTo(context, '${Routes.webviewPage}?url=${Uri.encodeComponent(url)}&title=${Uri.encodeComponent(title)}');
              },
            );
          }
        );
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      primaryColor: Colors.white,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
      primaryColorBrightness: Brightness.light,
      primaryTextTheme: theme.textTheme,
    );
  }
}


Future<List> _getData (String query) async {
    List resultList = [];
    if (query == '') {
      await Http.getCsdnSoHot().then((data) {
        if (data is List) {
          data.forEach( (item) {
            resultList.add({
              "value": item['word'] 
            });
          });
        }
      });
    }else {
      await Http.getDaiduSearchTips(query: query).then((data) {
        if (data is List) {
          data.forEach( (item) {
            resultList.add({
              "value": item['q'] 
            });
          });
        }
      });
    }
    print('请求的提示词$resultList');
    return resultList;
  }