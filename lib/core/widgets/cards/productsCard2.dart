import 'package:flutter/material.dart';
import 'package:imecehub/core/constants/app_colors.dart';
import 'package:imecehub/core/variables/url.dart';
import 'package:intl/intl.dart';

class ImeceCard extends StatefulWidget {
  final Map<String, dynamic> campaign;
  final bool isFavorite;
  final Function(int)? onFavoriteToggle;

  const ImeceCard({
    Key? key,
    required this.campaign,
    this.isFavorite = false,
    this.onFavoriteToggle,
  }) : super(key: key);

  @override
  State<ImeceCard> createState() => _ImeceCardState();
}

class _ImeceCardState extends State<ImeceCard> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  void _handleFavoriteClick() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    if (widget.onFavoriteToggle != null) {
      widget.onFavoriteToggle!(widget.campaign['campaign_id']);
    }
  }

  void _handleCardClick() {
    // Navigate to Imece Detail
  }

  void _handleSellerClick() {
    // Navigate to Seller Profile
  }

  @override
  Widget build(BuildContext context) {
    final campaign = widget.campaign;

    final double capacity = double.tryParse(campaign['capacity']?.toString() ?? '1') ?? 1;
    final double currentOccupancy = double.tryParse(campaign['current_occupancy']?.toString() ?? '0') ?? 0;
    
    final double occupancyRate = (currentOccupancy / capacity) * 100;
    final int remainingSpots = (capacity - currentOccupancy).toInt();
    final bool isUrgent = remainingSpots > 0 && (remainingSpots <= 5 || occupancyRate >= 85);
    
    final badges = campaign['seller_badges'] ?? {};
    final bool hizliTeslimat = badges['hizli_teslimat'] == true;
    final bool guvenilirUrun = badges['guvenilir_urun'] == true;
    final bool onayliSatici = badges['onayli_satici'] == true;

    final double maxPrice = double.tryParse(campaign['display_max_price']?.toString() ?? '0') ?? 0;
    final double minPrice = double.tryParse(campaign['display_min_price']?.toString() ?? '0') ?? 0;
    final double currentPrice = double.tryParse(campaign['display_current_price']?.toString() ?? '0') ?? 0;

    return GestureDetector(
      onTap: _handleCardClick,
      child: Container(
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
                      child: campaign['display_image'] != null && campaign['display_image'].toString().isNotEmpty
                          ? Image.network(
                              campaign['display_image'],
                              fit: BoxFit.contain,
                            )
                          : Image.network(
                              NotFound.defaultBannerImageUrl,
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),

                  // Aciliyet Rozeti
                  if (isUrgent)
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
                          'SON $remainingSpots KİŞİ!',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),

                  // Favori Butonu
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: _handleFavoriteClick,
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
                  if (hizliTeslimat || guvenilirUrun)
                    Positioned(
                      bottom: 6,
                      left: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (hizliTeslimat)
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
                          if (guvenilirUrun)
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
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kampanya Adı
                    Text(
                      (campaign['display_title'] ?? '').toString().toUpperCase(),
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
                    
                    const SizedBox(height: 4),

                    // Satıcı Bilgisi
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _handleSellerClick,
                          child: Text(
                            (campaign['seller_name'] ?? '').toString().toUpperCase(),
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: Colors.grey.shade400,
                              fontStyle: FontStyle.italic,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        if (onayliSatici)
                          Icon(
                            Icons.verified,
                            size: 12,
                            color: Colors.blue.shade500,
                          ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // İlerleme Çubuğu
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'KATILIM: ${currentOccupancy.toInt()}/${capacity.toInt()}',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                            color: Colors.grey.shade400,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          '%${occupancyRate.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                            color: Colors.orange.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 6,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: (occupancyRate / 100).clamp(0.0, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.orange.shade600,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),
                    
                    // Ayırıcı
                    Divider(height: 8, color: Theme.of(context).colorScheme.surfaceContainerHighest),

                    // Fiyat ve Katıl Butonu
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₺${NumberFormat('#,##0.00', 'tr_TR').format(maxPrice)}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade400,
                            decoration: TextDecoration.lineThrough,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          'HEDEF ₺${NumberFormat('#,##0.00', 'tr_TR').format(minPrice)}',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: Colors.green.shade600,
                            fontStyle: FontStyle.italic,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '₺${NumberFormat('#,##0.00', 'tr_TR').format(currentPrice)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.orange.shade600,
                        fontStyle: FontStyle.italic,
                        letterSpacing: -0.5,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade600,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'ŞİMDİ KATIL',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 1,
                        ),
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
