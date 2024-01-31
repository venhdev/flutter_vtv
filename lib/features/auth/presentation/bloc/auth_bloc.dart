import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vtv/core/constants/constants.dart';
import 'package:flutter_vtv/features/auth/domain/usecase/login_with_username_and_password.dart';

import '../../domain/entities/auth_entity.dart';
import '../../domain/usecase/retrieve_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
    this._retrieveAuthUC,
    this._loginWithUsernameAndPasswordUC,
  ) : super(const AuthState.unknown()) {
    on<AuthStarted>(_authStarted);
    on<LoggedInEvent>(_authLoggedIn);
  }

  final RetrieveAuthUC _retrieveAuthUC;
  final LoginWithUsernameAndPasswordUC _loginWithUsernameAndPasswordUC;

  FutureOr<void> _authStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(const AuthState.authenticating());
    await _retrieveAuthUC().then((resultEither) {
      resultEither.fold(
        (failure) => emit(const AuthState.unauthenticated(message: kMsgNotLoggedIn)),
        (authEntity) => emit(AuthState.authenticated(authEntity)),
      );
    });
  }

  FutureOr<void> _authLoggedIn(LoggedInEvent event, Emitter<AuthState> emit) async {
    emit(const AuthState.authenticating());

    await _loginWithUsernameAndPasswordUC(
      LoginWithUsernameAndPasswordUCParams(
        username: event.username,
        password: event.password,
      ),
    ).then((resultEither) {
      log('value: $resultEither');
      resultEither.fold(
        (failure) => emit(AuthState.unauthenticated(message: failure.message)),
        (authModel) => emit(AuthState.authenticated(authModel, message: kMsgLoggedInSuccessfully)),
      );
    });
  }
}
