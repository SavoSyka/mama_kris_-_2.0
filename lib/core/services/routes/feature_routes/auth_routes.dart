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
      return const WelcomePage();
    },
  ),

  GoRoute(
    path: RouteName.authPage,
    name: RouteName.authPage,
    builder: (BuildContext context, GoRouterState state) {
      final extra = state.extra as DataMap;
      return AuthScreenPage(isApplicant: extra['isApplicant'] as bool);
    },
  ),
];
