// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UserModel', json, ($checkedConvert) {
      final val = UserModel(
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        name: $checkedConvert('name', (v) => v as String),
        email: $checkedConvert('email', (v) => v as String),
        gender: $checkedConvert('gender', (v) => v as String),
        status: $checkedConvert('status', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'gender': instance.gender,
  'status': instance.status,
};
