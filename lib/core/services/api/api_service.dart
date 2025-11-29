import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mama_kris/core/constants/app_constants.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/core/services/navigator_key/global_navigator_key.dart';
import 'package:mama_kris/core/services/routes/route_name.dart';
import 'package:mama_kris/core/services/routes/router.dart';
import 'package:mama_kris/features/appl/app_auth/data/data_sources/auth_local_data_source.dart';
import 'package:mama_kris/features/appl/applicant_contact/domain/usecase/logout_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Flag to prevent multiple logout operations
bool _isLogoutInProgress = false;

Future<void> apiService() async {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),

      responseType: ResponseType.json,
    ),
  );

  (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (client) {
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  };

  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Skip adding access token for refresh requests
        if (options.extra['isRefreshRequest'] == true) {
          debugPrint("Skipping access token for refresh request");
          return handler.next(options);
        }

        try {
          final token = await sl<AuthLocalDataSource>().getToken();
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          } else {
            debugPrint("No access token available for request");
          }
        } catch (e) {
          debugPrint("Error retrieving token: $e");
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        // Check for subscription required 403 error
        if (e.response?.statusCode == 403) {
          try {
            final responseData = e.response?.data;
            if (responseData is Map<String, dynamic>) {
              final expectedResponse = {
                "message": "Subscription required to view more jobs",
                "error": "Forbidden",
                "statusCode": 403,
              };

               await sl<AuthLocalDataSource>().saveSubscription(false);

              // Check if response matches exactly
              if (responseData['message'] == expectedResponse['message'] &&
                  responseData['error'] == expectedResponse['error'] &&
                  responseData['statusCode'] ==
                      expectedResponse['statusCode']) {
                debugPrint(
                  "Subscription required error detected, navigating to subscription screen",
                );

                // Use AppRouter directly
                try {
                  AppRouter.router.go(RouteName.subscription);
                  debugPrint(
                    "Navigation to subscription screen executed successfully via AppRouter",
                  );
                } catch (e) {
                  debugPrint("Navigation failed via AppRouter: $e");
                  // Fallback to global navigator key with post frame callback
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (globalNavigatorKey.currentContext != null) {
                      globalNavigatorKey.currentContext!.go(
                        RouteName.subscription,
                      );
                      debugPrint(
                        "Navigation to subscription screen executed successfully via fallback",
                      );
                    } else {
                      debugPrint(
                        "Navigation failed: context is still null after post frame callback",
                      );
                    }
                  });
                }
                return handler.next(
                  e,
                ); // Still pass the error up but navigation is handled
              }
            }
          } catch (parseError) {
            debugPrint("Error parsing 403 response: $parseError");
          }
        }

        // Bypass 401 handling for auth-related paths
        if (e.requestOptions.uri.path.contains('/auth')) {
          return handler.next(e);
        }

        // Skip 401 handling for refresh requests
        if (e.response?.statusCode == 401 &&
            e.requestOptions.extra['isRefreshRequest'] != true) {
          debugPrint("401 Unauthorized detected, attempting token refresh");

          // Avoid infinite loops by checking if already retrying
          if (e.requestOptions.extra['isRetrying'] == true) {
            debugPrint("Already retrying, aborting to prevent loop");
            return handler.next(e);
          }

          // Attempt to refresh the token
          final refreshed = await refreshAccessToken();
          if (refreshed) {
            try {
              // Retrieve the new token
              final newToken = await sl<AuthLocalDataSource>().getToken();
              if (newToken.isNotEmpty) {
                // Update the original request's Authorization header
                e.requestOptions.headers['Authorization'] = 'Bearer $newToken';
                // Mark as retrying to prevent infinite loops
                e.requestOptions.extra['isRetrying'] = true;

                // Retry the original request
                debugPrint("Retrying request with new token");
                final retryResponse = await dio.fetch(e.requestOptions);
                return handler.resolve(retryResponse);
              } else {
                debugPrint("New token is null or empty after refresh");
              }
            } catch (retryError) {
              debugPrint("Error retrying request: $retryError");
              // If the retried request also fails with 401, it means the refreshed token is invalid
              if (retryError is DioException &&
                  retryError.response?.statusCode == 401) {
                debugPrint(
                  "Retried request also failed with 401, token is invalid - triggering logout",
                );
                if (!e.requestOptions.path.contains('/auth')) {
                  _handleLogout();
                }
              }
              return handler.next(e);
            }
          } else {
            debugPrint("Token refresh failed, triggering logout");
            // Trigger logout asynchronously without blocking the error response
            if (!e.requestOptions.path.contains('/auth')) {
              _handleLogout();
            }
          }
        }
        return handler.next(e);
      },
    ),
  );

  sl.registerLazySingleton<Dio>(() => dio);
}

/// Handles logout process when authentication fails
Future<void> _handleLogout() async {
  // Prevent multiple logout operations
  if (_isLogoutInProgress) {
    debugPrint("Logout already in progress, skipping");
    return;
  }

  _isLogoutInProgress = true;

  try {
    // Call logout usecase to clear data
    final logoutUsecase = sl<LogoutUsecase>();
    await logoutUsecase();

    // Navigate to welcome page using AppRouter
    AppRouter.router.go(RouteName.welcomePage);
    debugPrint("User logged out and navigated to welcome page");
  } catch (e) {
    debugPrint("Error during logout process: $e");
    // Fallback navigation using AppRouter
    try {
      AppRouter.router.go(RouteName.welcomePage);
    } catch (navError) {
      debugPrint("Fallback navigation also failed: $navError");
    }
  } finally {
    // Reset flag after a delay to allow for navigation
    Future.delayed(const Duration(seconds: 2), () {
      _isLogoutInProgress = false;
    });
  }
}

Future<bool> refreshAccessToken() async {
  final prefs = await SharedPreferences.getInstance();
  final refreshToken = prefs.getString('refresh_token');

  if (refreshToken == null || refreshToken.isEmpty) {
    debugPrint("No refresh token available");
    return false;
  }

  try {
    final dio = sl<Dio>();
    final response = await dio.post(
      'auth/refresh-token',
      options: Options(
        headers: {'Authorization': 'Bearer $refreshToken'},
        extra: {'isRefreshRequest': true},
      ),
    );

    if (response.statusCode == 201) {
      final data = response.data;
      final newAccessToken = data['accessToken'];

      if (newAccessToken != null && newAccessToken.isNotEmpty) {
        await prefs.setString('auth_token', newAccessToken);
        debugPrint("Access token refreshed successfully");
        return true;
      } else {
        debugPrint("New access token is null or empty");
      }
    } else if (response.statusCode == 401) {
      debugPrint("Refresh token is invalid (401), triggering logout");
      // Trigger logout asynchronously without blocking
      _handleLogout();
      return false;
    } else {
      debugPrint(
        "Refresh token failed: ${response.statusCode} - ${response.data}",
      );
    }
  } catch (e) {
    debugPrint("Error refreshing access token: $e");
    // If refresh fails due to network or other errors, don't logout
    // Only logout on explicit 401 from refresh endpoint
  }

  return false;
}
