// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) {
  return UserInfo(
      id: json['id'] as String,
      userName: json['userName'] as String,
      avatarUrl: json['avatarUrl'] as String,
      bannerUrl: json['bannerUrl'] as String,
      createTime: json['createTime'],
      password: json['password'] as String,
      phone: json['phone'] as String,
      sex: json['sex'] as int,
      signature: json['signature'] as String,
      updateTime: json['updateTime']);
}

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'userName': instance.userName,
      'password': instance.password,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
      'id': instance.id,
      'phone': instance.phone,
      'sex': instance.sex,
      'signature': instance.signature,
      'bannerUrl': instance.bannerUrl,
      'avatarUrl': instance.avatarUrl
    };
