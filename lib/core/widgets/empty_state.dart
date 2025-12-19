import 'package:flutter/material.dart';
import 'package:imecehub/core/widgets/text.dart';
import 'package:imecehub/core/widgets/buttons/textButton.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';

/// Boş durum gösterimini sağlayan yeniden kullanılabilir widget
class EmptyState extends StatelessWidget {
  /// Gösterilecek ikon
  final IconData icon;
  
  /// Başlık metni
  final String title;
  
  /// Açıklama metni
  final String message;
  
  /// Opsiyonel aksiyon butonu için callback
  final VoidCallback? onAction;
  
  /// Aksiyon butonunun metni
  final String? actionText;
  
  /// İkon rengi (opsiyonel)
  final Color? iconColor;
  
  /// İkon boyutu
  final double iconSize;

  const EmptyState({
    Key? key,
    required this.icon,
    required this.title,
    required this.message,
    this.onAction,
    this.actionText,
    this.iconColor,
    this.iconSize = 80,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = HomeStyle(context: context);
    final effectiveIconColor = iconColor ?? themeData.primary.withOpacity(0.3);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: effectiveIconColor,
            ),
            const SizedBox(height: 16),
            customText(
              title,
              context,
              size: themeData.bodyLarge.fontSize,
              weight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            customText(
              message,
              context,
              size: themeData.bodyMedium.fontSize,
              color: themeData.primary.withOpacity(0.6),
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
            if (onAction != null && actionText != null) ...[
              const SizedBox(height: 24),
              textButton(
                context,
                actionText!,
                onPressed: onAction,
                buttonColor: themeData.secondary,
                titleColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Sepet boş durumu için özelleştirilmiş widget
class EmptyCartState extends StatelessWidget {
  final VoidCallback? onGoToProducts;

  const EmptyCartState({Key? key, this.onGoToProducts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.shopping_cart_outlined,
      title: 'Sepetiniz Boş',
      message: 'Alışverişe başlamak için ürünleri keşfedin',
      actionText: 'Ürünlere Git',
      onAction: onGoToProducts,
    );
  }
}

/// Favori ürünler boş durumu için özelleştirilmiş widget
class EmptyFavoritesState extends StatelessWidget {
  final VoidCallback? onGoToProducts;

  const EmptyFavoritesState({Key? key, this.onGoToProducts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.favorite_border,
      title: 'Favori Ürününüz Yok',
      message: 'Beğendiğiniz ürünleri favorilerinize ekleyerek kolayca ulaşabilirsiniz',
      actionText: 'Ürünleri Keşfet',
      onAction: onGoToProducts,
      iconColor: Colors.red.withOpacity(0.3),
    );
  }
}

/// Sipariş geçmişi boş durumu için özelleştirilmiş widget
class EmptyOrdersState extends StatelessWidget {
  final VoidCallback? onGoToProducts;

  const EmptyOrdersState({Key? key, this.onGoToProducts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.receipt_long_outlined,
      title: 'Henüz Sipariş Yok',
      message: 'İlk siparişinizi vererek alışverişe başlayın',
      actionText: 'Alışverişe Başla',
      onAction: onGoToProducts,
    );
  }
}

/// Arama sonucu boş durumu için özelleştirilmiş widget
class EmptySearchState extends StatelessWidget {
  final String? searchQuery;
  final VoidCallback? onClearSearch;

  const EmptySearchState({
    Key? key,
    this.searchQuery,
    this.onClearSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.search_off,
      title: 'Sonuç Bulunamadı',
      message: searchQuery != null
          ? '"$searchQuery" için sonuç bulunamadı. Farklı bir arama terimi deneyin'
          : 'Arama sonucu bulunamadı',
      actionText: onClearSearch != null ? 'Aramayı Temizle' : null,
      onAction: onClearSearch,
    );
  }
}

/// Yorumlar boş durumu için özelleştirilmiş widget
class EmptyCommentsState extends StatelessWidget {
  const EmptyCommentsState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.chat_bubble_outline,
      title: 'Henüz Yorum Yok',
      message: 'Bu ürün için henüz yorum yapılmamış',
    );
  }
}
