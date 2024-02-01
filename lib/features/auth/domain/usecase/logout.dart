import 'package:flutter_vtv/core/constants/typedef.dart';
import 'package:flutter_vtv/core/usecase/base_usecase.dart';

import '../repositories/auth_repository.dart';

class LogoutUC extends UseCaseHasParams<FResultVoid, String> {
  final AuthRepository _authRepository;

  LogoutUC(this._authRepository);
  @override
  FResultVoid call(String params) async {
    final resultEither = await _authRepository.logout(params);
    await resultEither.fold(
      (failure) => null,
      (ok) async => await _authRepository.deleteAuth(),
    );
    return resultEither;
  }
}
