part of '../router.dart';

final List<RouteBase> employeRoutes = [
  GoRoute(
    path: RouteName.welcomeEmploye,
    name: RouteName.welcomeEmploye,
    builder: (BuildContext context, GoRouterState state) {
      return const WelcomeEmployeesPage();
    },
  ),

];
