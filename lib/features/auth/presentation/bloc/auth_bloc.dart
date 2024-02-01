import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vtv/core/constants/constants.dart';
import 'package:flutter_vtv/features/auth/domain/usecase/login_with_username_and_password.dart';
import 'package:flutter_vtv/features/auth/domain/usecase/logout.dart';

import '../../domain/entities/auth_entity.dart';
import '../../domain/usecase/retrieve_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
    this._retrieveAuthUC,
    this._loginWithUsernameAndPasswordUC,
    this._logoutUC,
  ) : super(const AuthState.unknown()) {
    on<AuthStarted>(_onStarted);
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
  }

  final RetrieveAuthUC _retrieveAuthUC;
  final LoginWithUsernameAndPasswordUC _loginWithUsernameAndPasswordUC;
  final LogoutUC _logoutUC;

  FutureOr<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(const AuthState.authenticating());
    await _retrieveAuthUC().then((resultEither) {
      resultEither.fold(
        (failure) => emit(const AuthState.unauthenticated(message: kMsgNotLoggedIn)),
        (authEntity) => emit(AuthState.authenticated(authEntity)),
      );
    });
  }

  FutureOr<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(const AuthState.authenticating());

    await _loginWithUsernameAndPasswordUC(
      LoginWithUsernameAndPasswordUCParams(
        username: event.username,
        password: event.password,
      ),
    ).then((resultEither) {
      resultEither.fold(
        (failure) => emit(AuthState.unauthenticated(message: failure.message)),
        (authModel) => emit(AuthState.authenticated(authModel, message: kMsgLoggedInSuccessfully)),
      );
    });
  }

  FutureOr<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    // get the previous state
    final previousState = state;
    emit(const AuthState.authenticating());
    await _logoutUC(event.refreshToken).then((resultEither) {
      resultEither.fold(
        (failure) => emit(AuthState.authenticated(
          previousState.auth!,
          message: failure.message,
        )),
        (_) => emit(const AuthState.unauthenticated(message: kMsgLoggedOutSuccessfully)),
      );
    });
  }
}
