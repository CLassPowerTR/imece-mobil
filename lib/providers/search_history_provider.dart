import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Arama geçmişini yöneten StateNotifier
class SearchHistoryNotifier extends StateNotifier<List<String>> {
  static const String _storageKey = 'search_history';
  static const int _maxHistoryCount = 10;

  SearchHistoryNotifier() : super([]) {
    _loadHistory();
  }

  /// SharedPreferences'tan arama geçmişini yükler
  Future<void> _loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = prefs.getStringList(_storageKey) ?? [];
      state = history;
    } catch (e) {
      state = [];
    }
  }

  /// Arama geçmişini SharedPreferences'a kaydeder
  Future<void> _saveHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_storageKey, state);
    } catch (e) {
      // Hata durumunda sessizce devam et
    }
  }

  /// Yeni bir arama terimi ekler
  /// Aynı terim varsa en üste taşır
  /// Maksimum 10 arama terimi tutar
  Future<void> addSearch(String query) async {
    if (query.trim().isEmpty) return;

    final trimmedQuery = query.trim();

    // Eğer arama terimi zaten varsa, önce çıkar
    final newState = state.where((s) => s != trimmedQuery).toList();

    // Yeni terimi en başa ekle
    newState.insert(0, trimmedQuery);

    // Maksimum sayıyı aşarsa son elemanları çıkar
    if (newState.length > _maxHistoryCount) {
      state = newState.take(_maxHistoryCount).toList();
    } else {
      state = newState;
    }

    await _saveHistory();
  }

  /// Belirli bir arama terimini siler
  Future<void> removeSearch(String query) async {
    state = state.where((s) => s != query).toList();
    await _saveHistory();
  }

  /// Tüm arama geçmişini temizler
  Future<void> clearHistory() async {
    state = [];
    await _saveHistory();
  }

  /// Arama geçmişini yeniden yükler
  Future<void> refresh() async {
    await _loadHistory();
  }
}

/// Arama geçmişini sağlayan Provider
final searchHistoryProvider =
    StateNotifierProvider<SearchHistoryNotifier, List<String>>(
      (ref) => SearchHistoryNotifier(),
    );

/// Arama geçmişi varsa true döner
final hasSearchHistoryProvider = Provider<bool>((ref) {
  final history = ref.watch(searchHistoryProvider);
  return history.isNotEmpty;
});
