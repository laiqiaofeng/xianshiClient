import 'package:json_annotation/json_annotation.dart';

part 'plan.g.dart';

enum PlanType {
  relaxed,
  important
}

enum PlanState {
   // 正在进行中
    underway,
    // 失败
    unfinished,
    // 完成
    finish
}

@JsonSerializable()
class Plan {

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'userId')
  String userId;

  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'createTime')
  String createDateTime;

  @JsonKey(name: 'remindDateTime')
  String remindDateTime;

  @JsonKey(name: 'planType')
  String planType;

  @JsonKey(name: 'state')
  String state;

  @JsonKey(name: 'targetList')
  List targetList;

  Plan({
    this.name, 
    this.createDateTime, 
    this.remindDateTime, 
    this.userId, 
    this.id, 
    this.state, 
    this.planType, 
    this.targetList});

  factory Plan.fromJson(Map<String, dynamic> json) => _$PlanFromJson(json);
 
  Map<String,dynamic> toJson() => _$PlanToJson(this);

}