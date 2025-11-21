part of '../router.dart';

final List<RouteBase> subscriptions = [
  GoRoute(
    path: RouteName.subscription,
    name: RouteName.subscription,

    builder: (BuildContext context, GoRouterState state) {
      return const SubscriptionScreenTab();
    },
  ),
];
