part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignUp extends AuthEvent {
  AuthSignUp({
    required this.email,
    required this.password,
    required this.name,
  });

  final String email;
  final String password;
  final String name;
}

final class AuthLogin extends AuthEvent {
  AuthLogin({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}

final class AuthIsUserLoggedIn extends AuthEvent {}
