// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../../../../core/constants/enum.dart';
import '../../domain/entities/user_info_entity.dart';

class UserInfoModel extends UserInfoEntity {
  const UserInfoModel({
    required super.customerId,
    required super.username,
    required super.fullName,
    required super.gender,
    required super.email,
    required super.birthday,
    required super.status,
    required super.roles,
  });

  // toEntity
  UserInfoEntity toEntity() => UserInfoEntity(
        customerId: customerId,
        email: email,
        username: username,
        fullName: fullName,
        birthday: birthday,
        gender: gender,
        status: status,
        roles: roles,
      );

  // fromEntity
  factory UserInfoModel.fromEntity(UserInfoEntity entity) => UserInfoModel(
        customerId: entity.customerId,
        email: entity.email,
        username: entity.username,
        fullName: entity.fullName,
        birthday: entity.birthday,
        gender: entity.gender,
        status: entity.status,
        roles: entity.roles,
      );

  UserInfoModel copyWith({
    int? customerId,
    String? username,
    String? fullName,
    bool? gender,
    String? email,
    DateTime? birthday,
    Status? status,
    List<Role>? roles,
  }) {
    return UserInfoModel(
      customerId: customerId ?? this.customerId,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      birthday: birthday ?? this.birthday,
      status: status ?? this.status,
      roles: roles ?? this.roles,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (customerId != null) 'customerId': customerId,
      if (username != null) 'username': username,
      if (fullName != null) 'fullName': fullName,
      if (gender != null) 'gender': gender,
      if (email != null) 'email': email,
      if (birthday != null) 'birthday': birthday!.toIso8601String(),
      if (status != null) 'status': status!.name,
      if (roles != null) 'roles': roles!.map((e) => e.name).toList(),
    };
  }

  factory UserInfoModel.fromMap(Map<String, dynamic> map) {
    Status? status;
    List<Role> roles = [];

    if (map['status'] != null) {
      switch (map['status'] as String) {
        case 'ACTIVE':
          status = Status.ACTIVE;
          break;
        default:
          status = Status.ACTIVE;
      }
    }

    if (map['roles'] != null) {
      for (var element in (map['roles'] as List<dynamic>)) {
        switch (element as String) {
          case 'ADMIN':
            roles.add(Role.ADMIN);
            break;
          case 'CUSTOMER':
            roles.add(Role.CUSTOMER);
            break;
        }
      }
    }

    return UserInfoModel(
      customerId: map['customerId'] as int?,
      username: map['username'] as String?,
      fullName: map['fullName'] as String?,
      gender: map['gender'] as bool?,
      email: map['email'] as String?,
      birthday: map['birthday'] != null
          ? DateTime.parse(map['birthday'] as String)
          : null,
      status: status,
      roles: roles,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserInfoModel.fromJson(String source) =>
      UserInfoModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
