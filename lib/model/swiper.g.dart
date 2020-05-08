// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swiper.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SwiperItem _$SwiperItemFromJson(Map<String, dynamic> json) {
  return SwiperItem(
      imgUrl: json['imgUrl'] as String,
      title: json['title'] as String,
      articleUrl: json['articleUrl'] as String);
}

Map<String, dynamic> _$SwiperItemToJson(SwiperItem instance) =>
    <String, dynamic>{
      'imgUrl': instance.imgUrl,
      'title': instance.title,
      'articleUrl': instance.articleUrl
    };
