part of '../router.dart';

final List<RouteBase> employeRoutes = [
  GoRoute(
    path: RouteName.homeEmploye,
    name: RouteName.homeEmploye,
    builder: (BuildContext context, GoRouterState state) {
      final extra = state.extra != null
          ? state.extra as DataMap
          : {"pageIndex": 0};
      debugPrint("extra $extra");
      return EmpHomeTabScreen(pageIndex: extra['pageIndex'] as int);
    },
  ),

  GoRoute(
    path: RouteName.employesHome,
    name: RouteName.employesHome,
    builder: (BuildContext context, GoRouterState state) {
      return const EmployeTabScreen();
    },
  ),
  GoRoute(
    path: RouteName.postJob,
    name: RouteName.postJob,
    builder: (BuildContext context, GoRouterState state) {
      return const PostJobPage();
    },
  ),
];
