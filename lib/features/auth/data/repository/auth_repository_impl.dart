import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/domain/entity/user.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/src/either.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.authRemoteDataSource,
  });

  final AuthRemoteDataSource authRemoteDataSource;
  @override
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String password,
    required String email,
  }) {
    return _getUser(
      () async => authRemoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String password,
    required String email,
  }) {
    return _getUser(
      () async => authRemoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  Future<Either<Failure, User>> _getUser(
    Future<User> Function() function,
  ) async {
    try {
      final user = await function();
      return Right(user);
    } on sb.AuthException catch (e) {
      return Left(
        Failure(e.message),
      );
    } on ServerException catch (e) {
      return Left(
        Failure(e.message),
      );
    }
  }
}
