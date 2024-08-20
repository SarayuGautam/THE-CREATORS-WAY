import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/auth/domain/entity/user.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String password,
    required String email,
  });
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String password,
    required String email,
  });
}
