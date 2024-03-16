import '../../../../core/constants/base_usecase.dart';
import '../../../../core/constants/typedef.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class LoginWithUsernameAndPasswordUC implements UseCaseHasParams<FRespData<AuthEntity>, LoginWithUsernameAndPasswordUCParams> {
  final AuthRepository _authRepository;

  LoginWithUsernameAndPasswordUC(this._authRepository);

  @override
  FRespData<AuthEntity> call(LoginWithUsernameAndPasswordUCParams params) async {
    final resEither = await _authRepository.loginWithUsernameAndPassword(params.username, params.password);

    //> when login success, cache auth into secure storage
    await resEither.fold(
      (error) async => null, // do nothing
      (ok) async => {
        await _authRepository.cacheAuth(ok.data),
      },
    );

    return resEither;
  }
}

class LoginWithUsernameAndPasswordUCParams {
  final String username;
  final String password;

  LoginWithUsernameAndPasswordUCParams({
    required this.username,
    required this.password,
  });
}
