import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/core/services/lifecycle/lifecycle_manager.dart';
import 'package:mama_kris/core/services/routes/router.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/features/appl/app_auth/application/bloc/auth_bloc.dart';
import 'package:mama_kris/features/appl/appl_favorite/presentation/bloc/liked_job_bloc_bloc.dart';
import 'package:mama_kris/features/appl/appl_home/presentation/bloc/job_bloc.dart';
import 'package:mama_kris/features/appl/appl_profile/presentation/bloc/user_bloc.dart';
import 'package:mama_kris/features/appl/applicant_contact/presentation/bloc/applicant_contact_bloc.dart';
import 'package:mama_kris/features/emp/emp_auth/application/bloc/emp_auth_bloc.dart';
import 'package:mama_kris/features/emp/emp_home/presentation/cubit/create_job_cubit.dart';
import 'package:mama_kris/features/emp/emp_profile/application/bloc/emp_user_bloc.dart';
import 'package:mama_kris/features/emp/emp_resume/presentation/bloc/resume_bloc.dart';
import 'package:mama_kris/features/emp/employe_contact/presentation/bloc/employee_contact_bloc.dart';
import 'package:mama_kris/features/subscription/application/bloc/subscription_bloc.dart';
import 'package:mama_kris/features/welcome_page/application/force_update_bloc.dart';
import 'package:mama_kris/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mama_kris/screens/main_screen.dart';
import 'package:mama_kris/screens/welcome_screen.dart';
import 'package:mama_kris/utils/funcs.dart' as funcs;
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:mama_kris/constants/api_constants.dart';
import 'package:mama_kris/screens/update_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('ru_RU', null);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Force status bar icons to dark
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  // Initialize Firebase app, handling potential duplicate app error in debug mode
  // try {
  //   print('Checking if Firebase app exists...');
  //   // Try to get the default app - if it exists, we don't need to initialize
  //   Firebase.app();
  //   print('Firebase app already exists, skipping initialization');
  // } catch (e) {
  //   // App doesn't exist, so initialize it
  //   try {
  //     print('Initializing Firebase app...');
  //     await Firebase.initializeApp(
  //       options: DefaultFirebaseOptions.currentPlatform,
  //     );
  //     print('Firebase app initialized successfully.');
  //   } catch (initError) {
  //     print('Firebase initialization error: $initError');
  //     // Continue anyway in debug mode
  //     print('Continuing despite Firebase initialization error...');
  //   }
  // }
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // final localNotificationsService = LocalNotificationsService.instance();
  // await localNotificationsService.init();

  // final firebaseMessagingService = FirebaseMessagingService.instance();
  // await firebaseMessagingService.init(
  //   localNotificationsService: localNotificationsService,
  // );

  await dependencyInjection();

  // final localNotificationsService = getIt<LocalNotificationsService>();
  // await localNotificationsService.init();
  // final firebaseMessagingService = getIt<FirebaseMessagingService>();
  // await firebaseMessagingService.init(
  //   localNotificationsService: localNotificationsService,
  // );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()),
        BlocProvider(create: (_) => sl<EmpAuthBloc>()),
        BlocProvider(create: (_) => sl<ResumeBloc>()),
        BlocProvider(create: (_) => sl<JobBloc>()),
        BlocProvider(create: (_) => sl<LikedJobBlocBloc>()),
        BlocProvider(create: (_) => sl<UserBloc>()),
        BlocProvider(create: (_) => sl<ForceUpdateBloc>()),
        BlocProvider(create: (_) => sl<SubscriptionBloc>()),
        BlocProvider(create: (context) => sl<EmpUserBloc>()),
        BlocProvider(create: (context) => sl<CreateJobCubit>()),
        BlocProvider(create: (context) => sl<ApplicantContactBloc>()),
        BlocProvider(create: (context) => sl<EmployeeContactBloc>()),


      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(400, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return LifecycleManager(
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,
            theme: AppTheme.lightTheme,

            supportedLocales: const [Locale('en', 'US'), Locale('ru', 'RU')],

            localizationsDelegates: const [
              // Material localization
              GlobalMaterialLocalizations.delegate,

              // Widgets localization
              GlobalWidgetsLocalizations.delegate,

              // Cupertino localization (REQUIRED for CupertinoDatePicker)
              GlobalCupertinoLocalizations.delegate,
            ],

            locale: const Locale('ru', 'RU'),
            // home: const AppInitializer(),
          ),
        );
      },
    );
  }
}

/// Обёртка, которая отслеживает жизненный цикл приложения
/// и вызывает startSession при открытии и endSession при закрытии.
class SessionManager extends StatefulWidget {
  final Widget child;
  const SessionManager({super.key, required this.child});

  @override
  State<SessionManager> createState() => _SessionManagerState();
}

class _SessionManagerState extends State<SessionManager>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _handleAppOpen();
  }

  @override
  void dispose() {
    _handleAppClose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await _handleAppOpen();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      await _handleAppClose();
    }
  }

  Future<void> _handleAppOpen() async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    String? accessToken = prefs.getString('auth_token');
    if (userId != null && accessToken != null) {
      // print("SessionManager: Starting session for user $userId");
      await funcs.startSession(userId, accessToken);
    }
  }

  Future<void> _handleAppClose() async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    String? accessToken = prefs.getString('auth_token');
    if (userId != null && accessToken != null) {
      // print("SessionManager: Ending session for user $userId");
      await funcs.endSession(userId, accessToken);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Инициализирует приложение и определяет начальный экран
class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  late Future<Widget> _initialScreenFuture;

  Future<Widget> _determineInitialScreen() async {
    // Проверяем, нужна ли версия обновления:
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String currentVersion = packageInfo.version;
    bool updateRequired = false;
    try {
      final response = await http.get(
        Uri.parse('${kBaseUrl}client-version/1'),
        headers: {'accept': '*/*'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String minRequiredVersion = data['version'];
        if (_compareVersion(currentVersion, minRequiredVersion) < 0) {
          updateRequired = true;
          // print(
          //   "Update needed: current version $currentVersion, min required $minRequiredVersion",
          // );
        } else {
          // print(
          //   "No update needed: current version $currentVersion, min required $minRequiredVersion",
          // );
        }
      } else {
        // print("Error checking version: ${response.statusCode}");
      }
    } catch (e) {
      // print("Exception while checking version: $e");
    }
    if (updateRequired) {
      // Здесь можно вернуть экран обновления приложения
      // Например:
      return const UpdateScreen();
      // Пока что выводим отладочное сообщение и возвращаем WelcomeScreen().
      // print("Update screen should be displayed here (code commented out)");
      // return WelcomeScreen();
    }

    // Далее определяем начальный экран на основании состояния входа пользователя
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLogged') ?? false;
    String? currentPage = prefs.getString('current_page');
    String? accessToken = prefs.getString('auth_token');
    int? userId = prefs.getInt('user_id');
    String? refreshToken = prefs.getString('refresh_token');
    // print("isLoggedIn: $isLoggedIn");
    if (isLoggedIn &&
        refreshToken != null &&
        refreshToken.isNotEmpty &&
        userId != null) {
      // Обновляем токен и данные пользователя
      await funcs.refreshAccessToken();
      if (accessToken != null) {
        await funcs.updateUserDataInCache(accessToken, userId);
        await funcs.updateSelectedSpheres();
        await funcs.fetchAdvertisementBanner();
        bool hasSubscription = await funcs.hasSubscription();
        await prefs.setBool('has_subscription', hasSubscription);

        int viewedCount = await funcs.getViewedCount(accessToken, userId);
        await prefs.setInt('viewed_count', viewedCount);

        int likedCount = await funcs.getLikedCount(accessToken, userId);
        await prefs.setInt('liked_count', likedCount);
        // Если currentPage равен "tinder" или "job", запускаем MainScreen, иначе WelcomeScreen
        if (currentPage == 'tinder' ||
            currentPage == 'search' ||
            currentPage == 'job') {
          return const MainScreen();
        } else {
          return const WelcomeScreen();
        }
      } else {
        return const WelcomeScreen();
      }
    } else {
      return const WelcomeScreen();
    }
  }

  // Функция сравнения версий
  int _compareVersion(String currentVersion, String minRequiredVersion) {
    List<int> currentList = currentVersion.split('.').map(int.parse).toList();
    List<int> requiredList = minRequiredVersion
        .split('.')
        .map(int.parse)
        .toList();
    for (int i = 0; i < 3; i++) {
      int current = i < currentList.length ? currentList[i] : 0;
      int required = i < requiredList.length ? requiredList[i] : 0;
      if (current > required) return 1;
      if (current < required) return -1;
    }
    return 0;
  }

  @override
  void initState() {
    super.initState();
    _initialScreenFuture = _determineInitialScreen();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _initialScreenFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Ошибка: ${snapshot.error}")),
          );
        } else {
          return snapshot.data!;
        }
      },
    );
  }
}
