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
}
