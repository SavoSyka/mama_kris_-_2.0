import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/services/navigator_key/global_navigator_key.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';

class LifecycleManager extends StatefulWidget {
  final Widget child;

  const LifecycleManager({super.key, required this.child});

  @override
  State<LifecycleManager> createState() => _LifecycleManagerState();
}

class _LifecycleManagerState extends State<LifecycleManager>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.paused) {
      // navigateAfterDelay();
    }
  }

  Future<void> navigateAfterDelay() async {
    await Future.delayed(const Duration(minutes: 10));
    if (!mounted) return;

    globalNavigatorKey.currentContext?.go(RouteName.initialPage);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
