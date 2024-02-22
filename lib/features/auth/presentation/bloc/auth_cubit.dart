import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/constants.dart';
import '../../domain/dto/register_params.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecase/use_cases.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this._authRepository,
    this._loginWithUsernameAndPasswordUC,
    this._logoutUC,
    this._checkAndGetTokenIfNeededUC,
  ) : super(const AuthState.unknown()) {
    onStarted;
    loginWithUsernameAndPassword;
    logout;
    register;
  }

  final AuthRepository _authRepository;
  final LoginWithUsernameAndPasswordUC _loginWithUsernameAndPasswordUC;
  final LogoutUC _logoutUC;
  final CheckTokenUC _checkAndGetTokenIfNeededUC;

  Future<void> onStarted() async {
    emit(const AuthState.authenticating());
    await _authRepository.retrieveAuth().then((resultEither) {
      resultEither.fold(
        (failure) => emit(AuthState.error(message: failure.message)),
        (authEntity) async {
          // get new access token if needed
          final resultCheck = await _checkAndGetTokenIfNeededUC(authEntity.accessToken);
          resultCheck.fold(
            // get new access token failed
            (failure) => emit(AuthState.authenticated(authEntity, message: failure.message)),
            (newAccessToken) => emit(AuthState.authenticated(authEntity.copyWith(accessToken: newAccessToken))),
          );
        },
      );
    });
  }

  Future<void> loginWithUsernameAndPassword({required String username, required String password}) async {
    emit(const AuthState.authenticating());

    await _loginWithUsernameAndPasswordUC(
      LoginWithUsernameAndPasswordUCParams(
        username: username,
        password: password,
      ),
    ).then((respEither) {
      respEither.fold(
        (failure) => emit(AuthState.error(code: failure.code, message: failure.message)),
        (ok) => emit(AuthState.authenticated(ok.data, message: kMsgLoggedInSuccessfully, code: ok.code)),
      );
    });
  }

  Future<void> logout(String refreshToken) async {
    emit(const AuthState.authenticating());
    await _logoutUC(refreshToken).then((respEither) {
      respEither.fold(
        (error) => emit(AuthState.error(code: error.code, message: error.message)),
        (ok) => emit(AuthState.unauthenticated(message: ok.message, code: ok.code)),
      );
    });
  }

  Future<void> register(RegisterParams params) async {
    emit(const AuthState.authenticating());
    await _authRepository.register(params).then((resultEither) {
      resultEither.fold(
        (error) => emit(AuthState.error(code: error.code, message: error.message)),
        (ok) => emit(
          AuthState.unauthenticated(message: ok.message, code: ok.code),
        ),
      );
    });
  }
}
