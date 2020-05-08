// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseData _$BaseDataFromJson(Map<String, dynamic> json) {
  return BaseData(
      ret: json['ret'] == null
          ? null
          : Ret.fromJson(json['ret'] as Map<String, dynamic>),
      data: json['data'],
      api: json['api'] as String);
}

Map<String, dynamic> _$BaseDataToJson(BaseData instance) => <String, dynamic>{
      'ret': instance.ret,
      'data': instance.data,
      'api': instance.api
    };

Ret _$RetFromJson(Map<String, dynamic> json) {
  return Ret(msg: json['msg'] as String, code: json['code'] as int);
}

Map<String, dynamic> _$RetToJson(Ret instance) =>
    <String, dynamic>{'code': instance.code, 'msg': instance.msg};
