part of 'router.dart';

class AppRouter {
  AppRouter._(); // Private Constructor

  static final GoRouter router = GoRouter(
    navigatorKey: globalNavigatorKey,
    initialLocation: RouteName.welcomePage,
    routes: <RouteBase>[




     ...authRoutes, ...employeRoutes, ...jobRoutes, ...notificationRoutes,],
  );
}
