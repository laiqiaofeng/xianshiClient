import 'package:json_annotation/json_annotation.dart';
part 'user_info.g.dart';


@JsonSerializable()
class UserInfo {
  @JsonKey(name: 'userName')
  String userName;

  @JsonKey(name: 'password')
  String password;

  @JsonKey(name: 'createTime')
  var createTime;

  @JsonKey(name: 'updateTime')
  var updateTime;

  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'phone')
  String phone;

  @JsonKey(name: 'sex')
  int sex;

  @JsonKey(name: 'signature')
  String signature;

  @JsonKey(name: 'bannerUrl')
  String bannerUrl;

  @JsonKey(name: 'avatarUrl')
  String avatarUrl;

  UserInfo({this.id, this.userName, this.avatarUrl, this.bannerUrl, this.createTime, this.password, this.phone, this.sex, this.signature, this.updateTime});

  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);
 
  Map<String,dynamic> toJson() => _$UserInfoToJson(this);
}

