import 'package:flutter/material.dart';
import 'package:imecehub/core/constants/app_colors.dart';
import 'package:imecehub/models/products.dart';
import 'package:imecehub/core/variables/url.dart';
import 'package:intl/intl.dart';

class ProductsCard4 extends StatefulWidget {
  final Product product;
  final double width;
  final BuildContext context;
  final double height;
  final bool? isFavorite;
  final VoidCallback? onFavoriteToggle;

  const ProductsCard4({
    super.key,
    required this.product,
    required this.width,
    required this.context,
    required this.height,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  @override
  State<ProductsCard4> createState() => _ProductsCard4State();
}

class _ProductsCard4State extends State<ProductsCard4> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite ?? false;
  }

  void _handleFavoriteToggle() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    if (widget.onFavoriteToggle != null) {
      widget.onFavoriteToggle!();
    }
  }

  void _handleAddToCart() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ürün başarıyla sepete eklendi!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleClick() {
    final productId = widget.product.urunId;
    if (productId != null) {
      Navigator.pushNamed(
        context,
        '/home/productsDetail',
        arguments: productId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final badges = product.saticiBadges;

    // Fiyat ve İndirim Hesaplaması
    double currentDisplayPrice = 0;
    double baseReferencePrice = 0;

    if (product.satis_turu == 2 && product.groups != null) {
      currentDisplayPrice = double.tryParse(product.groups?['current_price']?.toString() ?? '0') ?? 0;
    } else {
      currentDisplayPrice = double.tryParse(product.urunParakendeFiyat ?? '0') ?? 0;
    }

    baseReferencePrice = double.tryParse(product.urunAsilFiyati ?? product.urunParakendeFiyat ?? '0') ?? 0;

    double discountAmount = baseReferencePrice - currentDisplayPrice;
    int discountPercentage = 0;
    if (baseReferencePrice > 0 && discountAmount > 0) {
      discountPercentage = ((discountAmount / baseReferencePrice) * 100).round();
    }

    return GestureDetector(
      onTap: _handleClick,
      child: Container(
        width: widget.width,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
            width: 1,
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
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      child: product.kapakGorseli != null && product.kapakGorseli!.isNotEmpty
                          ? Image.network(
                              product.kapakGorseli!,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              NotFound.defaultBannerImageUrl,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),

                  // İndirim Rozeti
                  if (discountPercentage > 0)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.shade600,
                          borderRadius: BorderRadius.circular(6),
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
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),

                  // Favori Butonu
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: _handleFavoriteToggle,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
                          ),
                        ),
                        child: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 14,
                          color: _isFavorite ? Colors.red : Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),

                  // Satıcı Rozetleri
                  if (badges != null && (badges.hizliTeslimat == true || badges.guvenilirUrun == true))
                    Positioned(
                      bottom: 6,
                      left: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (badges.hizliTeslimat == true)
                            Container(
                              margin: const EdgeInsets.only(bottom: 2),
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade500,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.bolt, size: 8, color: Colors.white),
                                  SizedBox(width: 2),
                                  Text(
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
                          if (badges.guvenilirUrun == true)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green.shade500,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_circle, size: 8, color: Colors.white),
                                  SizedBox(width: 2),
                                  Text(
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
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                                product.degerlendirmePuani?.toString() ?? '0.0',
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
                          '(${product.yorumSayisi ?? 0} Yorum)',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade400,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const Spacer(),
                        if (badges?.onayliSatici == true)
                          Icon(
                            Icons.verified,
                            size: 14,
                            color: Colors.blue.shade500,
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Ürün Adı
                    Expanded(
                      child: Text(
                        (product.urunAdi ?? '').toUpperCase(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontStyle: FontStyle.italic,
                          letterSpacing: -0.2,
                          height: 1.1,
                        ),
                      ),
                    ),

                    // Ayırıcı
                    Divider(height: 8, color: Theme.of(context).colorScheme.surfaceContainerHighest),

                    // Fiyat ve Sepet Alanı
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (discountPercentage > 0)
                          Text(
                            '₺${NumberFormat('#,##0.00', 'tr_TR').format(baseReferencePrice)}',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade400,
                              decoration: TextDecoration.lineThrough,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '₺${NumberFormat('#,##0.00', 'tr_TR').format(currentDisplayPrice)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: product.satis_turu == 2 ? Colors.orange.shade700 : Theme.of(context).colorScheme.onSurface,
                                fontStyle: FontStyle.italic,
                                letterSpacing: -0.5,
                              ),
                            ),
                            if (product.satis_turu != 2)
                              GestureDetector(
                                onTap: _handleAddToCart,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.shopping_bag_outlined,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        if (product.satis_turu == 2)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.orange.shade600,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'İMECE AVANTAJI',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                                fontStyle: FontStyle.italic,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                      ],
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
