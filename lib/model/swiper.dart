import 'package:json_annotation/json_annotation.dart';

part 'swiper.g.dart';

@JsonSerializable()
class SwiperItem {
  @JsonKey(name : "imgUrl")
  String imgUrl;

  @JsonKey(name : "title")
  String title;

  @JsonKey(name:"articleUrl")
  String articleUrl;

  SwiperItem({this.imgUrl, this.title, this.articleUrl});


  factory SwiperItem.fromJson(Map<String, dynamic> json) => _$SwiperItemFromJson(json);
 
  Map<String,dynamic> toJson() => _$SwiperItemToJson(this);
}