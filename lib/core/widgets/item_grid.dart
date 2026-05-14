import 'package:flutter/material.dart';
import 'package:imecehub/models/products.dart';
import 'package:imecehub/core/widgets/cards/productsCard3.dart';
import 'package:imecehub/core/widgets/cards/productsCard4.dart';

class ItemGrid extends StatelessWidget {
  final List<Product> items;
  final String cardType; // "card3" or "card4"
  final Function(int)? onFavoriteToggle;
  final Function(BuildContext, int)? onItemContextMenu;
  final List<int> favorites;

  const ItemGrid({
    super.key,
    required this.items,
    this.cardType = 'card3',
    this.onFavoriteToggle,
    this.onItemContextMenu,
    this.favorites = const [],
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        
        // Ekran genişliğine göre sütun sayısını (responsive) belirle
        int crossAxisCount = 2;
        if (width >= 1200) {
          crossAxisCount = 6;
        } else if (width >= 900) {
          crossAxisCount = 5;
        } else if (width >= 600) {
          crossAxisCount = 4;
        } else if (width >= 400) {
          crossAxisCount = 3;
        }

        // Yataydaki padding (15*2) ve aralıkları (12*(crossAxisCount-1)) çıkararak net kart genişliğini bul
        final double availableWidth = width - 30 - ((crossAxisCount - 1) * 12);
        final double itemWidth = availableWidth / crossAxisCount;
        
        // Genişliğe göre dinamik bir yükseklik hesapla (min 320, ideal olarak genişliğin 1.8 katı)
        double itemHeight = itemWidth * 1.85;
        itemHeight = itemHeight.clamp(320.0, 420.0); // Çok daralıp çok uzamasını engelle

        return GridView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisExtent: itemHeight,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final product = items[index];
            final productId = product.urunId ?? 0;
            final isFavorite = favorites.contains(productId);

            return GestureDetector(
              onLongPress: () {
                if (onItemContextMenu != null) {
                  onItemContextMenu!(context, productId);
                }
              },
              child: cardType == 'card4'
                  ? ProductsCard4(
                      product: product,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      context: context,
                      isFavorite: isFavorite,
                      onFavoriteToggle: onFavoriteToggle != null 
                          ? () => onFavoriteToggle!(productId) 
                          : null,
                    )
                  : ProductsCard3(
                      data: product,
                      isFavorite: isFavorite,
                      onFavoriteToggle: onFavoriteToggle,
                    ),
            );
          },
        );
      },
    );
  }
}
