import 'package:blog_app/core/common/entity/user.dart';
import 'package:blog_app/core/constant/constants.dart';
import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(
    this.connectionChecker, {
    required this.authRemoteDataSource,
  });

  final AuthRemoteDataSource authRemoteDataSource;
  final ConnectionChecker connectionChecker;
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
      final connected = await connectionChecker.isConnected;
      if (!connected) {
        Left(
          Failure(
            Constants.noConnectionErrorMessage,
          ),
        );
      }
      final user = await function();
      return Right(user);
    } on ServerException catch (e) {
      return Left(
        Failure(e.message),
      );
    }
  }

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      final connected = await connectionChecker.isConnected;
      if (!connected) {
        final session = authRemoteDataSource.currentUserSession;
        if (session == null) {
          return Left(Failure('User is not logged in'));
        }
        return Right(
          UserModel(
            id: session.user.id,
            name: '',
            email: session.user.email ?? '',
          ),
        );
      }
      final user = await authRemoteDataSource.getCurrentUserData();
      return user == null ? Left(Failure('User Not Logged In')) : Right(user);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
