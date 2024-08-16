import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/use_case/use_case.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignUp implements UseCase<String, UserSignupParams> {
  UserSignUp({required this.authRepository});

  final AuthRepository authRepository;
  @override
  Future<Either<Failure, String>> call(UserSignupParams params) async {
    return authRepository.signUpWithEmailPassword(
      name: params.name,
      password: params.password,
      email: params.email,
    );
  }
}

class UserSignupParams {
  UserSignupParams({
    required this.email,
    required this.name,
    required this.password,
  });

  final String email;
  final String name;
  final String password;
}
