import 'package:flutter_vtv/core/constants/typedef.dart';
import 'package:flutter_vtv/features/auth/domain/dto/register_params.dart';
import 'package:flutter_vtv/features/auth/domain/entities/auth_entity.dart';

abstract class AuthRepository {
  // start app
  FResult<AuthEntity> retrieveAuth();

  // login
  FResult<AuthEntity> loginWithUsernameAndPassword(String username, String password);
  FResultVoid cacheAuth(AuthEntity authEntity);

  // logout
  FResultVoid logout(String refreshToken);
  FResultVoid deleteAuth();

  // register
  FResultVoid register(RegisterParams registerParams);

  // token expired
  FResult<bool> isValidToken(String accessToken); // check token expired
  FResult<String> getAccessToken(String refreshToken);
}
