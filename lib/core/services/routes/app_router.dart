part of 'router.dart';

class AppRouter {
  AppRouter._(); // Private Constructor

  static final GoRouter router = GoRouter(
    navigatorKey: globalNavigatorKey,

    initialLocation: RouteName.initialPage,// inital page for checking force update.
    // initialLocation: RouteName
    //     .welcomePage, // displays where users selcet between applicant and employee

    routes: <RouteBase>[
      ...authRoutes,
      ...employeRoutes,
      ...jobRoutes,
      ...notificationRoutes,
      ...subscriptions,
    ],
  );
}
