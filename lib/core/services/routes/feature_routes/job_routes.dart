part of '../router.dart';

final List<RouteBase> jobRoutes = [
  GoRoute(
    path: RouteName.welcomeApplicant,
    name: RouteName.welcomeApplicant,
    builder: (BuildContext context, GoRouterState state) {
      return const WelcomeJobPage();
    },
  ),

  GoRoute(
    path: RouteName.applicantHome,
    name: RouteName.applicantHome,
    builder: (BuildContext context, GoRouterState state) {
      return const ApplicantTabScreen();
    },
  ),
];
