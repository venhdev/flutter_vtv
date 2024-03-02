import '../../../../core/constants/typedef.dart';
import '../dto/register_params.dart';
import '../entities/auth_entity.dart';
import '../entities/user_info_entity.dart';

abstract class AuthRepository {
  // ----------------- Auth -----------------
  //* start app
  FResult<AuthEntity> retrieveAuth(); // local storage

  //* login
  RespEitherData<AuthEntity> loginWithUsernameAndPassword(String username, String password);
  FResult<void> cacheAuth(AuthEntity authEntity);

  // change password
  RespEither changePassword(String oldPassword, String newPassword);
  RespEitherData<UserInfoEntity> editUserProfile(UserInfoEntity newInfo);

  //* logout
  RespEither logout(String refreshToken);
  FResult<void> deleteAuth();

  //* register
  RespEither register(RegisterParams registerParams);

  /// Whether [accessToken] is expired or not. Returns true if expired, false if not
  FResult<bool> isExpiredToken(String accessToken);

  /// get new access token via refresh token stored in local
  RespEitherData<String> getNewAccessToken();

  //* forgot password
  /// send otp code to email that match with [username]
  RespEither sendOTPForResetPassword(String username);
  RespEither resetPasswordViaOTP(String username, String otpCode, String newPassword);

  // ----------------- Auth -----------------
}
