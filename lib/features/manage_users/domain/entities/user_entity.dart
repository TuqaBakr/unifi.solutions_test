import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String name;
  final String email;
  final String gender;
  final String status;

  const UserEntity({
    this.id = 0,
    required this.name,
    required this.email,
    required this.gender,
    required this.status,
  });

  @override
  List<Object?> get props => [id, name, email, gender, status];

  Map<String, dynamic> toParams() {
    return {
      'name': name,
      'email': email,
      'gender': gender,
      'status': status,
    };
  }
}
