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
    path: RouteName.welcomePage,
    name: RouteName.welcomePage,
    builder: (BuildContext context, GoRouterState state) {
      return const WelcomePage();
    },
  ),
];
