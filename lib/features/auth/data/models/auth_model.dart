import 'dart:convert';

import 'package:flutter_vtv/features/auth/data/models/user_info_model.dart';

import '../../domain/entities/auth_entity.dart';
import '../../domain/entities/user_info_entity.dart';

class AuthModel extends AuthEntity {
  const AuthModel({
    required super.accessToken,
    required super.refreshToken,
    required super.userInfo,
  });

  // toEntity
  AuthEntity toEntity() => AuthEntity(
        accessToken: accessToken,
        refreshToken: refreshToken,
        userInfo: userInfo,
      );

  // fromEntity
  factory AuthModel.fromEntity(AuthEntity entity) => AuthModel(
        accessToken: entity.accessToken,
        refreshToken: entity.refreshToken,
        userInfo: entity.userInfo,
      );

  AuthModel copyWith({
    String? accessToken,
    String? refreshToken,
    UserInfoEntity? userInfo,
  }) {
    return AuthModel(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      userInfo: userInfo ?? this.userInfo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'userInfo': UserInfoModel.fromEntity(userInfo).toMap(),
    };
  }

  factory AuthModel.fromMap(Map<String, dynamic> map) {
    return AuthModel(
      accessToken: map['access_token'] as String,
      refreshToken: map['refresh_token'] as String,
      userInfo: UserInfoModel.fromMap(map['customerDTO'] as Map<String, dynamic>).toEntity(),
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthModel.fromJson(String source) => AuthModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
