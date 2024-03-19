import 'dart:convert';

import '../../domain/entities/auth_entity.dart';
import 'user_info_model.dart';

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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'customerDTO': UserInfoModel.fromEntity(userInfo).toMap(),
    };
  }

  factory AuthModel.fromMap(Map<String, dynamic> map) {
    return AuthModel(
      accessToken: map['access_token'] as String,
      refreshToken: map['refresh_token'] as String,
      userInfo:
          UserInfoModel.fromMap(map['customerDTO'] as Map<String, dynamic>)
              .toEntity(),
    );
  }

  String toJson() => json.encode(toMap());

  /// - [source] is Json String
  factory AuthModel.fromJson(String source) =>
      AuthModel.fromMap(json.decode(source) as Map<String, dynamic>);
  factory AuthModel.fromJsonMap(Map<String, dynamic> source) =>
      AuthModel.fromMap(source);
}
