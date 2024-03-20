// ignore_for_file: public_member_api_docs, sort_constructors_first
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
    this.redirectTo,
  });

  const AuthState.unknown() : this._();
  const AuthState.authenticating() : this._(status: AuthStatus.authenticating);

  const AuthState.authenticated(AuthEntity auth,
      {String? message, int? code, String? redirectTo})
      : this._(
          status: AuthStatus.authenticated,
          auth: auth,
          message: message,
          code: code,
          redirectTo: redirectTo,
        );

  const AuthState.unauthenticated(
      {String? message, int? code, String? redirectTo})
      : this._(
          status: AuthStatus.unauthenticated,
          message: message,
          auth: null,
          code: code,
          redirectTo: redirectTo,
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

  /// Redirect to a specific page (when code = 200)
  final String? redirectTo;

  @override
  List<Object?> get props => [
        code,
        status,
        auth,
        message,
      ];

  AuthState copyWith({
    AuthStatus? status,
    AuthEntity? auth,
    String? message,
    int? code,
    String? redirectTo,
  }) {
    return AuthState._(
      status: status ?? this.status,
      auth: auth ?? this.auth,
      message: message ?? this.message,
      code: code ?? this.code,
      redirectTo: redirectTo ?? this.redirectTo,
    );
  }
}
