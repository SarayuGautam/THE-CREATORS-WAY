import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/secrets/app_secrets.dart';
import 'package:blog_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/domain/use_cases/current_user.dart';
import 'package:blog_app/features/auth/domain/use_cases/user_login.dart';
import 'package:blog_app/features/auth/domain/use_cases/user_signup.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;
Future<void> initDependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    url: AppSecrets.url,
    anonKey: AppSecrets.apiKey,
  );
  serviceLocator
    ..registerLazySingleton(() => supabase.client)
    ..registerLazySingleton(
      AppUserCubit.new,
    );
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(supabaseClient: serviceLocator()),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(authRemoteDataSource: serviceLocator()),
    )
    ..registerFactory(
      () => UserSignUp(authRepository: serviceLocator()),
    )
    ..registerFactory(
      () => UserLogin(authRepository: serviceLocator()),
    )
    ..registerFactory(
      () => CurrentUser(authRepository: serviceLocator()),
    )
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}
