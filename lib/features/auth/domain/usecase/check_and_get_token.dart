import 'package:dartz/dartz.dart';
import 'package:flutter_vtv/core/constants/typedef.dart';
import 'package:flutter_vtv/core/usecase/base_usecase.dart';
import 'package:flutter_vtv/features/auth/domain/repositories/auth_repository.dart';

// params: access token
class CheckAndGetTokenIfNeededUC extends UseCaseHasParams<FResult<String?>, ({String accessToken, String refreshToken})> {
  final AuthRepository _authRepository;

  CheckAndGetTokenIfNeededUC(this._authRepository);

  @override
  FResult<String?> call(({String accessToken, String refreshToken}) params) async {
    final isValidToken = await _authRepository.isValidToken(params.accessToken);

    return isValidToken.fold(
      (failure) => Left(failure),
      (isValid) async {
        if (isValid) {
          // the token is valid
          return const Right(null);
        } else {
          // the token is expired >> call refresh token
          final resultEither = await _authRepository.getAccessToken(params.refreshToken);
          return resultEither.fold(
            (failure) => Left(failure),
            (accessToken) => Right(accessToken),
          );
        }
      },
    );
  }
}
