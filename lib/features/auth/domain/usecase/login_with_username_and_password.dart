import 'package:flutter_vtv/core/usecase/base_usecase.dart';

import '../../../../core/constants/typedef.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class LoginWithUsernameAndPasswordUC extends UseCaseHasParams<FResult<AuthEntity>, LoginWithUsernameAndPasswordUCParams> {
  final AuthRepository _authRepository;

  LoginWithUsernameAndPasswordUC(this._authRepository);

  @override
  FResult<AuthEntity> call(LoginWithUsernameAndPasswordUCParams params) async {
    final result = await _authRepository.loginWithUsernameAndPassword(params.username, params.password);

    //> when login success, cache auth into secure storage
    await result.fold(
      (l) => null,
      (authEntity) => _authRepository.cacheAuth(authEntity),
    );
    return result;
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
