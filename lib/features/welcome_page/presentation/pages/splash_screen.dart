import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/utils/version_utils.dart';
import 'package:mama_kris/features/auth/data/data_source/auth_local_data_source.dart';
import 'package:mama_kris/features/welcome_page/application/force_update_bloc.dart';
import 'package:mama_kris/features/welcome_page/application/force_update_event.dart';
import 'package:mama_kris/features/welcome_page/application/force_update_state.dart';
import 'package:mama_kris/features/welcome_page/domain/usecase/check_force_update_usecase.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  bool isAndroid = true;
  String appVersion = '';

  @override
  void initState() {
    super.initState();

    // 1. Animation controller for scaling
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkAppStatus();
  }

  Future<void> _checkAppStatus() async {
    // context.pushReplacementNamed(RouteName.welcomePage);

    // return;
    final platform = Theme.of(context).platform == TargetPlatform.iOS
        ? "ios"
        : "android";
    final packageInfo = await PackageInfo.fromPlatform();
    const version = "1.6.0";
    // packageInfo.version;

    setState(() {
      appVersion = version;
    });
    if (platform.toLowerCase().contains('ios')) {
      setState(() {
        isAndroid = false;
      });
    }

    if (mounted) {
      context.read<ForceUpdateBloc>().add(
        CheckForceUpdateEvent(versionNumber: version, platformType: platform),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: BlocConsumer<ForceUpdateBloc, ForceUpdateState>(
            listener: (context, state) async {
              if (state is ForceUpdateLoaded) {
                if (VersionUtils.isUpdateRequired(
                  appVersion,
                  state.data.version,
                )) {
                  context.pushReplacementNamed(
                    RouteName.forceUpdate,
                    extra: {"isAndroid": isAndroid},
                  );
                } else {
                  final isApplicant = await getIt<AuthLocalDataSource>()
                      .getUserType();

                  if (isApplicant) {
                    context.pushReplacementNamed(RouteName.applicantHome);
                    return;
                  }
                  context.pushReplacementNamed(RouteName.welcomePage);
                  // context.pushReplacementNamed(RouteName.welcomePage);
                }
              }

              // TODO: implement listener
            },
            builder: (context, state) {
              if (state is ForceUpdateError) {
                return Center(child: CustomText(text: state.message));
              }
              return CustomImageView(
                imagePath: MediaRes.illustrationWelcome,
                width: 200.w,
              );
            },
          ),
        ),
      ),
    );
  }
}
