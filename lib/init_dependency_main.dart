part of 'init_dependency.dart';

final serviceLocator = GetIt.instance;
Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
    url: AppSecrets.url,
    anonKey: AppSecrets.apiKey,
  );

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  serviceLocator
    ..registerLazySingleton(() => supabase.client)
    ..registerFactory(InternetConnection.new)
    ..registerLazySingleton(
      () => Hive.box<dynamic>(name: 'blogs'),
    )
    ..registerFactory<ConnectionChecker>(
      () => ConnectionCheckerImpl(internetConnection: serviceLocator()),
    )
    ..registerLazySingleton(
      AppUserCubit.new,
    );
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        supabaseClient: serviceLocator(),
      ),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(),
        authRemoteDataSource: serviceLocator(),
      ),
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

void _initBlog() {
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(
        supabaseClient: serviceLocator(),
      ),
    )
    ..registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImpl(
        box: serviceLocator(),
      ),
    )
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        blogRemoteDataSource: serviceLocator(),
        blogLocalDataSource: serviceLocator(),
        connectionChecker: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UploadBlog(
        blogRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetBlogs(
        blogRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => BlogBloc(
        serviceLocator(),
        serviceLocator(),
      ),
    );
}
