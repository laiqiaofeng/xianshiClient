
import 'package:json_annotation/json_annotation.dart';

part 'note.g.dart';

@JsonSerializable()
class Note { 
  @JsonKey(name: 'userId')
  String userId;

  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'createTime')
  String createTime;

  @JsonKey(name: 'content')
  String content;

  @JsonKey(name: 'imgUrl')
  String imgUrl;

  @JsonKey(name: 'height')
  double heigth;

  @JsonKey(name: 'color')
  String color;

  @JsonKey(name: 'showElevation')
  bool showElevation;

  @JsonKey(name: 'showFadeShadow')
  bool showFadeShadow;

  @JsonKey(name: 'repaintBoundaryKey')
  var repaintBoundaryKey;

  @JsonKey(name: 'imageShare')
  String imageShare;

  Note({this.userId, this.id, this.content, this.createTime, this.imgUrl, this.heigth, this.color, this.showElevation, this.showFadeShadow, this.repaintBoundaryKey});

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
 
  Map<String,dynamic> toJson() => _$NoteToJson(this);

}