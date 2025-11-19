part of '../router.dart';

final List<RouteBase> authRoutes = [
  GoRoute(
    path: RouteName.initialPage,
    name: RouteName.initialPage,
    builder: (BuildContext context, GoRouterState state) {
      return const SplashScreen();
    },
  ),

  GoRoute(
    path: RouteName.forceUpdate,
    name: RouteName.forceUpdate,
    builder: (BuildContext context, GoRouterState state) {
      final extra = state.extra as Map<String, dynamic>;

      return ForceUpdateScreen(isAndroid: extra['isAndroid']);
    },
  ),
  GoRoute(
    path: RouteName.welcomePage,
    name: RouteName.welcomePage,
    builder: (BuildContext context, GoRouterState state) {
      return
      // const ApplSignupScreen();
      // const EmpLoginScreen();
      const WelcomePage();
    },
  ),

  GoRoute(
    path: RouteName.loginApplicant,
    name: RouteName.loginApplicant,
    builder: (BuildContext context, GoRouterState state) {
      return BlocProvider.value(
        value: sl<AuthBloc>(),
        child: const ApplLoginScreen(),
      );
    },
  ),

  GoRoute(
    path: RouteName.signupApplicant,
    name: RouteName.signupApplicant,
    builder: (BuildContext context, GoRouterState state) {
      return const ApplSignupScreen();
    },
  ),

  GoRoute(
    path: RouteName.verifyOptApplicant,
    name: RouteName.verifyOptApplicant,
    builder: (BuildContext context, GoRouterState state) {
      var name = '';
      var email = '';
      var password = '';
      var isFrom = '';
      final extra = state.extra;

      if (extra is DataMap) {
        name = extra['name'] as String;
        email = extra['email'] as String;
        password = extra['password'] as String;
        isFrom = extra['source'] as String;
      }
      return ApplVerifyOtpScreen(
        name: name,
        email: email,
        password: password,
        isFrom: isFrom,
      );
    },
  ),

  GoRoute(
    path: RouteName.forgotApplicant,
    name: RouteName.forgotApplicant,
    builder: (BuildContext context, GoRouterState state) {
      return const ApplForgotPasswordScreen();
    },
  ),

  GoRoute(
    path: RouteName.updateApplicantPwd,
    name: RouteName.updateApplicantPwd,
    builder: (BuildContext context, GoRouterState state) {
      return const ApplUpdatePasswordScreen();
    },
  ),

  // * forgot, and verify left here.
  GoRoute(
    path: RouteName.loginEmploye,
    name: RouteName.loginEmploye,
    builder: (BuildContext context, GoRouterState state) {
      return const EmpLoginScreen();
    },
  ),

  GoRoute(
    path: RouteName.signupEmploye,
    name: RouteName.signupEmploye,
    builder: (BuildContext context, GoRouterState state) {
      return const EmpSignupScreen();
    },
  ),

  GoRoute(
    path: RouteName.verifyOtpEmployee,
    name: RouteName.verifyOtpEmployee,
    builder: (BuildContext context, GoRouterState state) {
      var name = '';
      var email = '';
      var password = '';

      var isFrom = "";
      final extra = state.extra;

      if (extra is DataMap) {
        name = extra['name'] as String;
        email = extra['email'] as String;
        password = extra['password'] as String;
        isFrom = extra['source'] as String;
      }
      return EmpVerifyOtpScreen(
        name: name,
        email: email,
        password: password,
        isFrom: isFrom,
      );
    },
  ),

  GoRoute(
    path: RouteName.forgotEmployee,
    name: RouteName.forgotEmployee,
    builder: (BuildContext context, GoRouterState state) {
      return const EmpForgotPasswordScreen();
    },
  ),

  GoRoute(
    path: RouteName.updateEmployeePwd,
    name: RouteName.updateEmployeePwd,
    builder: (BuildContext context, GoRouterState state) {
      return const EmpUpdatePasswordScreen();
    },
  ),
];
