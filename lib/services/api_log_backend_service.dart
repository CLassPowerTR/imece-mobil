// lib/services/api_log_backend_service.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'api_logger.dart';

/// Backend loglama altyapısı
/// 
/// Bu servis şimdilik dormant (pasif) durumda.
/// Backend'de log database'i hazır olduğunda [isEnabled] flag'ini `true` yaparak
/// aktifleştirilecek. Tüm API logları otomatik olarak backend'e gönderilecek.
class ApiLogBackendService {
  ApiLogBackendService._();

  /// Backend loglama aktif mi?
  /// Database hazır olduğunda `true` yapılacak.
  static bool isEnabled = false;

  /// Backend log endpoint URL'i (.env'den okunur)
  static String get _logApiUrl => dotenv.env['LOG_API_URL'] ?? '';

  /// Log kaydını backend'e gönderir
  /// 
  /// [isEnabled] `false` ise hiçbir istek göndermez.
  /// Backend hazır olduğunda:
  /// 1. `isEnabled = true` yapılacak
  /// 2. `.env`'de `LOG_API_URL` ayarlanacak
  /// 3. Backend'de log tablosu oluşturulacak
  static Future<void> sendLog(ApiLogEntry entry) async {
    if (!isEnabled) return;
    if (_logApiUrl.isEmpty) {
      debugPrint('⚠️ LOG_API_URL tanımlı değil, backend loglama atlanıyor.');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(_logApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'X-API-Key': dotenv.env['API_KEY'] ?? '',
        },
        body: json.encode(entry.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        debugPrint(
          '⚠️ Backend log gönderilemedi: ${response.statusCode} — ${response.body}',
        );
      }
    } catch (e) {
      // Backend log gönderilemezse sessizce devam et
      // Ana uygulama akışını bozmamak için
      debugPrint('⚠️ Backend log gönderim hatası: $e');
    }
  }

  /// Toplu log gönderimi (ileride kullanılabilir)
  /// Birden fazla log kaydını tek istekle gönderir
  static Future<void> sendBatchLogs(List<ApiLogEntry> entries) async {
    if (!isEnabled) return;
    if (_logApiUrl.isEmpty) return;

    try {
      final response = await http.post(
        Uri.parse('${_logApiUrl}batch/'),
        headers: {
          'Content-Type': 'application/json',
          'X-API-Key': dotenv.env['API_KEY'] ?? '',
        },
        body: json.encode({
          'logs': entries.map((e) => e.toJson()).toList(),
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        debugPrint(
          '⚠️ Backend toplu log gönderilemedi: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('⚠️ Backend toplu log gönderim hatası: $e');
    }
  }
}
