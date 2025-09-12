part of '../router.dart';
final List<RouteBase> jobRoutes = [

  GoRoute(
    path: RouteName.welcomeJob,
    name: RouteName.welcomeJob,
    builder: (BuildContext context, GoRouterState state) {
      return  WelcomeJobPage();
    },
  ),
];
