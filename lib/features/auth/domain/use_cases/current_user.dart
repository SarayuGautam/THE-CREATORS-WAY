import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/use_case/use_case.dart';
import 'package:blog_app/features/auth/domain/entity/user.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/src/either.dart';

class CurrentUser implements UseCase<User, NoParams> {
  CurrentUser({
    required this.authRepository,
  });

  final AuthRepository authRepository;
  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return authRepository.currentUser();
  }
}
