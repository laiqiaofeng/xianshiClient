// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile(
      token: json['token'] as String,
      user: json['user'] == null
          ? null
          : UserInfo.fromJson(json['user'] as Map<String, dynamic>),
      cacheConfig: json['cacheConfig'] == null
          ? null
          : CacheConfig.fromJson(json['cacheConfig'] as Map<String, dynamic>),
      lastLogin: json['lastLogin'],
      theme: json['theme'],
      bgColor: json['bgColor']);
}

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'user': instance.user,
      'theme': instance.theme,
      'bgColor': instance.bgColor,
      'cacheConfig': instance.cacheConfig,
      'lastLogin': instance.lastLogin,
      'token': instance.token
    };
