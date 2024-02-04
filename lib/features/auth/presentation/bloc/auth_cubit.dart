import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/constants.dart';
import '../../domain/dto/register_params.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/usecase/check_token.dart';
import '../../domain/usecase/login_with_username_and_password.dart';
import '../../domain/usecase/logout.dart';
import '../../domain/usecase/register.dart';
import '../../domain/usecase/retrieve_auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this._retrieveAuthUC,
    this._loginWithUsernameAndPasswordUC,
    this._logoutUC,
    this._checkAndGetTokenIfNeededUC,
    this._registerUC,
  ) : super(const AuthState.unknown()) {
    onStarted;
    loginWithUsernameAndPassword;
    logout;
    register;
  }

  final RetrieveAuthUC _retrieveAuthUC;
  final LoginWithUsernameAndPasswordUC _loginWithUsernameAndPasswordUC;
  final LogoutUC _logoutUC;
  final CheckTokenUC _checkAndGetTokenIfNeededUC;
  final RegisterUC _registerUC;

  FutureOr<void> onStarted() async {
    emit(const AuthState.authenticating());
    await _retrieveAuthUC().then((resultEither) {
      resultEither.fold(
        (failure) => emit(AuthState.error(code: failure.code, message: failure.message)),
        (authEntity) async {
          // get new access token if needed
          final resultCheck = await _checkAndGetTokenIfNeededUC(authEntity.accessToken);
          resultCheck.fold(
            // get new access token failed
            (failure) => emit(AuthState.authenticated(authEntity, code: failure.code, message: failure.message)),
            (newAccessToken) => emit(AuthState.authenticated(authEntity.copyWith(accessToken: newAccessToken))),
          );
        },
      );
    });
  }

  FutureOr<void> loginWithUsernameAndPassword({required String username, required String password}) async {
    emit(const AuthState.authenticating());

    await _loginWithUsernameAndPasswordUC(
      LoginWithUsernameAndPasswordUCParams(
        username: username,
        password: password,
      ),
    ).then((resultEither) {
      resultEither.fold(
        (failure) => emit(AuthState.error(code: failure.code, message: failure.message)),
        (authModel) => emit(AuthState.authenticated(authModel, message: kMsgLoggedInSuccessfully)),
      );
    });
  }

  FutureOr<void> logout(String refreshToken) async {
    // get the previous state
    // final previousState = state;
    emit(const AuthState.authenticating());
    await _logoutUC(refreshToken).then((resultEither) {
      resultEither.fold(
        (failure) => emit(AuthState.error(code: failure.code, message: failure.message)),
        (_) => emit(const AuthState.unauthenticated(message: kMsgLoggedOutSuccessfully)),
      );
    });
  }

  FutureOr<void> register(RegisterParams params) async {
    emit(const AuthState.authenticating());
    await _registerUC(params).then((resultEither) {
      resultEither.fold(
        (failure) => emit(AuthState.error(code: failure.code, message: failure.message)),
        (_) => emit(
          const AuthState.unauthenticated(message: kMsgRegisteredSuccessfully, code: 200),
        ),
      );
    });
  }
}
