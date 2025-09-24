part of '../router.dart';

final List<RouteBase> jobRoutes = [
  GoRoute(
    path: RouteName.welcomeApplicant,
    name: RouteName.welcomeApplicant,
    builder: (BuildContext context, GoRouterState state) {
      return const WelcomeJobPage();
    },
  ),
  /*
  GoRoute(
    path: RouteName.applicantHome,
    name: RouteName.applicantHome,
    pageBuilder: (context, state) {
      debugPrint("reach");
      final extra = state.extra != null ? state.extra as DataMap : {"page": 0};

      final page = extra['page'] is int
          ? extra['page'] as int
          : int.tryParse(extra['page'].toString()) ?? 0;

      return CustomTransitionPage(
        key: state.pageKey,
        child: MainScreen(initialIndex: page),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeInOut));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    },
  ),
*/
  GoRoute(
    path: RouteName.applicantHome,
    name: RouteName.applicantHome,
    builder: (BuildContext context, GoRouterState state) {
      return const ApplicantTabScreen();
    },
  ),
];
