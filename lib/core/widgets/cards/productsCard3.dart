import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imecehub/core/constants/app_colors.dart';
import 'package:imecehub/models/products.dart';
import 'package:imecehub/core/variables/url.dart';
import 'package:imecehub/providers/cart_provider.dart';
import 'package:imecehub/screens/home/home_screen.dart';
import 'package:intl/intl.dart';

class ProductsCard3 extends ConsumerWidget {
  final Product data;
  final bool isFavorite;
  final Function(int)? onFavoriteToggle;

  const ProductsCard3({
    Key? key,
    required this.data,
    this.isFavorite = false,
    this.onFavoriteToggle,
  }) : super(key: key);

  void _handleClick(BuildContext context) {
    if (data.urunId != null) {
      Navigator.pushNamed(
        context,
        '/home/productsDetail',
        arguments: data.urunId,
      );
    }
  }

  Widget _renderStars(dynamic ratingVal) {
    double rating = double.tryParse(ratingVal?.toString() ?? '0') ?? 0;
    int fullStars = rating.floor();
    bool hasHalfStar = (rating % 1) != 0;

    List<Widget> stars = [];
    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(Icons.star, color: Colors.amber, size: 14));
    }
    if (hasHalfStar) {
      stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 14));
    }
    while (stars.length < 5) {
      stars.add(const Icon(Icons.star_border, color: Colors.amber, size: 14));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: stars,
    );
  }

  String _stripHtml(String? text) {
    if (text == null) return '';
    return text.replaceAll(RegExp(r'<[^>]*>?', multiLine: true), '');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double asilFiyat = double.tryParse(data.urunAsilFiyati ?? data.urunParakendeFiyat ?? '0') ?? 0;
    final double satisFiyati = double.tryParse(data.urunParakendeFiyat ?? '0') ?? 0;
    final bool hasDiscount = asilFiyat > satisFiyati;
    final int discountPercentage = hasDiscount 
        ? (((asilFiyat - satisFiyati) / asilFiyat) * 100).round() 
        : 0;

    final isSepet = ref.watch(cartProvider).items.any((item) => item.product.urunId == data.urunId);

    return GestureDetector(
      onTap: () => _handleClick(context),
      child: Container(
        width: 160,
        height: 340,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Resim Alanı
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: data.kapakGorseli != null && data.kapakGorseli!.isNotEmpty
                          ? Image.network(
                              data.kapakGorseli!,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              NotFound.defaultBannerImageUrl,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),

                  // İndirim Rozeti
                  if (hasDiscount)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red.shade500,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.3),
                              blurRadius: 4,
                            )
                          ],
                        ),
                        child: Text(
                          '%$discountPercentage İNDİRİM',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),

                  // Satıcı Rozetleri
                  if (data.saticiBadges != null && (data.saticiBadges!.hizliTeslimat == true || data.saticiBadges!.guvenilirUrun == true))
                    Positioned(
                      bottom: 6,
                      left: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (data.saticiBadges!.hizliTeslimat == true)
                            Container(
                              margin: const EdgeInsets.only(bottom: 2),
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade500,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.bolt, size: 8, color: Colors.white),
                                  const SizedBox(width: 2),
                                  const Text(
                                    'HIZLI TESLİMAT',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 6,
                                      fontWeight: FontWeight.w900,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (data.saticiBadges!.guvenilirUrun == true)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green.shade500,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.check_circle, size: 8, color: Colors.white),
                                  const SizedBox(width: 2),
                                  const Text(
                                    'ANALİZLİ ÜRÜN',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 6,
                                      fontWeight: FontWeight.w900,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // İçerik Alanı
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Puan ve Yorum
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star, size: 10, color: Colors.amber),
                              const SizedBox(width: 2),
                              Text(
                                data.degerlendirmePuani?.toString() ?? '0.0',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.amber.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${data.yorumSayisi ?? 0} Yorum)',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade400,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const Spacer(),
                        if (data.saticiBadges?.onayliSatici == true)
                          Icon(
                            Icons.verified,
                            size: 14,
                            color: Colors.blue.shade500,
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 6),
                    
                    // Ürün Adı
                    Text(
                      (data.urunAdi ?? '').toUpperCase(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontStyle: FontStyle.italic,
                        letterSpacing: -0.2,
                        height: 1.1,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Açıklama
                    Expanded(
                      child: Text(
                        _stripHtml(data.aciklama),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade400,
                          fontStyle: FontStyle.italic,
                          height: 1.4,
                        ),
                      ),
                    ),

                    // Ayırıcı ve Fiyat Alanı
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (hasDiscount)
                            Text(
                              '₺${NumberFormat('#,##0.00', 'tr_TR').format(asilFiyat)}',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade400,
                                decoration: TextDecoration.lineThrough,
                                letterSpacing: -0.5,
                              ),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '₺${NumberFormat('#,##0.00', 'tr_TR').format(satisFiyati)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: Theme.of(context).colorScheme.onSurface,
                                  letterSpacing: -1,
                                ),
                              ),
                              if (isSepet)
                                GestureDetector(
                                  onTap: () {
                                    ref.read(bottomNavIndexProvider.notifier).setIndex(2);
                                    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary(context).withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Icon(Icons.shopping_cart_checkout, size: 16, color: Colors.white),
                                  ),
                                )
                              else
                                GestureDetector(
                                  onTap: () {
                                    ref.read(cartProvider.notifier).addToCart(data);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Ürün sepete eklendi!'),
                                        backgroundColor: Colors.green,
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary(context),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.shopping_cart_outlined,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
