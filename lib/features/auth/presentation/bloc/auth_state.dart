part of 'auth_bloc.dart';

enum AuthStatus {
  unknown,
  authenticating,
  authenticated,
  unauthenticated,
}

class AuthState extends Equatable {
  const AuthState._({
    this.status = AuthStatus.unknown,
    this.auth,
    this.message,
  });

  const AuthState.unknown() : this._();
  const AuthState.authenticating() : this._(status: AuthStatus.authenticating);

  const AuthState.authenticated(AuthEntity auth, {String? message})
      : this._(
          status: AuthStatus.authenticated,
          auth: auth,
          message: message,
        );

  const AuthState.unauthenticated({String? message})
      : this._(
          status: AuthStatus.unauthenticated,
          message: message,
          auth: null,
        );

  const AuthState.error({String? message})
      : this._(
          status: AuthStatus.unauthenticated,
          message: message,
          auth: null,
        );

  final AuthStatus status;
  final AuthEntity? auth;
  final String? message;

  @override
  List<Object?> get props => [
        status,
        auth,
        message,
      ];
}
