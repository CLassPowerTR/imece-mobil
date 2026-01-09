// lib/providers/supports_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';

// Provider tanımlaması
final supportsProvider = NotifierProvider<SupportsNotifier, SupportsState>(
  SupportsNotifier.new,
);

// State class
class SupportsState {
  final bool isCreatingTicket;
  final String? error;

  SupportsState({
    this.isCreatingTicket = false,
    this.error,
  });

  SupportsState copyWith({
    bool? isCreatingTicket,
    String? error,
  }) {
    return SupportsState(
      isCreatingTicket: isCreatingTicket ?? this.isCreatingTicket,
      error: error ?? this.error,
    );
  }
}

class SupportsNotifier extends Notifier<SupportsState> {
  @override
  SupportsState build() {
    return SupportsState();
  }

  // ============================================================================
  // 1. Buyer Destek Talebi Oluştur
  // ============================================================================

  /// Buyer için yeni destek talebi oluşturur
  /// [name] - Kullanıcı adı (zorunlu)
  /// [email] - Email adresi (zorunlu)
  /// [phone] - Telefon numarası (opsiyonel)
  /// [subject] - Konu (zorunlu)
  /// [message] - Mesaj (zorunlu)
  /// [attachment] - Dosya eki (opsiyonel)
  Future<Map<String, dynamic>?> createBuyerSupportTicket({
    required String name,
    required String email,
    String? phone,
    required String subject,
    required String message,
    http.MultipartFile? attachment,
  }) async {
    state = state.copyWith(isCreatingTicket: true, error: null);

    try {
      final result = await ApiService.postBuyerSupportTicket(
        name: name,
        email: email,
        phone: phone,
        subject: subject,
        message: message,
        attachment: attachment,
      );

      state = state.copyWith(isCreatingTicket: false);

      debugPrint('SupportsProvider: Buyer destek talebi başarıyla oluşturuldu');
      return result;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isCreatingTicket: false);

      debugPrint('SupportsProvider: Buyer destek talebi oluşturulurken hata: $e');
      rethrow;
    }
  }

  // ============================================================================
  // 2. Seller Destek Talebi Oluştur
  // ============================================================================

  /// Seller için yeni destek talebi oluşturur
  /// [subject] - Konu (zorunlu)
  /// [message] - Mesaj (zorunlu, min 10 karakter)
  /// [attachment] - Dosya eki (opsiyonel)
  /// [accessToken] - Satıcının JWT token'ı (zorunlu)
  Future<Map<String, dynamic>?> createSellerSupportTicket({
    required String subject,
    required String message,
    http.MultipartFile? attachment,
  }) async {
    state = state.copyWith(isCreatingTicket: true, error: null);

    try {
      final result = await ApiService.postSellerSupportTicket(
        subject: subject,
        message: message,
        attachment: attachment,
      );

      state = state.copyWith(isCreatingTicket: false);

      debugPrint('SupportsProvider: Seller destek talebi başarıyla oluşturuldu');
      return result;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isCreatingTicket: false);

      debugPrint('SupportsProvider: Seller destek talebi oluşturulurken hata: $e');
      rethrow;
    }
  }

  // ============================================================================
  // Yardımcı Metodlar
  // ============================================================================

  /// Hata mesajını temizler
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Tüm verileri temizler
  void clearAll() {
    state = SupportsState();
  }
}
