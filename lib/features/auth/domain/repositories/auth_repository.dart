import '../../../../core/constants/typedef.dart';
import '../dto/register_params.dart';
import '../entities/auth_entity.dart';

abstract class AuthRepository {
  // ----------------- Auth -----------------
  //* start app
  FResult<AuthEntity> retrieveAuth(); // local storage

  //* login
  RespEitherData<AuthEntity> loginWithUsernameAndPassword(String username, String password);
  FResult<void> cacheAuth(AuthEntity authEntity);

  //* logout
  RespEither logout(String refreshToken);
  FResult<void> deleteAuth();

  //* register
  RespEither register(RegisterParams registerParams);

  //* token expired
  /// Whether [accessToken] is expired or not. Returns true if expired, false if not
  FResult<bool> isExpiredToken(String accessToken);

  /// get new access token base on refresh token stored in local
  RespEitherData<String> getNewAccessToken();

  //* forgot password
  /// send code to email that match with [username]
  RespEither sendCode(String username);

  // ----------------- Auth -----------------
}
