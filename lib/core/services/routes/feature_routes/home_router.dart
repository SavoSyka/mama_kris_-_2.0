part of '../router.dart';

final List<RouteBase> homeRoutes = [
  GoRoute(
    path: RouteName.home,
    name: RouteName.home,
    builder: (BuildContext context, GoRouterState state) {
      return const HomePage();
    },
  ),
 
];
