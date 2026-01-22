import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/core/services/lifecycle/bloc/life_cycle_manager_bloc.dart';
import 'package:mama_kris/core/services/navigator_key/global_navigator_key.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/features/appl/app_auth/data/data_sources/auth_local_data_source.dart';

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
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.paused) {
      // End session when app is closed or goes to background
      _endSession();
    }
  }

  Future<void> _endSession() async {
    try {
      final sessionId = await sl<AuthLocalDataSource>().getSessionId();
      if (sessionId != null) {
        final endDate = DateTime.now().toUtc().toIso8601String();
        final bloc = sl<LifeCycleManagerBloc>();
        bloc.add(EndUserSessionEvent(
          endDate: endDate,
          sessionId: sessionId,
        ));
        // Remove session ID after ending session
        await sl<AuthLocalDataSource>().removeSessionId();
      }
    } catch (e) {
      debugPrint('Error ending session: $e');
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
