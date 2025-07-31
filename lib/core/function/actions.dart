import 'package:flutter/material.dart';
import 'package:imecehub/services/api_service.dart';
import 'package:imecehub/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imecehub/core/widgets/showTemporarySnackBar.dart';

Future<void> handleFavoriteAction({
  required BuildContext context,
  required WidgetRef ref,
  required bool isLoggedIn,
  required bool isFavorite,
  required int? urunId,
  required Map<int, int> productIdToFavoriteId,
  required VoidCallback onSuccess,
  required VoidCallback onFail,
}) async {
  if (!isLoggedIn) {
    showTemporarySnackBar(context, 'Lütfen giriş yapınız',
        type: SnackBarType.info);
    onFail();
    return;
  }
  final user = ref.read(userProvider);
  if (isFavorite) {
    // Favoriden çıkar
    final favoriteProductId = productIdToFavoriteId[urunId];
    if (favoriteProductId != null) {
      try {
        await ApiService.fetchUserFavorites(
            null, null, null, favoriteProductId);
        showTemporarySnackBar(context, 'Favoriden çıkarıldı',
            type: SnackBarType.success);
        onSuccess();
      } catch (e) {
        showTemporarySnackBar(context, 'Hata: $e', type: SnackBarType.error);
        onFail();
      }
    }
  } else {
    // Favoriye ekle
    try {
      await ApiService.fetchUserFavorites(null, user!.id, urunId, null);
      showTemporarySnackBar(context, 'Favoriye eklendi',
          type: SnackBarType.success);
      onSuccess();
    } catch (e) {
      showTemporarySnackBar(context, 'Hata: $e', type: SnackBarType.error);
      onFail();
    }
  }
}

Future<void> handleSepetAction({
  required BuildContext context,
  required bool isLoggedIn,
  required bool isInSepet,
  required int? urunId,
  required VoidCallback onSuccess,
  required VoidCallback onFail,
  required VoidCallback onNavigateToCart,
}) async {
  if (!isLoggedIn) {
    showTemporarySnackBar(context, 'Lütfen giriş yapınız',
        type: SnackBarType.info);
    onFail();
    return;
  }
  if (isInSepet) {
    onNavigateToCart();
  } else {
    try {
      await ApiService.fetchSepetEkle(1, urunId ?? 0);
      showTemporarySnackBar(context, 'Sepete eklendi',
          type: SnackBarType.success);
      onSuccess();
    } catch (e) {
      showTemporarySnackBar(context, 'Sepete eklenirken bir hata oluştu: $e',
          type: SnackBarType.error);
      onFail();
    }
  }
}
