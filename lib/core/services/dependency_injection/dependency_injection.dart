part of 'dependency_import.dart';

final sl = GetIt.instance;

Future<void> dependencyInjection() async {
  await _initSharedPref();
  await _initLocalCache();
  await _initDio();
  await _initForceUpdate();
  await _initAuth();
  await _initNotifications();
  await _initJobs();
}

Future<bool> refreshAccessToken() async {
  final prefs = await SharedPreferences.getInstance();
  final refreshToken = prefs.getString('refresh_token');

  if (refreshToken == null || refreshToken.isEmpty) {
    debugPrint("No refresh token available");
    return false;
  }

  try {
    final dio = sl<Dio>(); // Use singleton Dio instance
    final response = await dio.post(
      'auth/refresh-token',
      options: Options(
        headers: {'Authorization': 'Bearer $refreshToken'},
        extra: {'isRefreshRequest': true}, // Flag to skip interceptors
      ),
    );

    if (response.statusCode == 201) {
      final data = response.data;
      final newAccessToken = data['accessToken'];

      if (newAccessToken != null && newAccessToken.isNotEmpty) {
        await prefs.setString('auth_token', newAccessToken);
        debugPrint("Access token refreshed successfully");
        return true;
      } else {
        debugPrint("New access token is null or empty");
      }
    } else {
      debugPrint(
        "Refresh token failed: ${response.statusCode} - ${response.data}",
      );
    }
  } catch (e) {
    debugPrint("Error refreshing access token: $e");
  }

  return false;
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
        // Skip adding access token for refresh requests
        if (options.extra['isRefreshRequest'] == true) {
          debugPrint("Skipping access token for refresh request");
          return handler.next(options);
        }

        try {
          const token = ''; // TODO

          //await sl<AuthLocalDataSource>().getToken();
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          } else {
            debugPrint("No access token available for request");
          }
        } catch (e) {
          debugPrint("Error retrieving token: $e");
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        // Skip 401 handling for refresh requests
        if (e.response?.statusCode == 401 &&
            e.requestOptions.extra['isRefreshRequest'] != true) {
          debugPrint("401 Unauthorized detected, attempting token refresh");

          // Avoid infinite loops by checking if already retrying
          if (e.requestOptions.extra['isRetrying'] == true) {
            debugPrint("Already retrying, aborting to prevent loop");
            return handler.next(e);
          }

          // Attempt to refresh the token
          final refreshed = await refreshAccessToken();
          if (refreshed) {
            try {
              // Retrieve the new token
              const newToken = ''; // TODO
              //await sl<AuthLocalDataSource>().getToken();
              if (newToken.isNotEmpty) {
                // Update the original request's Authorization header
                e.requestOptions.headers['Authorization'] = 'Bearer $newToken';
                // Mark as retrying to prevent infinite loops
                e.requestOptions.extra['isRetrying'] = true;

                // Retry the original request
                debugPrint("Retrying request with new token");
                final retryResponse = await dio.fetch(e.requestOptions);
                return handler.resolve(retryResponse);
              } else {
                debugPrint("New token is null or empty after refresh");
              }
            } catch (retryError) {
              debugPrint("Error retrying request: $retryError");
              return handler.next(e);
            }
          } else {
            debugPrint("Token refresh failed, proceeding with error");
          }
        }
        return handler.next(e);
      },
    ),
  );

  sl.registerLazySingleton<Dio>(() => dio);
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
  // sl.registerLazySingleton<AuthLocalDataSource>(
  //   () => AuthLocalDataSourceImpl(sl()), // inject Dio
  // );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()), // inject Dio
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

Future<void> _initApplicantJob() async {

}
