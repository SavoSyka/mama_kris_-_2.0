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
  await _initAds();
  await initAppAuthInjection();
  await _initEmpAuth();
  await _initEmpJobs();
  await _initApplicantContact();
  await _initResumes();
  await _initSubscriptions();
  await _initEmployeeContact();
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
  sl.registerLazySingleton(() => LoginWithGoogleUsecase(sl()));
  sl.registerLazySingleton(() => UpdatePasswordUsecase(sl()));
  sl.registerLazySingleton(() => LoginWithAppleUsecase(sl()));

  // Bloc (factory → new instance per request)
  sl.registerFactory(
    () => AuthBloc(
      loginUsecase: sl(),
      signupUsecase: sl(),
      checkEmailUsecase: sl(),

      verifyOtpUsecase: sl(),
      resendOtpUsecase: sl(),
      forgotPasswordUsecase: sl(),
      loginWithGoogleUsecase: sl(),
      updatePasswordUsecase: sl(),
      loginWithAppleUsecase: sl(),
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
  sl.registerLazySingleton(() => FetchLikedJobs(sl()));
  sl.registerLazySingleton(() => FilterJobsUsecase(sl()));

  // *────────────────────── JOB Bloc──────────────────────
  sl.registerFactory(
    () => JobBloc(
      fetchJobsUseCase: sl(),
      searchJobsUseCase: sl(),
      likeJobUseCase: sl(),
      dislikeJobUseCase: sl(),
      filterJobsUsecase: sl(),
    ),
  );

  // *────────────────────── Liked JOB Bloc──────────────────────
  sl.registerFactory(() => LikedJobBlocBloc(fetchLikedJobs: sl()));
}

Future<void> _initAds() async {
  // Data sources
  sl.registerLazySingleton<AdsRemoteDataSource>(
    () => AdsRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<AdsRepository>(
    () => AdsRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => FetchAdsUseCase(sl()));

  // Cubit
  sl.registerFactory(() => AdsCubit(fetchAdsUseCase: sl()));
}

Future<void> initAppAuthInjection() async {
  // -------- DATA SOURCES --------
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(sl()),
  );

  // -------- REPOSITORY --------
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl()));

  // -------- USE CASE --------
  sl.registerLazySingleton<GetUserProfileUseCase>(
    () => GetUserProfileUseCase(sl()),
  );

  // -------- BLOC --------
  sl.registerFactory<UserBloc>(() => UserBloc(getUserProfileUseCase: sl()));
}

Future<void> _initEmpAuth() async {
  // Data source

  sl.registerLazySingleton<EmpAuthRemoteDataSource>(
    () => EmpAuthRemoteDataSourceImpl(sl()), // inject Dio
  );

  // Repository
  sl.registerLazySingleton<EmpAuthRepository>(
    () => EmpAuthRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => EmpLoginUsecase(sl()));
  sl.registerLazySingleton(() => EmpSignupUsecase(sl()));
  sl.registerLazySingleton(() => EmpCheckEmailUsecase(sl()));

  sl.registerLazySingleton(() => EmpVerifyOtpUsecase(sl()));
  sl.registerLazySingleton(() => EmpResendOtpUsecase(sl()));
  sl.registerLazySingleton(() => EmpForgotPasswordUsecase(sl()));
  sl.registerLazySingleton(() => EmpLoginWithGoogleUsecase(sl()));
  sl.registerLazySingleton(() => EmpUpdatePasswordUsecase(sl()));
  sl.registerLazySingleton(() => EmpLoginWithAppleUsecase(sl()));

  // Bloc (factory → new instance per request)
  sl.registerFactory(
    () => EmpAuthBloc(
      loginUsecase: sl(),
      signupUsecase: sl(),
      checkEmailUsecase: sl(),

      verifyOtpUsecase: sl(),
      resendOtpUsecase: sl(),
      forgotPasswordUsecase: sl(),
      loginWithGoogleUsecase: sl(),
      updatePasswordUsecase: sl(),
      loginWithAppleUsecase: sl(),
    ),
  );

  sl.registerFactory(() => EmpUserBloc());
}

Future<void> _initEmpJobs() async {
  // Data sources
  sl.registerLazySingleton<EmpJobRemoteDataSource>(
    () => EmpJobRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<EmpJobRepository>(
    () => EmpJobRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => CreateJobUseCase(sl()));
  sl.registerLazySingleton(() => FetchEmpJobsUseCase(sl()));

  // Cubit
  sl.registerFactory(() => CreateJobCubit(createJobUseCase: sl()));
  sl.registerFactory(() => FetchEmpJobsCubit(fetchEmpJobsUseCase: sl()));
}

Future<void> _initApplicantContact() async {
  // Data source
  sl.registerLazySingleton<ApplicantContactDataSource>(
    () => ApplicantContactDataSourceImpl(dio: sl()),
  );

  // Repository
  sl.registerLazySingleton<ApplicantContactRepository>(
    () => ApplicantContactRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => CreateApplicantContactUseCase(sl()));
  sl.registerLazySingleton(() => UpdateApplicantContactUseCase(sl()));
  sl.registerLazySingleton(() => DeleteApplicantContactUseCase(sl()));
  sl.registerLazySingleton(() => GetAllApplicantContactsUseCase(sl()));

  sl.registerLazySingleton(() => UpdateWorkExperienceUseCase(sl()));
  sl.registerLazySingleton(() => DeleteUserAccountUsecase(sl()));
  sl.registerLazySingleton(() => UpdateBasicInfoUsecase(sl()));

  sl.registerLazySingleton(() => LogoutUsecase(sl()));
  sl.registerLazySingleton(() => CreateSpecialityUsecase(sl()));

  // Bloc
  sl.registerFactory(
    () => ApplicantContactBloc(
      createUseCase: sl(),
      updateUseCase: sl(),
      deleteUseCase: sl(),
      getAllUseCase: sl(),
      updateWorkExperienceUseCase: sl(),
      deleteUserAccountUsecase: sl(),
      basicInfoUsecase: sl(),
      logoutUsecase: sl(),
      createSpecialityUsecase: sl(),
    ),
  );
}

Future<void> _initEmployeeContact() async {
  // Data source
  sl.registerLazySingleton<EmployeeContactDataSource>(
    () => EmployeeContactDataSourceImpl(dio: sl()),
  );

  // Repository
  sl.registerLazySingleton<EmployeeContactRepository>(
    () => EmployeeContactRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => CreateEmployeeContact(sl()));
  sl.registerLazySingleton(() => UpdateEmployeeContact(sl()));
  sl.registerLazySingleton(() => DeleteEmployeeContact(sl()));

  sl.registerLazySingleton(() => DeleteEmployeeAccountUsecase(sl()));
  sl.registerLazySingleton(() => UpdateEmployeeBasicInfoUsecase(sl()));
  sl.registerLazySingleton(() => LogoutEmployeeUsecase(sl()));

  // Bloc
  sl.registerFactory(
    () => EmployeeContactBloc(
      createUseCase: sl(),
      updateUseCase: sl(),
      deleteUseCase: sl(),
      deleteUserAccountUsecase: sl(),
      basicInfoUsecase: sl(),
      logoutEmployeeUsecase: sl(),
    ),
  );
}

Future<void> _initApplicantJob() async {}

Future<void> _initResumes() async {
  // Data sources
  sl.registerLazySingleton<ResumeRemoteDataSource>(
    () => ResumeRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<SpecialityRemoteDataSource>(
    () => SpecialityRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<SearchHistoryLocalDataSource>(
    () => SearchHistoryLocalDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<ResumeRepository>(
    () => ResumeRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<SpecialityRepository>(
    () => SpecialityRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => FetchResumeUsecase(sl()));
  sl.registerLazySingleton(() => LikeResumeUsecase(sl()));
  sl.registerLazySingleton(() => SearchSpecialityUsecase(sl()));
  sl.registerLazySingleton(() => FetchFavoritedUsersUsecase(sl()));
  sl.registerLazySingleton(() => GetPublicProfilesUsecase(sl()));

  sl.registerLazySingleton(() => GetHiddenUsersUsecase(sl()));
  sl.registerLazySingleton(() => AddToHideUsecase(sl()));
  sl.registerLazySingleton(() => RemoveFromHideUsecase(sl()));

  // Bloc
  sl.registerFactory(
    () => ResumeBloc(
      fetchResumeUsecase: sl(),
      likeResumeUsecase: sl(),

      fetchFavoritedUsersUsecase: sl(),
    ),
  );
  sl.registerFactory(
    () => SpecialitySearchBloc(
      searchSpecialityUsecase: sl(),
      getPublicProfilesUsecase: sl(),
      searchHistoryDataSource: sl(),
    ),
  );

  sl.registerFactory(
    () => HideResumeBloc(
      getHiddenUsersUsecase: sl(),
      addToHideUsecase: sl(),
      removeFromHideUsecase: sl(),
    ),
  );
}

Future<void> _initSubscriptions() async {
  // Data sources
  sl.registerLazySingleton<SubscriptionRemoteDataSource>(
    () => SubscriptionRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<SubscriptionRepository>(
    () => SubscriptionRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTariffsUsecase(sl()));
  sl.registerLazySingleton(() => InitiatePaymentUsecase(sl()));

  // Bloc
  sl.registerFactory(
    () => SubscriptionPaymentBloc(initiatePaymentUsecase: sl()),
  );

  sl.registerFactory(() => TarriffsBloc(getTariffsUsecase: sl()));

  sl.registerFactory(() => SubscriptionStatusCubit());
}
