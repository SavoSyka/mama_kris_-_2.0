part of '../router.dart';

final List<RouteBase> subscriptions = [
  GoRoute(
    path: RouteName.subscription,
    name: RouteName.subscription,

    builder: (BuildContext context, GoRouterState state) {
      return const SubscriptionScreenTab();
    },
  ),

  GoRoute(
    name: RouteName.paymentWebView,
    path: '/payment-webview',
    builder: (context, state) {
      // Safely extract data from extra
      final extra = state.extra as Map<String, dynamic>?;

      final String url =
          extra?['url'] as String? ??
          (throw ArgumentError('Payment URL is required'));

      final VoidCallback? onSuccess = extra?['onSuccess'] as VoidCallback?;
      final VoidCallback? onFail = extra?['onFail'] as VoidCallback?;
      final VoidCallback? onCallback = extra?['onCallBack'] as VoidCallback?;

      return PaymentWebViewPage(
        url: url,

        onSuccess: onSuccess, // optional extra callback
        onFail: onFail, // optional extra callback
      );
    },
  ),

  GoRoute(
    path: RouteName.paymentCheckingPage,
    name: RouteName.paymentCheckingPage,

    builder: (BuildContext context, GoRouterState state) {
      return const PaymentCheckingPage();
    },
  ),

  GoRoute(
    path: RouteName.viewPaymentScreenDetail,
    name: RouteName.viewPaymentScreenDetail,

    builder: (BuildContext context, GoRouterState state) {
      return const ViewPaymentScreenDetail();
    },
  ),
];
