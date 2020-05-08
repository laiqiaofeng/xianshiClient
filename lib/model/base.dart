import 'package:json_annotation/json_annotation.dart';

part 'base.g.dart';

@JsonSerializable()
class BaseData {
  @JsonKey(name: 'ret')
  Ret ret;

  @JsonKey(name: 'data')
  var data;

  @JsonKey(name: 'api')
  String api;

  BaseData({this.ret, this.data, this.api});

  factory BaseData.fromJson(Map<String, dynamic> json) => _$BaseDataFromJson(json);
 
  Map<String,dynamic> toJson() => _$BaseDataToJson(this);

}

@JsonSerializable()
class Ret extends Object {
  @JsonKey(name: 'code')
  int code;
  @JsonKey(name: 'msg')
  String msg;
  Ret({this.msg, this.code});
  factory Ret.fromJson(Map<String, dynamic> json) => _$RetFromJson(json);
 
  Map<String,dynamic> toJson() => _$RetToJson(this);
}

