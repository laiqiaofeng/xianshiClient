// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Plan _$PlanFromJson(Map<String, dynamic> json) {
  return Plan(
      name: json['name'] as String,
      createDateTime: json['createTime'] as String,
      remindDateTime: json['remindDateTime'] as String,
      userId: json['userId'] as String,
      id: json['id'] as String,
      state: json['state'] as String,
      planType: json['planType'] as String,
      targetList: json['targetList'] as List);
}

Map<String, dynamic> _$PlanToJson(Plan instance) => <String, dynamic>{
      'name': instance.name,
      'userId': instance.userId,
      'id': instance.id,
      'createTime': instance.createDateTime,
      'remindDateTime': instance.remindDateTime,
      'planType': instance.planType,
      'state': instance.state,
      'targetList': instance.targetList
    };
