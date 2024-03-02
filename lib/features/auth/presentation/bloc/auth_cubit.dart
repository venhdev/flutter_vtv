import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/constants.dart';
import '../../domain/dto/register_params.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/entities/user_info_entity.dart';
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
    changePassword;
    editUserProfile;
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
        (ok) => emit(AuthState.authenticated(ok.data, message: kMsgLoggedInSuccessfully, code: 200, redirectTo: '/home')),
      );
    });
  }

  Future<void> logout(String refreshToken) async {
    emit(const AuthState.authenticating());
    await _logoutUC(refreshToken).then((respEither) {
      respEither.fold(
        (error) => emit(AuthState.error(code: error.code, message: error.message)),
        (ok) => emit(AuthState.unauthenticated(
          message: ok.message,
          code: ok.code,
        )),
      );
    });
  }

  Future<void> register(RegisterParams params) async {
    emit(const AuthState.authenticating());
    await _authRepository.register(params).then((resultEither) {
      resultEither.fold(
        (error) => emit(AuthState.error(code: error.code, message: error.message)),
        (ok) => emit(AuthState.unauthenticated(
          message: ok.message,
          code: ok.code,
          redirectTo: '/user/login',
        )),
      );
    });
  }

  Future<void> changePassword({required String oldPassword, required String newPassword}) async {
    // using 'state' to get the previous state (should be authenticated)
    final previousState = state;
    emit(const AuthState.authenticating());
    await _authRepository.changePassword(oldPassword, newPassword).then((resultEither) {
      //? even user change password success or not, keep the user authenticated
      resultEither.fold(
        (error) => emit(previousState.copyWith(message: error.message, code: error.code)),
        (ok) => emit(previousState.copyWith(message: ok.message, code: ok.code, redirectTo: '/user')),
      );
    });
  }

  Future<void> editUserProfile({required UserInfoEntity newInfo}) async {
    // using 'state' to get the previous state (should be authenticated)
    final previousState = state;
    emit(const AuthState.authenticating());
    await _authRepository.editUserProfile(newInfo).then((resultEither) {
      //? even user change password success or not, keep the user authenticated
      resultEither.fold(
        (error) => emit(previousState.copyWith(message: error.message, code: error.code)),
        (ok) => emit(AuthState.authenticated(
          previousState.auth!.copyWith(userInfo: ok.data), // copy with new user info
          message: ok.message,
          code: ok.code,
          redirectTo: '/user',
        )),
      );
    });
  }
}
