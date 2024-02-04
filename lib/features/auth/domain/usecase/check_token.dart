import 'package:dartz/dartz.dart';
import 'package:flutter_vtv/core/constants/typedef.dart';
import 'package:flutter_vtv/core/usecase/base_usecase.dart';
import 'package:flutter_vtv/features/auth/domain/repositories/auth_repository.dart';

/// params: access token
class CheckTokenUC extends UseCaseHasParams<FResult<String?>, String> {
  final AuthRepository _authRepository;

  /// params: access token
  CheckTokenUC(this._authRepository);

  @override
  FResult<String?> call(String params) async {
    final isValidToken = await _authRepository.isValidToken(params);

    return isValidToken.fold(
      (failure) => Left(failure),
      (isValid) async {
        if (isValid) {
          // the token is valid
          return const Right(null);
        } else {
          // the token is expired >> call refresh token
          final resultEither = await _authRepository.getNewAccessToken();
          return resultEither.fold(
            (failure) => Left(failure),
            (accessToken) => Right(accessToken),
          );
        }
      },
    );
  }
}
