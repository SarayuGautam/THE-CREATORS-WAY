import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/use_case/use_case.dart';
import 'package:blog_app/core/common/entity/user.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserLogin implements UseCase<User, UserLoginParams> {
  UserLogin({required this.authRepository});

  final AuthRepository authRepository;
  @override
  Future<Either<Failure, User>> call(UserLoginParams params) async {
    return authRepository.loginWithEmailPassword(
      password: params.password,
      email: params.email,
    );
  }
}

class UserLoginParams {
  UserLoginParams({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}
