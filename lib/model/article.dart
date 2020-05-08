import 'package:json_annotation/json_annotation.dart';

part 'article.g.dart';

@JsonSerializable()
class Article { 
  @JsonKey(name: 'title')
  String title;
  /// 文章地址
  @JsonKey(name: 'url')
  String url;
  /// 用户名
  @JsonKey(name: 'nickname')
  String nickname;
  /// 头像
  @JsonKey(name: 'avatar')
  String avatar;
  /// 描述
  @JsonKey(name: 'desc')
  String desc;
  /// 点赞数
  @JsonKey(name: 'digg')
  var digg;
  /// 观看人数
  @JsonKey(name: 'views')
  var views;
  /// 评论数
  @JsonKey(name: 'comments')
  var comments;

  Article({this.title, this.url, this.nickname});

  factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);
 
  Map<String,dynamic> toJson() => _$ArticleToJson(this);

}