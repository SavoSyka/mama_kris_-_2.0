part of '../router.dart';

final List<RouteBase> employeRoutes = [
  GoRoute(
    path: RouteName.employesHome,
    name: RouteName.employesHome,
    builder: (BuildContext context, GoRouterState state) {
      return const EmployeTabScreen();
    },
  ),
];
