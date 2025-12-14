import 'package:flutter/material.dart';
import 'package:imecehub/core/widgets/text.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';
import 'package:imecehub/models/userAdress.dart';

class AdressCard extends StatelessWidget {
  final UserAdress adres;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  const AdressCard({
    Key? key,
    required this.adres,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = HomeStyle(context: context);
    return Card(
      color: Colors.grey.shade100,
      elevation: 2,
      shadowColor: HomeStyle(context: context).outline,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sol kısım: Adres detayları
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  // Başlık ve varsa yıldız
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Builder(builder: (context) {
                        if (adres.adresTipi == 'ev') {
                          return Icon(Icons.home,
                              color: theme.secondary, size: 22);
                        } else if (adres.adresTipi == 'is') {
                          return Icon(Icons.business,
                              color: theme.secondary, size: 22);
                        } else if (adres.adresTipi == 'teslimat') {
                          return Icon(Icons.delivery_dining,
                              color: theme.secondary, size: 22);
                        } else if (adres.adresTipi == 'fatura') {
                          return Icon(Icons.receipt,
                              color: theme.secondary, size: 22);
                        } else {
                          return Icon(Icons.location_on,
                              color: theme.secondary, size: 22);
                        }
                      }),
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              adres.baslik,
                              style: theme.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: theme.secondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            if (adres.varsayilanAdres) ...[
                              const SizedBox(width: 6),
                              Icon(Icons.star, color: Colors.amber, size: 18),
                            ],
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              color: theme.secondary,
                              onPressed: onEdit,
                              tooltip: 'Düzenle',
                              padding: const EdgeInsets.all(0),
                              constraints: const BoxConstraints(),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 20),
                              color: Colors.red,
                              onPressed: onDelete,
                              tooltip: 'Sil',
                              padding: const EdgeInsets.all(0),
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  customText(adres.mahalle, context),
                  // Adres satırları alt alta
                  if (adres.adresSatiri1.isNotEmpty) ...[
                    Text(
                      adres.adresSatiri1,
                      style: theme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                  if (adres.adresSatiri2.isNotEmpty) ...[
                    Text(
                      adres.adresSatiri2,
                      style: theme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                  // İl / İlçe en altta
                  Text(
                    '${adres.il} / ${adres.ilce}',
                    style:
                        theme.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdressCardOrder extends StatelessWidget {
  final String ilIlce;
  final String adres;
  final String icMapUrl;
  final String adresTipi;
  final VoidCallback? onLocationChange;
  final String title;
  const AdressCardOrder({
    Key? key,
    required this.ilIlce,
    required this.adres,
    required this.icMapUrl,
    required this.adresTipi,
    required this.title,
    this.onLocationChange,
  }) : super(key: key);

  IconData _getAddressIcon(String type) {
    switch (type.toLowerCase()) {
      case 'ev':
        return Icons.home_rounded;
      case 'is':
      case 'iş':
        return Icons.business_rounded;
      case 'teslimat':
        return Icons.local_shipping_rounded;
      case 'fatura':
        return Icons.receipt_long_rounded;
      default:
        return Icons.location_on_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = HomeStyle(context: context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Üst kısım: Icon, Adres Tipi ve Değiştir butonu
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.secondary.withOpacity(0.1),
                  theme.secondary.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                // Sol: Modern Icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.secondary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getAddressIcon(adresTipi),
                    color: theme.secondary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                // Orta: Adres Tipi ve Başlık
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.secondary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          adresTipi.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: theme.secondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: theme.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Sağ: Değiştir Butonu
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: onLocationChange,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.edit_location_alt_outlined,
                            size: 18,
                            color: theme.secondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Değiştir',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: theme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Alt kısım: Adres Detayları
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // İl/İlçe
                Row(
                  children: [
                    Icon(
                      Icons.location_city_rounded,
                      size: 18,
                      color: theme.secondary.withOpacity(0.7),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        ilIlce,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: theme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Adres Detayı
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.description_outlined,
                      size: 18,
                      color: theme.secondary.withOpacity(0.7),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        adres,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.grey[700],
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
