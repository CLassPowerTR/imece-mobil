// lib/services/api_logger.dart

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_log_backend_service.dart';

/// API log seviyeleri
enum ApiLogLevel { success, warning, error, info }

/// Tek bir API log kaydı
class ApiLogEntry {
  final DateTime timestamp;
  final String method; // GET, POST, PUT, DELETE
  final String url;
  final int? statusCode;
  final ApiLogLevel level;
  final String? message;
  final int? userId;
  final String? userEmail;
  final String? requestBody;
  final String? responseBody;
  final int? durationMs;

  ApiLogEntry({
    required this.timestamp,
    required this.method,
    required this.url,
    this.statusCode,
    required this.level,
    this.message,
    this.userId,
    this.userEmail,
    this.requestBody,
    this.responseBody,
    this.durationMs,
  });

  /// Log kaydını formatlanmış string olarak döndürür
  String toFormattedString() {
    final buffer = StringBuffer();
    buffer.writeln('═══════════════════════════════════════════════════════════════');
    buffer.writeln('[${_formatTimestamp(timestamp)}] [${level.name.toUpperCase()}]');
    buffer.writeln('  Endpoint  : $method $url');
    if (statusCode != null) buffer.writeln('  Status    : $statusCode');
    buffer.writeln('  User ID   : ${userId ?? "-"}');
    buffer.writeln('  Email     : ${userEmail ?? "-"}');
    if (durationMs != null) buffer.writeln('  Süre      : ${durationMs}ms');
    if (message != null && message!.isNotEmpty) {
      buffer.writeln('  Mesaj     : $message');
    }
    if (level == ApiLogLevel.error || level == ApiLogLevel.warning) {
      if (requestBody != null && requestBody!.isNotEmpty) {
        buffer.writeln('  Request   : ${_maskSensitiveData(requestBody!)}');
      }
    }
    if (responseBody != null && responseBody!.isNotEmpty) {
      // Response'u kısalt (max 500 karakter)
      final truncated = responseBody!.length > 500
          ? '${responseBody!.substring(0, 500)}...'
          : responseBody!;
      buffer.writeln('  Response  : $truncated');
    }
    buffer.writeln('═══════════════════════════════════════════════════════════════');
    return buffer.toString();
  }

  /// Terminal çıktısı için kısa format (sadece error/warning)
  String toConsoleString() {
    final icon = level == ApiLogLevel.error ? '🔴' : '🟡';
    final label = level == ApiLogLevel.error ? 'API ERROR' : 'API WARNING';
    final userInfo = userEmail != null
        ? 'User: $userEmail'
        : (userId != null ? 'User ID: $userId' : '');
    return '$icon [$label] $method $url → ${statusCode ?? "N/A"} | ${message ?? "Bilinmeyen hata"} | $userInfo';
  }

  /// JSON formatı (backend'e gönderim için)
  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'method': method,
      'url': url,
      'status_code': statusCode,
      'level': level.name,
      'message': message,
      'user_id': userId,
      'user_email': userEmail,
      'request_body': requestBody != null ? _maskSensitiveData(requestBody!) : null,
      'response_body': responseBody,
      'duration_ms': durationMs,
    };
  }

  static String _formatTimestamp(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}.${dt.millisecond.toString().padLeft(3, '0')}';
  }

  /// Hassas verileri maskeler (password gibi)
  static String _maskSensitiveData(String data) {
    return data
        .replaceAll(RegExp(r'"password"\s*:\s*"[^"]*"'), '"password": "***"')
        .replaceAll(RegExp(r'"refresh_token"\s*:\s*"[^"]*"'), '"refresh_token": "***"')
        .replaceAll(RegExp(r'"access"\s*:\s*"[^"]*"'), '"access": "***"')
        .replaceAll(RegExp(r'"refresh"\s*:\s*"[^"]*"'), '"refresh": "***"');
  }
}

/// Merkezi API Logger
class ApiLogger {
  ApiLogger._();

  static File? _logFile;
  static bool _initialized = false;

  /// Logger'ı başlat (uygulama başlangıcında çağrılmalı)
  static Future<void> initialize() async {
    if (_initialized) return;
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logDir = Directory('${directory.path}/imecehub_logs');
      if (!await logDir.exists()) {
        await logDir.create(recursive: true);
      }
      _logFile = File('${logDir.path}/api_logs.txt');
      _initialized = true;
      debugPrint('📝 ApiLogger başlatıldı: ${_logFile!.path}');
    } catch (e) {
      debugPrint('ApiLogger başlatılamadı: $e');
    }
  }

  /// Mevcut kullanıcı bilgilerini SharedPreferences'tan çeker
  static Future<Map<String, dynamic>> _getCurrentUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('currentUserId');
      final userEmail = prefs.getString('currentUserEmail');
      return {'userId': userId, 'userEmail': userEmail};
    } catch (_) {
      return {'userId': null, 'userEmail': null};
    }
  }

  /// Ana log metodu — tüm API çağrılarını loglar
  static Future<void> log({
    required String method,
    required String url,
    int? statusCode,
    required ApiLogLevel level,
    String? message,
    int? userId,
    String? userEmail,
    String? requestBody,
    String? responseBody,
    int? durationMs,
  }) async {
    // Kullanıcı bilgisi verilmediyse SharedPreferences'tan çek
    if (userId == null && userEmail == null) {
      final userInfo = await _getCurrentUserInfo();
      userId ??= userInfo['userId'] as int?;
      userEmail ??= userInfo['userEmail'] as String?;
    }

    final entry = ApiLogEntry(
      timestamp: DateTime.now(),
      method: method,
      url: url,
      statusCode: statusCode,
      level: level,
      message: message,
      userId: userId,
      userEmail: userEmail,
      requestBody: requestBody,
      responseBody: responseBody,
      durationMs: durationMs,
    );

    // 1. TXT dosyasına yaz (tüm loglar)
    await _writeToFile(entry);

    // 2. Backend'e gönder (altyapı hazır, şimdilik dormant)
    await ApiLogBackendService.sendLog(entry);

    // 3. Terminale yazdır (sadece error ve warning)
    if (level == ApiLogLevel.error || level == ApiLogLevel.warning) {
      _printToConsole(entry);
    }
  }

  /// Logları TXT dosyasına yazar
  static Future<void> _writeToFile(ApiLogEntry entry) async {
    if (!_initialized) await initialize();
    if (_logFile == null) return;

    try {
      await _logFile!.writeAsString(
        '${entry.toFormattedString()}\n',
        mode: FileMode.append,
        flush: true,
      );
    } catch (e) {
      debugPrint('ApiLogger dosya yazma hatası: $e');
    }
  }

  /// Error ve warning loglarını terminale yazdırır
  static void _printToConsole(ApiLogEntry entry) {
    debugPrint(entry.toConsoleString());
  }

  // ─────────────────────────────────────────────────────────────────────
  // Yardımcı metotlar — API çağrılarından kolay kullanım için
  // ─────────────────────────────────────────────────────────────────────

  /// Başarılı API yanıtı logla
  static Future<void> logSuccess({
    required String method,
    required String url,
    required int statusCode,
    String? responseBody,
    int? durationMs,
  }) async {
    await log(
      method: method,
      url: url,
      statusCode: statusCode,
      level: ApiLogLevel.success,
      responseBody: responseBody,
      durationMs: durationMs,
    );
  }

  /// Warning (4xx) API yanıtı logla
  static Future<void> logWarning({
    required String method,
    required String url,
    required int statusCode,
    String? message,
    String? requestBody,
    String? responseBody,
    int? durationMs,
  }) async {
    await log(
      method: method,
      url: url,
      statusCode: statusCode,
      level: ApiLogLevel.warning,
      message: message,
      requestBody: requestBody,
      responseBody: responseBody,
      durationMs: durationMs,
    );
  }

  /// Error (5xx veya exception) API yanıtı logla
  static Future<void> logError({
    required String method,
    required String url,
    int? statusCode,
    String? message,
    String? requestBody,
    String? responseBody,
    int? durationMs,
  }) async {
    await log(
      method: method,
      url: url,
      statusCode: statusCode,
      level: ApiLogLevel.error,
      message: message,
      requestBody: requestBody,
      responseBody: responseBody,
      durationMs: durationMs,
    );
  }
}
