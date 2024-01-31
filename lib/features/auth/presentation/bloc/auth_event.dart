// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthStarted extends AuthEvent {}

class LoggedInEvent extends AuthEvent {
  final String username;
  final String password;

  const LoggedInEvent({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [username, password];
}

class AuthLoggedOut extends AuthEvent {}