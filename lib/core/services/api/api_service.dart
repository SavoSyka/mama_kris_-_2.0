import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:mama_kris/core/constants/app_constants.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/features/appl/app_auth/data/data_sources/auth_local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
              return handler.next(e);
            }
          } else {
            debugPrint("Token refresh failed, proceeding with error");
          }
        }
        return handler.next(e);
      },
    ),
  );

  sl.registerLazySingleton<Dio>(() => dio);
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
    } else {
      debugPrint(
        "Refresh token failed: ${response.statusCode} - ${response.data}",
      );
    }
  } catch (e) {
    debugPrint("Error refreshing access token: $e");
  }

  return false;
}
