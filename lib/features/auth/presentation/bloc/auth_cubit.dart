import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vtv/core/constants/constants.dart';
import 'package:flutter_vtv/features/auth/domain/dto/register_params.dart';
import 'package:flutter_vtv/features/auth/domain/usecase/check_and_get_token.dart';
import 'package:flutter_vtv/features/auth/domain/usecase/login_with_username_and_password.dart';
import 'package:flutter_vtv/features/auth/domain/usecase/logout.dart';
import 'package:flutter_vtv/features/auth/domain/usecase/register.dart';

import '../../domain/entities/auth_entity.dart';
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
  final CheckAndGetTokenIfNeededUC _checkAndGetTokenIfNeededUC;
  final RegisterUC _registerUC;

  FutureOr<void> onStarted() async {
    emit(const AuthState.authenticating());
    await _retrieveAuthUC().then((resultEither) {
      resultEither.fold(
        (failure) => emit(const AuthState.unauthenticated()),
        (authEntity) async {
          final checkParam = (
            accessToken: authEntity.accessToken,
            refreshToken: authEntity.refreshToken,
          );
          final resultCheck = await _checkAndGetTokenIfNeededUC(checkParam);
          resultCheck.fold(
            (failure) => emit(AuthState.authenticated(authEntity, message: failure.message)),
            (newAccessToken) => emit(AuthState.authenticated(authEntity.copyWith(accessToken: newAccessToken))),
          );

          emit(AuthState.authenticated(authEntity));
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
        (failure) => emit(AuthState.unauthenticated(message: failure.message)),
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
        (failure) => emit(AuthState.unauthenticated(message: failure.message)),
        (_) => emit(const AuthState.unauthenticated(message: kMsgLoggedOutSuccessfully)),
      );
    });
  }

  FutureOr<void> register(RegisterParams params) async {
    emit(const AuthState.authenticating());
    await _registerUC(params).then((resultEither) {
      resultEither.fold(
        (failure) => emit(AuthState.unauthenticated(message: failure.message)),
        (_) => emit(
          const AuthState.unauthenticated(message: kMsgRegisteredSuccessfully, code: 200),
        ),
      );
    });
  }
}
