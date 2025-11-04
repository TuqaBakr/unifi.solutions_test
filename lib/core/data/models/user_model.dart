  import 'package:json_annotation/json_annotation.dart';

import '../../../features/manage_users/domain/entities/user_entity.dart';

  part 'user_model.g.dart';

  @JsonSerializable(checked: true)
  class UserModel extends UserEntity {

    // يجب استخدام const في البناء إذا كان الكلاس يرث من Equatable
    const UserModel({
      required super.id,
      required super.name,
      required super.email,
      required super.gender,
      required super.status,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) =>
        _$UserModelFromJson(json);

    Map<String, dynamic> toJson() => _$UserModelToJson(this);

    // دالة تحويل Model إلى Entity (صريحة وواضحة)
    UserEntity toEntity() {
      return UserEntity(
        id: id,
        name: name,
        email: email,
        gender: gender,
        status: status,
      );
    }

    // دالة مساعدة لإنشاء Model من Entity (مفيدة لـ POST)
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
