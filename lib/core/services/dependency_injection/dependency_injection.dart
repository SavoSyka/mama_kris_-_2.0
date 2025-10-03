part of 'dependency_import.dart';

final getIt = GetIt.instance;

Future<void> dependencyInjection() async {
  await _initSharedPref();
  await _initLocalCache();
  await _initDio();
  await _initForceUpdate();
  _initAuth();
  await _initJobSearch();
  await _initjobPosting();
  await _initProfile();
  await _initNotifications();
}

Future<bool> refreshAccessToken() async {
  final prefs = await SharedPreferences.getInstance();
  final refreshToken = prefs.getString('refresh_token');

  if (refreshToken == null || refreshToken.isEmpty) {
    debugPrint("No refresh token available");
    return false;
  }

  try {
    final dio = getIt<Dio>(); // Use singleton Dio instance
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
          final token = await getIt<AuthLocalDataSource>().getToken();
          if (token != null && token.isNotEmpty) {
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
              final newToken = await getIt<AuthLocalDataSource>().getToken();
              if (newToken != null && newToken.isNotEmpty) {
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

  getIt.registerLazySingleton<Dio>(() => dio);
}

Future<void> _initLocalCache() async {
  await Hive.initFlutter();

  Hive.registerAdapter(SearchJobModelAdapter());
  Hive.registerAdapter(NotificationModelAdapter());

  final searchJobsBox = await Hive.openBox<SearchJobModel>(
    HiveConstants.searchJobBox,
  );

  getIt.registerLazySingleton<Box<SearchJobModel>>(() => searchJobsBox);
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

Future<void> _initJobSearch() async {
  // DataSource

  getIt.registerLazySingleton<JobsLocalDataSource>(
    () => JobsLocalDataSourceImpl(),
  );

  getIt.registerLazySingleton<JobsRemoteDataSource>(
    () => JobsRemoteDataSourceImpl(dio: getIt(), local: getIt()),
  );

  // Repository
  getIt.registerLazySingleton<JobsRepository>(
    () => JobsRepositoryImpl(getIt()),
  );

  // UseCase
  getIt.registerLazySingleton<GetQueryJobsUsecase>(
    () => GetQueryJobsUsecase(getIt()),
  );

  getIt.registerLazySingleton<GetAllVacanciesUsecase>(
    () => GetAllVacanciesUsecase(getIt()),
  );

  getIt.registerLazySingleton<SearchCombinedUsecase>(
    () => SearchCombinedUsecase(getIt()),
  );
  // blocs

  getIt.registerFactory(
    () => ApplicantHomeBloc(
      getAllVacanciesUsecase: getIt(),
      searchCombinedUsecase: getIt(),
    ),
  );

  getIt.registerFactory(() => RecentSearchesCubit(getIt()));

  getIt.registerFactory(() => JobSearchCubit(getIt()));
}

Future<void> _initjobPosting() async {
  // DataSource
  getIt.registerLazySingleton<JobPostRemoteDataSource>(
    () => JobPostRemoteDataSourceImpl(dio: getIt()),
  );

  // Repository
  getIt.registerLazySingleton<JobPostRepository>(
    () => JobPostRepositoryImpl(getIt()),
  );

  // UseCase
  getIt.registerLazySingleton<PostJobUsecase>(() => PostJobUsecase(getIt()));

  // blocs

  getIt.registerFactory(() => PostJobBloc(postJobUsecase: getIt()));
}

Future<void> _initProfile() async {
  // DataSource
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(dio: getIt()),
  );

  // Repository
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(getIt()),
  );

  // UseCase
  getIt.registerLazySingleton<UpdateAboutUsecase>(
    () => UpdateAboutUsecase(getIt()),
  );
  getIt.registerLazySingleton<UpdateContactsUsecase>(
    () => UpdateContactsUsecase(getIt()),
  );
  getIt.registerLazySingleton<UpdateEmailUsecase>(
    () => UpdateEmailUsecase(getIt()),
  );
  getIt.registerLazySingleton<UpdatePasswordUsecase>(
    () => UpdatePasswordUsecase(getIt()),
  );
  getIt.registerLazySingleton<VerifyEmailUsecase>(
    () => VerifyEmailUsecase(getIt()),
  );

  // blocs

  getIt.registerFactory(
    () => ProfileUpdateBloc(
      updateAboutUsecase: getIt(),
      updateContactsUsecase: getIt(),
      updateEmailUsecase: getIt(),
      updatePasswordUsecase: getIt(),
      verifyEmailUsecase: getIt(),
    ),
  );
}

Future<void> _initNotifications() async {
  // // Register LocalNotificationsService as singleton
  // getIt.registerLazySingleton<LocalNotificationsService>(
  //   () => LocalNotificationsService.instance(),
  // );

  // // Register FirebaseMessagingService as singleton
  // getIt.registerLazySingleton<FirebaseMessagingService>(
  //   () => FirebaseMessagingService.instance(),
  // );

  // Register NotificationLocalDataSource
  getIt.registerLazySingleton<NotificationLocalDataSource>(
    () => NotificationLocalDataSourceImpl(),
  );

  // Register NotificationRepository
  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(getIt<NotificationLocalDataSource>()),
  );

  // Register NotificationListCubit
  getIt.registerFactory<NotificationListCubit>(
    () => NotificationListCubit(getIt<NotificationRepository>()),
  );

  // Register NotificationDetailCubit
  getIt.registerFactory<NotificationDetailCubit>(
    () => NotificationDetailCubit(getIt<NotificationRepository>()),
  );
}
