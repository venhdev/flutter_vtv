import '../../../../core/constants/base_usecase.dart';
import '../../../../core/constants/typedef.dart';
import '../repositories/auth_repository.dart';

class LogoutUC implements UseCaseHasParams<FResp, String> {
  final AuthRepository _authRepository;

  LogoutUC(this._authRepository);
  @override
  FResp call(String params) async {
    final resEither = await _authRepository.logout(params);
    resEither.fold(
      (error) => _authRepository.deleteAuth(), // even if logout failed, delete token in local storage
      (ok) => _authRepository.deleteAuth(), // delete token in local storage when logout success
    );
    return resEither;
  }
}
