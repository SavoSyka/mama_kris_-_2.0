part of 'dependency_import.dart';

final getIt = GetIt.instance;

Future<void> dependencyInjection() async {
  await _initSharedPref();
  await _initDio();
  await _initForceUpdate();
  _initAuth();
  await _initEmpAuth();
}

Future<void> _initDio() async {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      responseType: ResponseType.json,
    ),
  );

  (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (client) {
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  };

  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          final token = await getIt<AuthLocalDataSource>().getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        } catch (e) {}
        return handler.next(options);
      },
      onError: (e, handler) async {
        //  handle 401 refresh token flow here
        return handler.next(e);
      },
    ),
  );

  getIt.registerLazySingleton<Dio>(() => dio);
}

Future<void> _initSharedPref() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);
}

Future<void> _initForceUpdate() async {
  // DataSource
  getIt.registerLazySingleton<ForceUpdateRemoteDataSource>(
    () => ForceUpdateRemoteDataSourceImpl(getIt()),
  );

  // Repository
  getIt.registerLazySingleton<ForceUpdateRepository>(
    () => ForceUpdateRepositoryImpl(getIt()),
  );

  // UseCase
  getIt.registerLazySingleton<CheckForceUpdateUseCase>(
    () => CheckForceUpdateUseCase(getIt()),
  );

  getIt.registerFactory(() => ForceUpdateBloc(getIt()));
}

void _initAuth() {
  // Data source
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(getIt()), // inject Dio
  );
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: getIt(), local: getIt()), // inject Dio
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => CheckEmail(getIt()));
  getIt.registerLazySingleton(() => ValidateOtp(getIt()));
  getIt.registerLazySingleton(() => RegisterApplicant(getIt()));
  getIt.registerLazySingleton(() => LoginApplicant(getIt()));
  getIt.registerLazySingleton(() => ChangePassword(getIt()));
  getIt.registerLazySingleton(() => ForgotPasswordUsecase(getIt()));

  // Bloc (factory → new instance per request)
  getIt.registerFactory(
    () => AuthBloc(
      checkEmail: getIt(),
      validateOtp: getIt(),
      register: getIt(),
      login: getIt(),
      changePassword: getIt(),
      forgotPassword: getIt(),
    ),
  );
}

Future<void> _initEmpAuth() async {
  // Data source
  getIt.registerLazySingleton<EmpAuthLocalDataSource>(
    () => EmpAuthLocalDataSourceImpl(getIt()), // inject Dio
  );
  getIt.registerLazySingleton<EmpAuthRemoteDataSource>(
    () =>
        EmpAuthRemoteDataSourceImpl(dio: getIt(), local: getIt()), // inject Dio
  );

  // Repository
  getIt.registerLazySingleton<EmployeAuthRepository>(
    () => EmpAuthRepositoryImpl(getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => EmpCheckEmailUsecase(getIt()));
  getIt.registerLazySingleton(() => EmpValidatOtpUsecase(getIt()));
  getIt.registerLazySingleton(() => EmpRegisterUsecase(getIt()));
  getIt.registerLazySingleton(() => EmpLoginUsecase(getIt()));
  getIt.registerLazySingleton(() => EmpChangePassUsecase(getIt()));
  getIt.registerLazySingleton(() => EmpForgotPassUsecase(getIt()));

  // Bloc (factory → new instance per request)
  getIt.registerFactory(
    () => EmpAuthBloc(
      checkEmail: getIt(),
      validateOtp: getIt(),
      register: getIt(),
      login: getIt(),
      changePassword: getIt(),
      forgotPassword: getIt(),
    ),
  );
}
