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
  final bool isLoading;
  final bool isCreatingTicket;
  final bool isUpdatingTicket;
  final List<dynamic> tickets;
  final Map<String, dynamic>? ticketDetail;
  final List<dynamic> staffUsers;
  final String? error;

  SupportsState({
    this.isLoading = false,
    this.isCreatingTicket = false,
    this.isUpdatingTicket = false,
    this.tickets = const [],
    this.ticketDetail,
    this.staffUsers = const [],
    this.error,
  });

  SupportsState copyWith({
    bool? isLoading,
    bool? isCreatingTicket,
    bool? isUpdatingTicket,
    List<dynamic>? tickets,
    Map<String, dynamic>? ticketDetail,
    List<dynamic>? staffUsers,
    String? error,
  }) {
    return SupportsState(
      isLoading: isLoading ?? this.isLoading,
      isCreatingTicket: isCreatingTicket ?? this.isCreatingTicket,
      isUpdatingTicket: isUpdatingTicket ?? this.isUpdatingTicket,
      tickets: tickets ?? this.tickets,
      ticketDetail: ticketDetail ?? this.ticketDetail,
      staffUsers: staffUsers ?? this.staffUsers,
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
  // 1. Yeni Destek Talebi Oluştur
  // ============================================================================

  /// Yeni destek talebi oluşturur
  /// [name] - Kullanıcı adı (zorunlu)
  /// [email] - Email adresi (zorunlu)
  /// [phone] - Telefon numarası (opsiyonel)
  /// [subject] - Konu (zorunlu)
  /// [message] - Mesaj (zorunlu)
  /// [attachment] - Dosya eki (opsiyonel)
  Future<Map<String, dynamic>?> createSupportTicket({
    required String name,
    required String email,
    String? phone,
    required String subject,
    required String message,
    http.MultipartFile? attachment,
  }) async {
    state = state.copyWith(isCreatingTicket: true, error: null);

    try {
      final result = await ApiService.postSupportTicket(
        name: name,
        email: email,
        phone: phone,
        subject: subject,
        message: message,
        attachment: attachment,
      );

      state = state.copyWith(isCreatingTicket: false);

      debugPrint('SupportsProvider: Destek talebi başarıyla oluşturuldu');
      return result;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isCreatingTicket: false);

      debugPrint('SupportsProvider: Destek talebi oluşturulurken hata: $e');
      rethrow;
    }
  }

  // ============================================================================
  // 2. Ticket Listesi (Admin)
  // ============================================================================

  /// Tüm destek taleplerini getirir (Admin)
  /// [status] - Durum filtresi (opsiyonel): pending, in_progress, resolved, closed
  /// [subject] - Konu filtresi (opsiyonel)
  /// [search] - Arama terimi (opsiyonel)
  Future<void> fetchTickets({
    String? status,
    String? subject,
    String? search,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await ApiService.fetchSupportTickets(
        status: status,
        subject: subject,
        search: search,
      );

      state = state.copyWith(tickets: result, isLoading: false);

      debugPrint(
        'SupportsProvider: ${state.tickets.length} destek talebi başarıyla getirildi',
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
        tickets: [],
      );

      debugPrint('SupportsProvider: Destek talepleri getirilirken hata: $e');
      rethrow;
    }
  }

  // ============================================================================
  // 3. Ticket Detayı (Admin)
  // ============================================================================

  /// Belirli bir destek talebinin detaylarını getirir (Admin)
  /// [ticketId] - Ticket ID
  Future<void> fetchTicketDetail(int ticketId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await ApiService.fetchSupportTicketDetail(ticketId);

      state = state.copyWith(ticketDetail: result, isLoading: false);

      debugPrint('SupportsProvider: Ticket detayı başarıyla getirildi');
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
        ticketDetail: null,
      );

      debugPrint('SupportsProvider: Ticket detayı getirilirken hata: $e');
      rethrow;
    }
  }

  // ============================================================================
  // 4. Ticket Durumunu Güncelle (Admin)
  // ============================================================================

  /// Ticket durumunu günceller (Admin)
  /// [ticketId] - Ticket ID
  /// [status] - Yeni durum: pending, in_progress, resolved, closed
  Future<Map<String, dynamic>?> updateTicketStatus({
    required int ticketId,
    required String status,
  }) async {
    state = state.copyWith(isUpdatingTicket: true, error: null);

    try {
      final result = await ApiService.patchSupportTicketStatus(
        ticketId: ticketId,
        status: status,
      );

      debugPrint('SupportsProvider: Ticket durumu başarıyla güncellendi');

      // Ticket detayı yüklüyse güncelle
      if (state.ticketDetail != null && state.ticketDetail!['id'] == ticketId) {
        final updatedDetail = Map<String, dynamic>.from(state.ticketDetail!);
        updatedDetail['status'] = status;
        state = state.copyWith(ticketDetail: updatedDetail);
      }

      // Ticket listesinde varsa güncelle
      final ticketIndex = state.tickets.indexWhere((t) => t['id'] == ticketId);
      if (ticketIndex != -1) {
        final updatedTickets = List<dynamic>.from(state.tickets);
        updatedTickets[ticketIndex]['status'] = status;
        state = state.copyWith(tickets: updatedTickets);
      }

      state = state.copyWith(isUpdatingTicket: false);
      return result;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isUpdatingTicket: false);

      debugPrint('SupportsProvider: Ticket durumu güncellenirken hata: $e');
      rethrow;
    }
  }

  // ============================================================================
  // 5. Ticket'ı Personele Ata (Admin)
  // ============================================================================

  /// Ticket'ı bir personele atar (Admin)
  /// [ticketId] - Ticket ID
  /// [assignedTo] - Atanacak personelin user ID'si
  Future<Map<String, dynamic>?> assignTicket({
    required int ticketId,
    required int assignedTo,
  }) async {
    state = state.copyWith(isUpdatingTicket: true, error: null);

    try {
      final result = await ApiService.patchSupportTicketAssign(
        ticketId: ticketId,
        assignedTo: assignedTo,
      );

      debugPrint('SupportsProvider: Ticket başarıyla atandı');

      // Ticket detayı yüklüyse güncelle
      if (state.ticketDetail != null && state.ticketDetail!['id'] == ticketId) {
        final updatedDetail = Map<String, dynamic>.from(state.ticketDetail!);
        updatedDetail['assigned_to'] = assignedTo;
        state = state.copyWith(ticketDetail: updatedDetail);
      }

      // Ticket listesinde varsa güncelle
      final ticketIndex = state.tickets.indexWhere((t) => t['id'] == ticketId);
      if (ticketIndex != -1) {
        final updatedTickets = List<dynamic>.from(state.tickets);
        updatedTickets[ticketIndex]['assigned_to'] = assignedTo;
        state = state.copyWith(tickets: updatedTickets);
      }

      state = state.copyWith(isUpdatingTicket: false);
      return result;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isUpdatingTicket: false);

      debugPrint('SupportsProvider: Ticket atanırken hata: $e');
      rethrow;
    }
  }

  // ============================================================================
  // 6. Ticket Notlarını Güncelle (Admin)
  // ============================================================================

  /// Ticket notlarını günceller (Admin)
  /// [ticketId] - Ticket ID
  /// [notes] - Yeni notlar
  Future<Map<String, dynamic>?> updateTicketNotes({
    required int ticketId,
    required String notes,
  }) async {
    state = state.copyWith(isUpdatingTicket: true, error: null);

    try {
      final result = await ApiService.patchSupportTicketNotes(
        ticketId: ticketId,
        notes: notes,
      );

      debugPrint('SupportsProvider: Ticket notları başarıyla güncellendi');

      // Ticket detayı yüklüyse güncelle
      if (state.ticketDetail != null && state.ticketDetail!['id'] == ticketId) {
        final updatedDetail = Map<String, dynamic>.from(state.ticketDetail!);
        updatedDetail['notes'] = notes;
        state = state.copyWith(ticketDetail: updatedDetail);
      }

      // Ticket listesinde varsa güncelle
      final ticketIndex = state.tickets.indexWhere((t) => t['id'] == ticketId);
      if (ticketIndex != -1) {
        final updatedTickets = List<dynamic>.from(state.tickets);
        updatedTickets[ticketIndex]['notes'] = notes;
        state = state.copyWith(tickets: updatedTickets);
      }

      state = state.copyWith(isUpdatingTicket: false);
      return result;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isUpdatingTicket: false);

      debugPrint('SupportsProvider: Ticket notları güncellenirken hata: $e');
      rethrow;
    }
  }

  // ============================================================================
  // 7. Staff Kullanıcıları Listesi (Admin)
  // ============================================================================

  /// Staff kullanıcılarını getirir (Admin)
  Future<void> fetchStaffUsers() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await ApiService.fetchStaffUsers();

      state = state.copyWith(staffUsers: result, isLoading: false);

      debugPrint(
        'SupportsProvider: ${state.staffUsers.length} staff kullanıcı başarıyla getirildi',
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
        staffUsers: [],
      );

      debugPrint('SupportsProvider: Staff kullanıcıları getirilirken hata: $e');
      rethrow;
    }
  }

  // ============================================================================
  // 8. Toplu Durum Güncelleme (Admin)
  // ============================================================================

  /// Birden fazla ticket'ın durumunu aynı anda günceller (Admin)
  /// [ticketIds] - Ticket ID'leri listesi
  /// [status] - Yeni durum: resolved veya closed
  Future<List<Map<String, dynamic>>> bulkUpdateTicketStatus({
    required List<int> ticketIds,
    required String status,
  }) async {
    state = state.copyWith(isUpdatingTicket: true, error: null);

    try {
      // Paralel istekler gönder
      final futures = ticketIds.map((ticketId) {
        return ApiService.patchSupportTicketStatus(
          ticketId: ticketId,
          status: status,
        );
      }).toList();

      final results = await Future.wait(futures);

      debugPrint(
        'SupportsProvider: ${ticketIds.length} ticket durumu toplu olarak güncellendi',
      );

      // Ticket listesindeki durumları güncelle
      final updatedTickets = List<dynamic>.from(state.tickets);
      for (final ticketId in ticketIds) {
        final ticketIndex = updatedTickets.indexWhere(
          (t) => t['id'] == ticketId,
        );
        if (ticketIndex != -1) {
          updatedTickets[ticketIndex]['status'] = status;
        }
      }

      state = state.copyWith(tickets: updatedTickets, isUpdatingTicket: false);

      return results;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isUpdatingTicket: false);

      debugPrint(
        'SupportsProvider: Toplu ticket durumu güncellenirken hata: $e',
      );
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

  /// Ticket detayını temizler
  void clearTicketDetail() {
    state = state.copyWith(ticketDetail: null);
  }

  /// Tüm verileri temizler
  void clearAll() {
    state = SupportsState();
  }
}
