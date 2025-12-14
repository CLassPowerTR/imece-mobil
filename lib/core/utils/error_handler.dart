// lib/core/utils/error_handler.dart

import 'package:flutter/material.dart';
import 'app_logger.dart';

class ErrorHandler {
  /// Global error handler
  static void handle(
    BuildContext context,
    dynamic error, {
    VoidCallback? onRetry,
    StackTrace? stackTrace,
  }) {
    AppLogger.e('Error occurred', error, stackTrace);

    String message = _getErrorMessage(error);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[700],
        action: onRetry != null
            ? SnackBarAction(
                label: 'Tekrar Dene',
                textColor: Colors.white,
                onPressed: onRetry,
              )
            : null,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static String _getErrorMessage(dynamic error) {
    if (error is NetworkException) {
      return 'İnternet bağlantınızı kontrol edin';
    } else if (error is AuthException) {
      return 'Oturum süreniz doldu, lütfen tekrar giriş yapın';
    } else if (error is ValidationException) {
      return error.message;
    } else if (error is ServerException) {
      return 'Sunucu hatası oluştu, lütfen daha sonra tekrar deneyin';
    } else if (error is TimeoutException) {
      return 'İşlem zaman aşımına uğradı';
    } else {
      return 'Bir hata oluştu: ${error.toString()}';
    }
  }

  /// Success mesajı göster
  static void showSuccess(BuildContext context, String message) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green[700],
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Info mesajı göster
  static void showInfo(BuildContext context, String message) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue[700],
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// Custom Exception Classes
class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'Network error occurred']);
}

class AuthException implements Exception {
  final String message;
  AuthException([this.message = 'Authentication error']);
}

class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
}

class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server error']);
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException([this.message = 'Timeout error']);
}

