import 'dart:developer';

import 'package:logger/logger.dart';

import '../../../../core/constants/base_usecase.dart';
import '../../../../core/constants/typedef.dart';
import '../repositories/auth_repository.dart';

class LogoutUC implements UseCaseHasParams<RespEither, String> {
  final AuthRepository _authRepository;

  LogoutUC(this._authRepository);
  @override
  RespEither call(String params) async {
    Logger().e('token: $params');
    final resEither = await _authRepository.logout(params);
    resEither.fold(
      (error) => _authRepository.deleteAuth(),
      (ok) => _authRepository.deleteAuth().then((value) => value.fold(
            (l) => log('delete token in local storage error: $l'),
            (r) => log('delete token in local storage success'),
          )), // delete token in local storage --may have error -> ignore
    );
    return resEither;
  }
}
