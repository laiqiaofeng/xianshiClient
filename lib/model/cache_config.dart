import 'package:json_annotation/json_annotation.dart';

part 'cache_config.g.dart';

@JsonSerializable()
class CacheConfig {

  @JsonKey(name: 'enable')
  bool enable;

  @JsonKey(name: 'maxAge')
  num maxAge;

  @JsonKey(name: 'maxCount')
  num maxCount;
  CacheConfig({this.enable, this.maxAge, this.maxCount});

  factory CacheConfig.fromJson(Map<String, dynamic> json) => _$CacheConfigFromJson(json);
 
  Map<String,dynamic> toJson() => _$CacheConfigToJson(this);

}