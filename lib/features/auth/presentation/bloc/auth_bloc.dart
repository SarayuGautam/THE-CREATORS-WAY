import 'package:blog_app/features/auth/domain/use_cases/user_signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required UserSignUp userSignUp})
      : _userSignUp = userSignUp,
        super(AuthInitial()) {
    on<AuthSignUp>((event, emit) async {
      final response = await _userSignUp(
        UserSignupParams(
          email: event.email,
          name: event.name,
          password: event.password,
        ),
      );
      response.fold(
        (l) => emit(
          AuthFailure(
            message: l.message,
          ),
        ),
        (r) => emit(AuthSuccess(
          uID: r,
        )),
      );
    });
  }
  final UserSignUp _userSignUp;
}
