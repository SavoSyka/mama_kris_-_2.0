part of '../router.dart';

final List<RouteBase> notificationRoutes = [
  GoRoute(
    path: RouteName.notificationList,
    name: RouteName.notificationList,
    builder: (BuildContext context, GoRouterState state) {
      return BlocProvider(
        create: (context) => sl<NotificationListCubit>(),
        child: const NotificationListPage(),
      );
    },
  ),

  GoRoute(
    path: '${RouteName.notificationDetail}/:id',
    name: RouteName.notificationDetail,
    builder: (BuildContext context, GoRouterState state) {
      final notificationId = state.pathParameters['id']!;
      return BlocProvider(
        create: (context) => sl<NotificationDetailCubit>(),
        child: NotificationDetailPage(notificationId: notificationId),
      );
    },
  ),
];