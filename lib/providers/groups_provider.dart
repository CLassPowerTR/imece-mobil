// lib/providers/groups_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imecehub/services/api_service.dart';

// ============================================================================
// GROUP MODEL
// ============================================================================

/// Grup bilgisi modeli
class GroupInfo {
  final int groupId;
  final String groupName;
  final int capacity;
  final int usersCount;
  final double currentPrice;
  final bool isVisible;
  final String? groupInitializeTime;
  final String? productName;
  final int? amountJoined;
  final int? groupCapacityLeft;

  GroupInfo({
    required this.groupId,
    required this.groupName,
    required this.capacity,
    required this.usersCount,
    required this.currentPrice,
    required this.isVisible,
    this.groupInitializeTime,
    this.productName,
    this.amountJoined,
    this.groupCapacityLeft,
  });

  factory GroupInfo.fromJson(Map<String, dynamic> json) {
    return GroupInfo(
      groupId: json['group_id'] ?? 0,
      groupName: json['group_name'] ?? '',
      capacity: json['capacity'] ?? 0,
      usersCount: json['users_count'] ?? 0,
      currentPrice: (json['current_price'] is String)
          ? double.tryParse(json['current_price']) ?? 0.0
          : (json['current_price'] ?? 0.0).toDouble(),
      isVisible: json['is_visible'] ?? json['group_visible'] ?? false,
      groupInitializeTime: json['group_initialize_time'],
      productName: json['product_name'],
      amountJoined: json['amount_joined'],
      groupCapacityLeft: json['group_capacity_left'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'group_id': groupId,
      'group_name': groupName,
      'capacity': capacity,
      'users_count': usersCount,
      'current_price': currentPrice,
      'is_visible': isVisible,
      'group_initialize_time': groupInitializeTime,
      'product_name': productName,
      'amount_joined': amountJoined,
      'group_capacity_left': groupCapacityLeft,
    };
  }
}

// ============================================================================
// GROUPS STATE
// ============================================================================

/// Groups state
class GroupsState {
  final bool isLoading;
  final bool isJoining;
  final bool isLeaving;
  final String? error;
  final List<GroupInfo> joinedGroups;
  final GroupInfo? currentGroupInfo;

  GroupsState({
    this.isLoading = false,
    this.isJoining = false,
    this.isLeaving = false,
    this.error,
    this.joinedGroups = const [],
    this.currentGroupInfo,
  });

  GroupsState copyWith({
    bool? isLoading,
    bool? isJoining,
    bool? isLeaving,
    String? error,
    List<GroupInfo>? joinedGroups,
    GroupInfo? currentGroupInfo,
  }) {
    return GroupsState(
      isLoading: isLoading ?? this.isLoading,
      isJoining: isJoining ?? this.isJoining,
      isLeaving: isLeaving ?? this.isLeaving,
      error: error,
      joinedGroups: joinedGroups ?? this.joinedGroups,
      currentGroupInfo: currentGroupInfo ?? this.currentGroupInfo,
    );
  }
}

// ============================================================================
// GROUPS PROVIDER
// ============================================================================

final groupsProvider = NotifierProvider<GroupsNotifier, GroupsState>(
  GroupsNotifier.new,
);

class GroupsNotifier extends Notifier<GroupsState> {
  @override
  GroupsState build() {
    return GroupsState();
  }

  // ============================================================================
  // Gruba Katılma
  // ============================================================================

  /// Gruba katılma
  /// [groupId] - Katılınacak grup ID'si
  /// [amount] - Alınacak ürün miktarı
  /// [addressId] - Kullanıcıya ait adres ID'si
  Future<Map<String, dynamic>?> joinGroup({
    required int groupId,
    required int amount,
    required int addressId,
  }) async {
    state = state.copyWith(isJoining: true, error: null);

    try {
      final result = await ApiService.joinGroup(
        groupId: groupId,
        amount: amount,
        addressId: addressId,
      );

      state = state.copyWith(isJoining: false);
      debugPrint('GroupsProvider: Gruba başarıyla katılındı');
      
      // Katıldığım grupları yenile
      await fetchJoinedGroups();
      
      return result;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isJoining: false);
      debugPrint('GroupsProvider: Gruba katılırken hata: $e');
      rethrow;
    }
  }

  // ============================================================================
  // Gruptan Çıkma
  // ============================================================================

  /// Gruptan çıkma
  /// [groupId] - Çıkılacak grup ID'si
  Future<Map<String, dynamic>?> leaveGroup({
    required int groupId,
  }) async {
    state = state.copyWith(isLeaving: true, error: null);

    try {
      final result = await ApiService.leaveGroup(groupId: groupId);

      state = state.copyWith(isLeaving: false);
      debugPrint('GroupsProvider: Gruptan başarıyla çıkıldı');
      
      // Katıldığım grupları yenile
      await fetchJoinedGroups();
      
      return result;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLeaving: false);
      debugPrint('GroupsProvider: Gruptan çıkarken hata: $e');
      rethrow;
    }
  }

  // ============================================================================
  // Katıldığım Grupları Listeleme
  // ============================================================================

  /// Katıldığım grupları getir
  Future<void> fetchJoinedGroups() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await ApiService.getJoinedGroups();
      
      final List<GroupInfo> groups = [];
      if (result['joined_groups'] != null && result['joined_groups'] is List) {
        for (final groupJson in result['joined_groups']) {
          groups.add(GroupInfo.fromJson(groupJson));
        }
      }

      state = state.copyWith(isLoading: false, joinedGroups: groups);
      debugPrint('GroupsProvider: ${groups.length} grup bulundu');
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      debugPrint('GroupsProvider: Gruplar alınırken hata: $e');
      rethrow;
    }
  }

  // ============================================================================
  // Grup Bilgisi Sorgulama
  // ============================================================================

  /// Ürün ID'sine göre grup bilgisi getir
  /// [urunId] - Ürün ID'si
  Future<GroupInfo?> getGroupInfoByProduct({required int urunId}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await ApiService.getGroupInfoByProduct(urunId: urunId);
      
      if (result.isEmpty || result.containsKey('error')) {
        state = state.copyWith(isLoading: false, currentGroupInfo: null);
        return null;
      }

      final groupInfo = GroupInfo.fromJson(result);
      state = state.copyWith(isLoading: false, currentGroupInfo: groupInfo);
      debugPrint('GroupsProvider: Grup bilgisi alındı - ${groupInfo.groupName}');
      return groupInfo;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      debugPrint('GroupsProvider: Grup bilgisi alınırken hata: $e');
      return null;
    }
  }

  /// Grup ID'sine göre grup bilgisi getir
  /// [groupId] - Grup ID'si
  Future<GroupInfo?> getGroupInfoByGroupId({required int groupId}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await ApiService.getGroupInfoByGroupId(groupId: groupId);
      
      if (result.isEmpty || result.containsKey('error')) {
        state = state.copyWith(isLoading: false, currentGroupInfo: null);
        return null;
      }

      final groupInfo = GroupInfo.fromJson(result);
      state = state.copyWith(isLoading: false, currentGroupInfo: groupInfo);
      debugPrint('GroupsProvider: Grup bilgisi alındı - ${groupInfo.groupName}');
      return groupInfo;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      debugPrint('GroupsProvider: Grup bilgisi alınırken hata: $e');
      return null;
    }
  }

  // ============================================================================
  // Yardımcı Metodlar
  // ============================================================================

  /// Hata mesajını temizle
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Tüm state'i temizle
  void clearAll() {
    state = GroupsState();
  }

  /// Kullanıcının belirli bir gruba katılıp katılmadığını kontrol et
  bool isJoinedToGroup(int groupId) {
    return state.joinedGroups.any((group) => group.groupId == groupId);
  }

  /// Belirli bir gruptan kullanıcının katıldığı miktarı getir
  int? getJoinedAmount(int groupId) {
    final group = state.joinedGroups.cast<GroupInfo?>().firstWhere(
          (group) => group?.groupId == groupId,
          orElse: () => null,
        );
    return group?.amountJoined;
  }
}
