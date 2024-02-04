import 'package:equatable/equatable.dart';

import '../../../../core/constants/enum.dart';

class UserInfoEntity extends Equatable {
  final int? customerId;
  final String? username;
  final String? fullName;
  final bool? gender;
  final String? email;
  final DateTime? birthday;
  final Status? status;
  final List<Role>? roles;

  const UserInfoEntity({
    required this.customerId,
    required this.username,
    required this.fullName,
    required this.gender,
    required this.email,
    required this.birthday,
    required this.status,
    required this.roles,
  });

  @override
  List<Object?> get props {
    return [
      customerId,
      username,
      fullName,
      gender,
      email,
      birthday,
      status,
      roles,
    ];
  }
}
