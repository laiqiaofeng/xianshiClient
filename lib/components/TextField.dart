import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextFiled extends StatefulWidget {

  GestureTapCallback onTap;
  ValueChanged<String> onChanged;
  TextEditingController controller;
  TextInputType keyboardType;
  bool obscureText;
  List<TextInputFormatter> inputFormatters;
  bool autocorrect;
  final String labelText;
  final String hintText;
  final String helperText;
  final IconData icon;
  final Widget suffixIcon;
  FormFieldValidator<String> validator;
  MyTextFiled({
    Key key,
    this.labelText,
    this.onTap,
    this.hintText = '提示',
    this.icon,
    this.controller,
    this.helperText,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.obscureText = false,
    this.inputFormatters,
    this.onChanged,
    this.validator,
    this.autocorrect = true
  }) : assert(labelText != null), 
      assert(controller != null),
      super(key: key);

  @override
  _MyTextFiledState createState() => _MyTextFiledState();
}

class _MyTextFiledState extends State<MyTextFiled> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      
      controller: widget.controller,
      style: TextStyle(
        color: Colors.white
      ),
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      autocorrect: widget.autocorrect,
      inputFormatters: widget.inputFormatters,
      decoration: new InputDecoration(
        icon: Icon(widget.icon, color:Colors.white),
        labelText: widget.labelText,
        hintText: widget.hintText,
        helperText: widget.helperText,
        suffixIcon: widget.suffixIcon,

        labelStyle: TextStyle(
          color:Colors.white,
        ),
        hintStyle: TextStyle(
          color: Colors.grey
        ),
        helperStyle: TextStyle(
          color: Colors.blue,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white
          )
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue
          )
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red
          )
        ),
        focusColor: Colors.white
      ),
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      validator: widget.validator,
    );
  }
}