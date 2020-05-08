import 'package:demo/model/cache_config.dart';
import 'package:demo/model/user_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';


@JsonSerializable()
class Profile {

  @JsonKey(name: 'user')
  UserInfo user;
  
  @JsonKey(name: 'theme')
  var theme;

  @JsonKey(name: 'bgColor')
  var bgColor;

  @JsonKey(name: 'cacheConfig')
  CacheConfig cacheConfig;

  @JsonKey(name: 'lastLogin')
  var lastLogin;

  @JsonKey(name: 'token')
  String token;
  Profile({this.token, this.user, this.cacheConfig, this.lastLogin, this.theme, this.bgColor});


  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
 
  Map<String,dynamic> toJson() => _$ProfileToJson(this);
}