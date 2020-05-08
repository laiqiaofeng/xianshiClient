import 'package:demo/common/Global.dart';
import 'package:demo/event/event_bus.dart';
import 'package:demo/event/event_model.dart';
import 'package:demo/utils/adaptUtil.dart';
import 'package:flutter/material.dart';

class MySlider extends StatefulWidget {
  double value;
  double maxValue;
  double minValue;
  Color color;
  MySlider(this.value, this.maxValue, this.minValue, {Key key, this.color}) : super(key: key);

  @override
  _MySliderState createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
  double _value;
  bool _isChange = false;
  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Slider(
        max: widget.maxValue,
        min: widget.minValue,
        value: _value,
        label: '${(Adapt.screenH() * (0.4 + _value)).roundToDouble()}px',
        divisions:  1000,
        activeColor: widget.color ?? Global.themeColor,
        onChanged: (double value) {
          _isChange = true;
          setState(() {
            _value = double.parse(value.toStringAsFixed(3));
          });
          ApplicationEvent.event.fire(NoteParamChange(height: double.parse(value.toStringAsFixed(3))));
        },
      ),
    );
  }
}