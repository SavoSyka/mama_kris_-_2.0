import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/features/appl/app_auth/data/data_sources/auth_local_data_source.dart';

part 'subscription_status_state.dart';

class SubscriptionStatusCubit extends Cubit<SubscriptionStatusState> {
  SubscriptionStatusCubit() : super(SubscriptionStatusInitial());

  Timer? _pollingTimer;
  int _retryCount = 0;
  static const int _maxRetries = 12;
  static const Duration _pollingInterval = Duration(seconds: 10);
  static const String _endpoint = 'payments.v3/subscription-info';

  void startPolling() {
    debugPrint('Starting subscription status polling');
    emit(SubscriptionStatusLoading());
    _retryCount = 0;
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(
      _pollingInterval,
      (_) => _checkSubscriptionStatus(),
    );
    _checkSubscriptionStatus(); // Initial check
  }

  void stopPolling() {
    debugPrint('Stopping subscription status polling');
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> _checkSubscriptionStatus() async {
    try {
      final dio = sl<Dio>();

      final userId = await sl<AuthLocalDataSource>().getUserId();
      final response = await dio.get("$_endpoint/$userId");

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final hasSubscription = data['hasSubscription'] as bool? ?? false;
        final expiresAt = data['expiresAt'] != null
            ? DateTime.tryParse(data['expiresAt'])
            : null;
        final type = data['type'] as String?;

        debugPrint(
          'Subscription status: hasSubscription=$hasSubscription, expiresAt=$expiresAt, type=$type',
        );

        emit(
          SubscriptionStatusSuccess(
            hasSubscription: hasSubscription,
            expiresAt: expiresAt,
            type: type,
          ),
        );

        if (hasSubscription) {
          stopPolling();
        }
      } else {
        _handleError('Invalid response status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      _handleError('Unexpected error: $e');
    }
  }

  void _handleDioError(DioException e) {
    String errorMessage;
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Network timeout';
        break;
      case DioExceptionType.connectionError:
        errorMessage = 'Network connection error';
        break;
      case DioExceptionType.badResponse:
        errorMessage = 'Server error: ${e.response?.statusCode}';
        break;
      default:
        errorMessage = 'Network error: ${e.message}';
    }
    _handleError(errorMessage);
  }

  void _handleError(String message) {
    debugPrint('Subscription status error: $message');
    if (_retryCount < _maxRetries) {
      _retryCount++;
      final delay = Duration(seconds: pow(2, _retryCount).toInt());
      debugPrint(
        'Retrying in ${delay.inSeconds} seconds (attempt $_retryCount/$_maxRetries)',
      );
      Future.delayed(delay, _checkSubscriptionStatus);
    } else {
      emit(SubscriptionStatusError(message));
      stopPolling();
    }
  }

  @override
  Future<void> close() {
    stopPolling();
    return super.close();
  }
}
