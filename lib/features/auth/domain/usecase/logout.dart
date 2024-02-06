import 'dart:developer';

import '../../../../core/constants/base_usecase.dart';
import '../../../../core/constants/typedef.dart';
import '../repositories/auth_repository.dart';

class LogoutUC implements UseCaseHasParams<RespEither, String> {
  final AuthRepository _authRepository;

  LogoutUC(this._authRepository);
  @override
  RespEither call(String params) async {
    final resEither = await _authRepository.logout(params);
    await resEither.fold(
      (error) => null,
      (ok) async => await _authRepository.deleteAuth().then((value) => value.fold(
            (l) => log('delete token in local storage error: $l'),
            (r) => log('delete token in local storage success'),
          )), // delete token in local storage --may have error -> ignore
    );
    return resEither;
  }
}
