// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) {
  return Note(
      userId: json['userId'] as String,
      id: json['id'] as String,
      content: json['content'] as String,
      createTime: json['createTime'] as String,
      imgUrl: json['imgUrl'] as String,
      heigth: (json['height'] as num)?.toDouble(),
      color: json['color'] as String,
      showElevation: json['showElevation'] as bool,
      showFadeShadow: json['showFadeShadow'] as bool,
      repaintBoundaryKey: json['repaintBoundaryKey'])
    ..imageShare = json['imageShare'] as String;
}

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
      'userId': instance.userId,
      'id': instance.id,
      'createTime': instance.createTime,
      'content': instance.content,
      'imgUrl': instance.imgUrl,
      'height': instance.heigth,
      'color': instance.color,
      'showElevation': instance.showElevation,
      'showFadeShadow': instance.showFadeShadow,
      'repaintBoundaryKey': instance.repaintBoundaryKey,
      'imageShare': instance.imageShare
    };
