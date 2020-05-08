import 'package:demo/common/Global.dart';
import 'package:demo/components/CenterTitleAppBar.dart';
import 'package:demo/provider/theme.dart';
import 'package:demo/utils/adaptUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  List<Widget> _colorRadioList = List<Widget>(Global.themes.length);
  Color _currentTheme;
  List<Color> _colorList;
  ThemeModel _themeModel;
  @override
  void initState() {
    super.initState();
    _colorList = Global.themes;
    _currentTheme = _colorList[0];
    
    print('主题颜色有$_colorList');
  }

  Widget createColorRadio (Color color) {
    return GestureDetector(
      onTap: () {
        if (_currentTheme == color) return;
        _themeModel.theme = color;
        setState(() {
          _currentTheme = color;
        });
      },
      child: Material(
        color: color,
        type: MaterialType.card,
        shadowColor: color,
        borderRadius: BorderRadius.circular(20),
        elevation: 5,
        child: InkWell(
          radius: 15,
          child: AnimatedContainer(
            curve: Curves.easeInOut,
            duration:Duration(microseconds: 375),
            width: _currentTheme == color ? 30 : 20,
            height: _currentTheme == color ? 30 : 20,
            // child: ,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (BuildContext context, themeModel, Widget child) {
        _currentTheme = themeModel.theme ?? _colorList[0];
        _themeModel = themeModel;
        for(int i = 0; i < _colorList.length; i ++) {
          _colorRadioList[i] = createColorRadio(_colorList[i]);
        }
        return Scaffold(
          appBar: CenterTitleAppBar.appBar(context, '设置'),
          body: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 20)),
                Center(
                  child: Text('切换主题色', style: TextStyle(fontSize: 18, color: _currentTheme),)
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                SizedBox(
                  width: Adapt.screenW(),
                  child: Row(
                    // direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: _colorRadioList,
                  ),
                )
              ],
            )
        );
      }
    );
  }
}



