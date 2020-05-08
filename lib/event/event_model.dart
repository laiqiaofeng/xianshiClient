import 'package:demo/model/article.dart';
import 'package:demo/model/note.dart';
import 'package:flutter/cupertino.dart';

// 获取 资讯文章数据
class InformationPageGetData {
  List<Article> articleList;
  String category;
  InformationPageGetData(this.articleList, this.category);
}


/// 点击输入框滚动条滚动
class TextFieldFocus {
  bool isFocus;
  double cardSize;
  TextFieldFocus(this.isFocus, this.cardSize);
}


// 选择性别

class ChooseSex {
  int sex;
  ChooseSex(this.sex);
}


// 添加计划中的目标

class AddPlanTarget {
  String context;
  AddPlanTarget({@required this.context});
}

// 获取计划列表
class ChangePlanType {
  String planType;
  ChangePlanType({@required this.planType});
}

// 删除计划

class DeletePlan {
  int index;
  String planState;
  String type;
  Map<String, dynamic> updateData;
  DeletePlan(this.index, this.planState, {this.type = 'delete', this.updateData});
}

// 添加计划

class AddPlan {
  String planState;
  AddPlan(this.planState);
}


// 底部导航栏隐藏
class BottomNavVisible {
  bool visible;
  BottomNavVisible(this.visible);
}

// 创建note 属性改变

class NoteParamChange {
  Color color;
  double height;
  bool isDragEnd;
  NoteParamChange({this.color, this.height, this.isDragEnd});
}


// note 列表请求

class NoteLoad {
  String type;

  // 是否同时更新便签列表 dialog
  bool isUpdateNoteListDialog;
  NoteLoad(this.type, {this.isUpdateNoteListDialog = false});
}


// 便签列表dialog更新
class UpdateNoteListDialog {
  List<Note> noteList;
  UpdateNoteListDialog(this.noteList);
}

// 点击展示标签

class ShowNoteListDialog {
  int index;
  ShowNoteListDialog(this.index);
}

// 删除  note

class DeleteNote {
  int index;
  DeleteNote(this.index);
}

// note plan 数量改变

class UpdateNoteAndPlanCount {
  UpdateNoteAndPlanCount();
}