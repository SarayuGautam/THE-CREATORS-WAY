import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/entity/user.dart';
import 'package:blog_app/core/use_case/use_case.dart';
import 'package:blog_app/features/auth/domain/use_cases/current_user.dart';
import 'package:blog_app/features/auth/domain/use_cases/user_login.dart';
import 'package:blog_app/features/auth/domain/use_cases/user_signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    // on<AuthEvent>((_, emit) => emit(AuthLoading()));
    // on<AuthSignUp>(_onAuthSignUp);
    // on<AuthLogin>(_onAuthLogin);
    // on<AuthIsUserLoggedIn>(_isUserLoggedIn);
    on<AuthEvent>((event, emit) {
      emit(AuthLoading());
      return switch (event) {
        AuthSignUp() => _onAuthSignUp(event, emit),
        AuthLogin() => _onAuthLogin(event, emit),
        AuthIsUserLoggedIn() => _isUserLoggedIn(event, emit),
      };
    });
  }

  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;

  Future<void> _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
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
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  Future<void> _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    final response = await _userLogin(
      UserLoginParams(
        email: event.email,
        password: event.password,
      ),
    );
    response.fold(
      (l) => emit(
        AuthFailure(
          message: l.message,
        ),
      ),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  Future<void> _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final response = await _currentUser(NoParams());
    response.fold(
      (l) => emit(
        AuthFailure(
          message: l.message,
        ),
      ),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  void _emitAuthSuccess(
    User user,
    Emitter<AuthState> emit,
  ) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user: user));
  }
}
