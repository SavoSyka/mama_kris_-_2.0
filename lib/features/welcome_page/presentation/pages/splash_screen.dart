import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/common/widgets/custom_error_retry.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/utils/version_utils.dart';
import 'package:mama_kris/features/appl/app_auth/application/bloc/auth_bloc.dart';
import 'package:mama_kris/features/appl/app_auth/application/bloc/auth_event.dart';
import 'package:mama_kris/features/appl/app_auth/application/bloc/auth_state.dart';
import 'package:mama_kris/features/appl/app_auth/data/data_sources/auth_local_data_source.dart';
import 'package:mama_kris/features/appl/app_auth/data/models/user_profile_model.dart';
import 'package:mama_kris/features/appl/app_auth/domain/usecases/login_using_cached_usecase.dart';
import 'package:mama_kris/features/appl/appl_profile/presentation/bloc/user_bloc.dart';
import 'package:mama_kris/features/emp/emp_auth/application/bloc/emp_auth_bloc.dart';
import 'package:mama_kris/features/emp/emp_auth/application/bloc/emp_auth_event.dart';
import 'package:mama_kris/features/emp/emp_auth/application/bloc/emp_auth_state.dart';
import 'package:mama_kris/features/emp/emp_auth/data/models/emp_user_profile_model.dart';
import 'package:mama_kris/features/emp/emp_profile/application/bloc/emp_user_bloc.dart';
import 'package:mama_kris/features/welcome_page/application/force_update_bloc.dart';
import 'package:mama_kris/features/welcome_page/application/force_update_event.dart';
import 'package:mama_kris/features/welcome_page/application/force_update_state.dart';
import 'package:mama_kris/utils/funcs.dart' as funcs;
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
          child: BlocConsumer<EmpAuthBloc, EmpAuthState>(
            listener: (context, state) {
              if (state is EmpAuthSuccess) {
                context.read<EmpUserBloc>().add(
                  EmpGetUserProfileEvent(user: state.user.user),
                );

                if (!state.user.subscription.active) {
                  context.pushReplacementNamed(RouteName.subscription);
                } else {
                  context.pushReplacementNamed(RouteName.homeEmploye);
                }
              }
              // TODO: implement listener
            },
            builder: (context, state) {
              return BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    context.read<UserBloc>().add(
                      GetUserProfileEvent(user: state.user.user),
                    );
                    if (!state.user.subscription.active) {
                      context.pushReplacementNamed(RouteName.subscription);
                    } else {
                      context.pushReplacementNamed(RouteName.homeApplicant);
                    }
                  }
                },
                builder: (context, state) {
                  return BlocConsumer<ForceUpdateBloc, ForceUpdateState>(
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
                          _checkLoginStatus();
                        }
                      }

                      // TODO: implement listener
                    },
                    builder: (context, state) {
                      if (state is ForceUpdateError) {
                        return CustomErrorRetry(
                          onTap: _checkAppStatus,
                          errorMessage: state.message,
                        );
                        // Center(child: CustomText(text: state.message));
                      } else if (state is AuthLoading ||
                          state is EmpAuthLoading) {
                        return const CupertinoActivityIndicator(radius: 20);
                      }

                      return CustomImageView(
                        imagePath: MediaRes.illustrationWelcome,
                        width: 200.w,
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  // * ────────────── Helper Methods ───────────────────────
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

  Future<void> _checkLoginStatus() async {
    try {
      final token = await sl<AuthLocalDataSource>().getToken();
      final userType = await sl<AuthLocalDataSource>().getUserType();
      final userId = await sl<AuthLocalDataSource>().getUserId();
      final hasActiveSubscription = await sl<AuthLocalDataSource>()
          .getSubscription();

      // Check if we have valid authentication data
      if (token.isNotEmpty && userId != null) {
        if (userType) {
          context.read<AuthBloc>().add(LoginWithCachedEvent());
        } else {
          context.read<EmpAuthBloc>().add(EmpLoginWithCachedEvent());
        }
        // // Navigate to appropriate home screen based on user type
        // if (!hasActiveSubscription) {
        //   context.pushReplacementNamed(RouteName.subscription);
        // } else if (userType) {
        //   context.pushReplacementNamed(RouteName.homeApplicant);
        // } else {
        //   context.pushReplacementNamed(RouteName.homeEmploye);
        // }
      } else {
        // Token is invalid, clear stored data and go to welcome page
        await sl<AuthLocalDataSource>().clearAll();
        context.pushReplacementNamed(RouteName.welcomePage);
      }
    } catch (e) {
      // If there's any error during validation, clear data and go to welcome page
      debugPrint('Error during login status check: $e');
      await sl<AuthLocalDataSource>().clearAll();
      context.pushReplacementNamed(RouteName.welcomePage);
    }
  }

  /*
  Future<void> _checkLoginStatus() async {
    try {
      final token = await sl<AuthLocalDataSource>().getToken();
      final userType = await sl<AuthLocalDataSource>().getUserType();
      final userId = await sl<AuthLocalDataSource>().getUserId();
      final hasActiveSubscription = await sl<AuthLocalDataSource>()
          .getSubscription();

      // Check if we have valid authentication data
      if (token.isNotEmpty && userId != null) {
        // Try to validate the token by fetching user data
        final isValidSession = await _validateUserSession(
          token,
          userId,
          userType,
        );

        if (isValidSession) {
          // Load user profile into BLoC state before navigation
          await _loadUserProfileIntoBloc(userType);

          // Navigate to appropriate home screen based on user type
          if (!hasActiveSubscription) {
            context.pushReplacementNamed(RouteName.subscription);
          } else if (userType) {
            context.pushReplacementNamed(RouteName.homeApplicant);
          } else {
            context.pushReplacementNamed(RouteName.homeEmploye);
          }
        } else {
          // Token is invalid, clear stored data and go to welcome page
          await sl<AuthLocalDataSource>().clearAll();
          context.pushReplacementNamed(RouteName.welcomePage);
        }
      } else {
        // No stored authentication data, go to welcome page
        context.pushReplacementNamed(RouteName.welcomePage);
      }
    } catch (e) {
      // If there's any error during validation, clear data and go to welcome page
      debugPrint('Error during login status check: $e');
      await sl<AuthLocalDataSource>().clearAll();
      context.pushReplacementNamed(RouteName.welcomePage);
    }
  }

  /// Validates user session by attempting to fetch user profile
  Future<bool> _validateUserSession(
    String token,
    String userId,
    bool isApplicant,
  ) async {
    try {
      // You can implement a lightweight API call here to validate the token
      // For now, we'll just check if we have stored user data
      final storedUserData = await sl<AuthLocalDataSource>().getUser();

      if (storedUserData != null && storedUserData.isNotEmpty) {
        debugPrint('Valid session found for user: $userId');
        return true;
      }

      // If no stored user data, try to fetch it from API
      final success = await _fetchAndStoreUserData(token, userId, isApplicant);
      return success;
    } catch (e) {
      debugPrint('Session validation failed: $e');
      return false;
    }
  }

  /// Fetches user data from API and stores it locally
  Future<bool> _fetchAndStoreUserData(
    String token,
    String userId,
    bool isApplicant,
  ) async {
    try {
      // Use the existing function from funcs.dart to fetch and cache user data
      await funcs.updateUserDataInCache(token, int.parse(userId));

      // Verify that essential user data was stored successfully
      final userData = await sl<AuthLocalDataSource>().getUser();
      final storedName = await funcs.resolveDisplayName();
      final storedEmail = await funcs.resolveEmail();

      // Check if we have at least basic user information
      final hasValidData =
          (userData != null && userData.isNotEmpty) ||
          (storedName.isNotEmpty && storedEmail.isNotEmpty);

      if (hasValidData) {
        debugPrint('User data successfully cached for user: $userId');
        return true;
      } else {
        debugPrint('Failed to cache user data - no valid data received');
        return false;
      }
    } catch (e) {
      debugPrint('Failed to fetch user data: $e');
      return false;
    }
  }

  /// Loads user profile data into BLoC state (similar to login flow)
  Future<void> _loadUserProfileIntoBloc(bool isApplicant) async {
    try {
      // Get cached user data
      final userData = await sl<AuthLocalDataSource>().getUser();

      if (userData != null && userData.isNotEmpty) {
        if (isApplicant) {
          // For applicants: Create UserProfileEntity and trigger UserBloc event
          final userProfile = UserProfileModel.fromJson(userData);
          if (!mounted) return;

          // Check if UserBloc is available in the widget tree
          try {
            context.read<UserBloc>().add(
              GetUserProfileEvent(user: userProfile),
            );
            debugPrint('Applicant profile loaded into UserBloc');
          } catch (e) {
            debugPrint('UserBloc not available in widget tree: $e');
          }
        } else {
          // For employees: Create EmpUserProfileEntity and trigger EmpUserBloc event
          final empUserProfile = EmpUserProfileModel.fromJson(userData);
          if (!mounted) return;

          // Check if EmpUserBloc is available in the widget tree
          try {
            context.read<EmpUserBloc>().add(
              EmpGetUserProfileEvent(user: empUserProfile),
            );
            debugPrint('Employee profile loaded into EmpUserBloc');
          } catch (e) {
            debugPrint('EmpUserBloc not available in widget tree: $e');
          }
        }
      } else {
        debugPrint('No cached user data available for BLoC initialization');
      }
    } catch (e) {
      debugPrint('Error loading user profile into BLoC: $e');
      // Don't fail the entire login process if BLoC loading fails
    }
  }


*/
}
