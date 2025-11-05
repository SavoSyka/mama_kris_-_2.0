part of 'dependency_import.dart';

final sl = GetIt.instance;

Future<void> dependencyInjection() async {
  await _initSharedPref();
  await _initLocalCache();
  await apiService();
  await _initForceUpdate();
  await _initAuth();
  await _initNotifications();
  await _initJobs();
}

Future<void> _initLocalCache() async {
  await Hive.initFlutter();

  // Hive.registerAdapter(SearchJobModelAdapter());
  Hive.registerAdapter(NotificationModelAdapter());

  // final searchJobsBox = await Hive.openBox<SearchJobModel>(
  //   HiveConstants.searchJobBox,
  // );

  // sl.registerLazySingleton<Box<SearchJobModel>>(() => searchJobsBox);
}

Future<void> _initSharedPref() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);
}

Future<void> _initForceUpdate() async {
  // DataSource
  sl.registerLazySingleton<ForceUpdateRemoteDataSource>(
    () => ForceUpdateRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<ForceUpdateRepository>(
    () => ForceUpdateRepositoryImpl(sl()),
  );

  // UseCase
  sl.registerLazySingleton<CheckForceUpdateUseCase>(
    () => CheckForceUpdateUseCase(sl()),
  );

  sl.registerFactory(() => ForceUpdateBloc(sl()));
}

Future<void> _initAuth() async {
  // Data source
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()), // inject Dio
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl(), sl()), // inject Dio
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // Use cases
  sl.registerLazySingleton(() => LoginUsecase(sl()));
  sl.registerLazySingleton(() => SignupUsecase(sl()));
  sl.registerLazySingleton(() => CheckEmailUsecase(sl()));

  sl.registerLazySingleton(() => VerifyOtpUsecase(sl()));
  sl.registerLazySingleton(() => ResendOtpUsecase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUsecase(sl()));

  // Bloc (factory → new instance per request)
  sl.registerFactory(
    () => AuthBloc(
      loginUsecase: sl(),
      signupUsecase: sl(),
      checkEmailUsecase: sl(),

      verifyOtpUsecase: sl(),
      resendOtpUsecase: sl(),
      forgotPasswordUsecase: sl(),
    ),
  );
}

Future<void> _initNotifications() async {
  // // Register LocalNotificationsService as singleton
  // sl.registerLazySingleton<LocalNotificationsService>(
  //   () => LocalNotificationsService.instance(),
  // );

  // // Register FirebaseMessagingService as singleton
  // sl.registerLazySingleton<FirebaseMessagingService>(
  //   () => FirebaseMessagingService.instance(),
  // );

  // Register NotificationLocalDataSource
  sl.registerLazySingleton<NotificationLocalDataSource>(
    () => NotificationLocalDataSourceImpl(),
  );

  // Register NotificationRepository
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(sl<NotificationLocalDataSource>()),
  );

  // Register NotificationListCubit
  sl.registerFactory<NotificationListCubit>(
    () => NotificationListCubit(sl<NotificationRepository>()),
  );

  // Register NotificationDetailCubit
  sl.registerFactory<NotificationDetailCubit>(
    () => NotificationDetailCubit(sl<NotificationRepository>()),
  );
}

Future<void> _initJobs() async {
  // Data sources
  sl.registerLazySingleton<JobRemoteDataSource>(
    () => JobRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<JobLocalDataSource>(() => JobLocalDataSourceImpl());

  // Repository
  sl.registerLazySingleton<JobRepository>(
    () => JobRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => FetchJobsUseCase(sl()));
  sl.registerLazySingleton(() => SearchJobsUseCase(sl()));
  sl.registerLazySingleton(() => LikeJobUseCase(sl()));
  sl.registerLazySingleton(() => DislikeJobUseCase(sl()));

  // Bloc
  sl.registerFactory(
    () => JobBloc(
      fetchJobsUseCase: sl(),
      searchJobsUseCase: sl(),
      likeJobUseCase: sl(),
      dislikeJobUseCase: sl(),
    ),
  );
}

Future<void> _initApplicantJob() async {}
