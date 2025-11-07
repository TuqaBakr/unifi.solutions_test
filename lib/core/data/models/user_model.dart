import 'package:json_annotation/json_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart'; // 💡 الاستيراد لـ Hive

import '../../../features/manage_users/domain/entities/user_entity.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable(checked: true)
class UserModel extends UserEntity {

  @HiveField(0)
  @override
  final int id;

  @HiveField(1)
  @override
  final String name;

  @HiveField(2)
  @override
  final String email;

  @HiveField(3)
  @override
  final String gender;

  @HiveField(4)
  @override
  final String status;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.status,
  }) : super(
    id: id,
    name: name,
    email: email,
    gender: gender,
    status: status,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      gender: gender,
      status: status,
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      gender: entity.gender,
      status: entity.status,
    );
  }
}
