import 'package:equatable/equatable.dart';

import 'user_info_entity.dart';

class AuthEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  final UserInfoEntity userInfo;

  const AuthEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.userInfo,
  });

  @override
  List<Object> get props => [accessToken, refreshToken, userInfo];

  AuthEntity copyWith({
    String? accessToken,
    String? refreshToken,
    UserInfoEntity? userInfo,
  }) {
    return AuthEntity(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      userInfo: userInfo ?? this.userInfo,
    );
  }
}
