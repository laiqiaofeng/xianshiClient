// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Article _$ArticleFromJson(Map<String, dynamic> json) {
  return Article(
      title: json['title'] as String,
      url: json['url'] as String,
      nickname: json['nickname'] as String)
    ..avatar = json['avatar'] as String
    ..desc = json['desc'] as String
    ..digg = json['digg']
    ..views = json['views']
    ..comments = json['comments'];
}

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
      'title': instance.title,
      'url': instance.url,
      'nickname': instance.nickname,
      'avatar': instance.avatar,
      'desc': instance.desc,
      'digg': instance.digg,
      'views': instance.views,
      'comments': instance.comments
    };
