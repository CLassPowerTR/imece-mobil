import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:imecehub/core/variables/url.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';
import 'package:imecehub/models/products.dart';
import 'package:imecehub/models/users.dart';
import 'package:shimmer/shimmer.dart';

class SepetProductsCard extends StatefulWidget {
  final Product product;
  final Map item;
  final BuildContext context;
  final Function deleteFromCart;
  final Function updateCart;
  final Function removeCart;
  final User sellerProfile;

  const SepetProductsCard({
    Key? key,
    required this.product,
    required this.item,
    required this.context,
    required this.deleteFromCart,
    required this.updateCart,
    required this.removeCart,
    required this.sellerProfile,
  }) : super(key: key);

  @override
  State<SepetProductsCard> createState() => _SepetProductsCardState();
}

class _SepetProductsCardState extends State<SepetProductsCard> {
  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final item = widget.item;
    final themeData = HomeStyle(context: context);
    final totalPrice =
        (double.tryParse(item['miktar'].toString()) ?? 0) *
        (double.tryParse(product.urunParakendeFiyat.toString()) ?? 0);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/products/productsDetail',
                arguments: widget.product.urunId ?? 0,
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isSmallScreen = constraints.maxWidth < 360;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Sol: Ürün Görseli
                          _buildProductImage(
                            product,
                            themeData,
                            isSmallScreen: isSmallScreen,
                          ),
                          SizedBox(width: isSmallScreen ? 8 : 12),

                          // Orta: Ürün Bilgileri
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildProductTitle(
                                  product,
                                  context,
                                  isSmallScreen: isSmallScreen,
                                ),
                                const SizedBox(height: 4),
                                _buildSellerName(
                                  context,
                                  isSmallScreen: isSmallScreen,
                                ),
                              ],
                            ),
                          ),

                          // Sağ üst silme butonu için alan
                          const SizedBox(width: 32),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Fiyat bilgisi
                      _buildPriceInfo(
                        product,
                        item,
                        context,
                        isSmallScreen: isSmallScreen,
                      ),
                      const SizedBox(height: 12),

                      // Alt satır: Adet seçici ve toplam fiyat
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: _buildQuantitySelector(
                              item,
                              themeData,
                              isSmallScreen: isSmallScreen,
                            ),
                          ),
                          const SizedBox(width: 12),
                          _buildTotalPrice(
                            totalPrice,
                            context,
                            isSmallScreen: isSmallScreen,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Sağ Üst: Silme İkonu
          Positioned(top: 8, right: 8, child: _buildDeleteButton(themeData)),
        ],
      ),
    );
  }

  // Ürün Görseli
  Widget _buildProductImage(
    Product product,
    themeData, {
    bool isSmallScreen = false,
  }) {
    final size = isSmallScreen ? 100.0 : 120.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[100],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: product.kapakGorseli != null && product.kapakGorseli!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl:
                    product.kapakGorseli ?? NotFound.defaultBannerImageUrl,
                fit: BoxFit.cover,
                memCacheWidth: 400,
                maxHeightDiskCache: 400,
                fadeInDuration: const Duration(milliseconds: 200),
                placeholder: (context, url) => Center(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.white,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) {
                  debugPrint('Image load error: $error for URL: $url');
                  return Container(
                    color: Colors.grey[100],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.broken_image_outlined,
                          size: isSmallScreen ? 24 : 32,
                          color: Colors.grey[400],
                        ),
                        if (!isSmallScreen) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Yüklenemedi',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              )
            : Container(
                color: Colors.grey[100],
                child: Icon(
                  Icons.image_not_supported_outlined,
                  size: isSmallScreen ? 24 : 32,
                  color: Colors.grey[400],
                ),
              ),
      ),
    );
  }

  // Ürün Başlığı
  Widget _buildProductTitle(
    Product product,
    BuildContext context, {
    bool isSmallScreen = false,
  }) {
    return Text(
      product.urunAdi ?? 'Ürün',
      style: TextStyle(
        fontSize: isSmallScreen ? 13 : 15,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1F2937),
        height: 1.3,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  // Satıcı Adı
  Widget _buildSellerName(BuildContext context, {bool isSmallScreen = false}) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/profil/sellerProfile',
          arguments: [widget.sellerProfile, false],
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.store_outlined,
            size: isSmallScreen ? 12 : 14,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              widget.sellerProfile.saticiProfili?.magazaAdi ?? 'Satıcı',
              style: TextStyle(
                fontSize: isSmallScreen ? 11 : 12,
                fontWeight: FontWeight.w500,
                color: Colors.blue[600],
                decoration: TextDecoration.underline,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Fiyat Bilgisi (Birim fiyat ve stok)
  Widget _buildPriceInfo(
    Product product,
    Map item,
    BuildContext context, {
    bool isSmallScreen = false,
  }) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Birim',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 10 : 11,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${product.urunParakendeFiyat} ₺',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 11 : 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(width: 1, color: Colors.grey[300]),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Stok',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 10 : 11,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${product.stokDurumu}',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 11 : 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Modern Adet Seçici (Pill-shaped)
  Widget _buildQuantitySelector(
    Map item,
    themeData, {
    bool isSmallScreen = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Eksi Butonu
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  if (item['miktar'] > 1) {
                    widget.removeCart();
                  } else {
                    widget.deleteFromCart();
                  }
                });
              },
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                bottomLeft: Radius.circular(24),
              ),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  item['miktar'] > 1
                      ? Icons.remove_rounded
                      : Icons.delete_outline_rounded,
                  size: 18,
                  color: item['miktar'] > 1
                      ? Colors.grey[700]
                      : Colors.red[400],
                ),
              ),
            ),
          ),

          // Miktar
          Container(
            padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 12),
            child: Text(
              '${item['miktar']}',
              style: TextStyle(
                fontSize: isSmallScreen ? 13 : 15,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
              ),
            ),
          ),

          // Artı Butonu
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  widget.updateCart();
                });
              },
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.add_rounded,
                  size: 18,
                  color: Colors.green[600],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Toplam Fiyat
  Widget _buildTotalPrice(
    double totalPrice,
    BuildContext context, {
    bool isSmallScreen = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Toplam',
          style: TextStyle(
            fontSize: isSmallScreen ? 10 : 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${totalPrice.toStringAsFixed(2)} ₺',
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF4ECDC4),
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // Silme Butonu (Sağ Üst)
  Widget _buildDeleteButton(themeData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          widget.deleteFromCart();
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(Icons.close_rounded, size: 18, color: Colors.red[400]),
        ),
      ),
    );
  }
}
