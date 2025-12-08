import 'dart:io';

import 'package:dio/dio.dart';

class DioErrorUtil {
  // Map DioException types to user-friendly messages
  static String handleError(DioException error) {
    String message;

    switch (error.type) {
      case DioExceptionType.cancel:
        message = "Request was cancelled";
        break;
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = "Connection timed out. Please check your internet and try again.";
        break;
      case DioExceptionType.badResponse:
        message = _handleResponseError(error.response?.statusCode, error.response?.data);
        break;
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          message = "No internet connection. Please check your network.";
        } else {
          message = "Something went wrong. Please try again.";
        }
        break;
      case DioExceptionType.badCertificate:
        message = "Security certificate error. Please contact support.";
        break;
      default:
        message = "An unexpected error occurred. Please try again.";
    }

    return message;
  }

  static String _handleResponseError(int? statusCode, dynamic errorData) {
    switch (statusCode) {
      case 400:
        return _extractMessage(errorData) ?? "Invalid request. Please check your input.";
      case 401:
        return "Session expired. Please log in again.";
      case 403:
        // This will be overridden by your existing subscription logic
        return _extractMessage(errorData) ?? "You don't have permission to perform this action.";
      case 404:
        return "Requested resource not found.";
      case 409:
        return _extractMessage(errorData) ?? "Conflict occurred. Try again.";
      case 422:
        return _extractMessage(errorData) ?? "Validation failed. Check your input.";
      case 500:
        return "Server error. Our team has been notified.";
      case 502:
        return "Server is down. Please try again later.";
      case 503:
        return "Service unavailable. Please try again later.";
      default:
        return _extractMessage(errorData) ?? "An error occurred. Please try again.";
    }
  }

  static String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] ??
          data['error'] ??
          data['detail'] ??
          data['errors']?.toString();
    }
    if (data is String) return data;
    return null;
  }
}