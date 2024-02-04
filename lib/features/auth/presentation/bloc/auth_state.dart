part of 'auth_cubit.dart';

enum AuthStatus {
  unknown,
  authenticating,
  authenticated,
  unauthenticated,
}

class AuthState extends Equatable {
  const AuthState._({
    this.code,
    this.status = AuthStatus.unknown,
    this.auth,
    this.message,
  });

  const AuthState.unknown() : this._();
  const AuthState.authenticating() : this._(status: AuthStatus.authenticating);

  const AuthState.authenticated(AuthEntity auth, {String? message, int? code})
      : this._(
          status: AuthStatus.authenticated,
          auth: auth,
          message: message,
          code: code,
        );

  const AuthState.unauthenticated({String? message, int? code})
      : this._(
          status: AuthStatus.unauthenticated,
          message: message,
          auth: null,
          code: code,
        );

  const AuthState.error({String? message, int? code})
      : this._(
          status: AuthStatus.unauthenticated,
          message: message,
          auth: null,
          code: code,
        );

  final AuthStatus status;
  final AuthEntity? auth;
  final String? message;
  final int? code;

  @override
  List<Object?> get props => [
        status,
        auth,
        message,
      ];
}
