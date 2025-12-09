import 'dart:io';

import 'package:dio/dio.dart';

class DioErrorUtil {
  // Map DioException types to user-friendly messages
  static String handleError(DioException error) {
    String message;

    switch (error.type) {
      case DioExceptionType.cancel:
        message = "Запрос был отменён";
        break;
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message =
            "Время ожидания истекло. Проверьте интернет-соединение и попробуйте снова.";
        break;
      case DioExceptionType.badResponse:
        message = _handleResponseError(
          error.response?.statusCode,
          error.response?.data,
        );
        break;
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          message = "Нет интернет-соединения. Проверьте сеть.";
        } else {
          message = "Произошла ошибка. Пожалуйста, попробуйте снова.";
        }
        break;
      case DioExceptionType.connectionError:
        message = "Нет интернет-соединения. Проверьте сеть.";
        break;
      case DioExceptionType.badCertificate:
        message = "Ошибка сертификата безопасности. Свяжитесь с поддержкой.";
        break;
      default:
        message = "Произошла непредвиденная ошибка. Попробуйте снова.";
    }

    return message;
  }

  static String _handleResponseError(int? statusCode, dynamic errorData) {
    switch (statusCode) {
      case 400:
        return _extractMessage(errorData) ??
            "Неверный запрос. Проверьте введённые данные.";
      case 401:
        return "Сессия истекла. Пожалуйста, выполните вход снова.";
      case 403:
        return _extractMessage(errorData) ??
            "У вас нет прав для выполнения этого действия.";
      case 404:
        return "Запрашиваемый ресурс не найден.";
      case 409:
        return _extractMessage(errorData) ?? "Конфликт. Попробуйте снова.";
      case 422:
        return _extractMessage(errorData) ??
            "Ошибка валидации. Проверьте введённые данные.";
      case 500:
        return "Ошибка сервера. Наша команда уже уведомлена.";
      case 502:
        return "Сервер недоступен. Попробуйте позже.";
      case 503:
        return "Сервис временно недоступен. Попробуйте позже.";
      default:
        return _extractMessage(errorData) ??
            "Произошла ошибка. Пожалуйста, попробуйте снова.";
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
