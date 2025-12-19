import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Favori ürün ID'lerini yöneten StateNotifier
class FavoritesNotifier extends StateNotifier<List<int>> {
  static const String _storageKey = 'favorite_products';

  FavoritesNotifier() : super([]) {
    _loadFavorites();
  }

  /// SharedPreferences'tan favori ürünleri yükler
  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesString = prefs.getStringList(_storageKey) ?? [];
      state = favoritesString.map((id) => int.parse(id)).toList();
    } catch (e) {
      state = [];
    }
  }

  /// Favori ürünleri SharedPreferences'a kaydeder
  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesString = state.map((id) => id.toString()).toList();
      await prefs.setStringList(_storageKey, favoritesString);
    } catch (e) {
      // Hata durumunda sessizce devam et
    }
  }

  /// Ürünü favorilere ekler veya çıkarır
  Future<void> toggle(int productId) async {
    if (state.contains(productId)) {
      state = state.where((id) => id != productId).toList();
    } else {
      state = [...state, productId];
    }
    await _saveFavorites();
  }

  /// Ürünün favori olup olmadığını kontrol eder
  bool isFavorite(int productId) {
    return state.contains(productId);
  }

  /// Tüm favorileri temizler
  Future<void> clearAll() async {
    state = [];
    await _saveFavorites();
  }

  /// Favorileri yeniden yükler
  Future<void> refresh() async {
    await _loadFavorites();
  }
}

/// Favori ürünleri sağlayan Provider
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<int>>(
  (ref) => FavoritesNotifier(),
);

/// Belirli bir ürünün favori olup olmadığını kontrol eden Provider
final isFavoriteProvider = Provider.family<bool, int>((ref, productId) {
  final favorites = ref.watch(favoritesProvider);
  return favorites.contains(productId);
});
