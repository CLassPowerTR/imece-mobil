import 'package:flutter/material.dart';
import 'package:imecehub/core/constants/app_colors.dart';
import 'package:imecehub/models/userAdress.dart';

class AdressCard extends StatelessWidget {
  final UserAdress adres;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final String? phoneNumber;

  const AdressCard({
    Key? key,
    required this.adres,
    this.onEdit,
    this.onDelete,
    this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
            spreadRadius: -5,
          ),
          BoxShadow(
            color: const Color(0xFF007AFF).withOpacity(0.02),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.white,
          width: 0.8,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- HEADER: ICON, TITLE, MENU ---
                  Row(
                    children: [
                      _buildHeaderIcon(),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              adres.baslik,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1D1D1F),
                                letterSpacing: -0.4,
                              ),
                            ),
                            if (adres.varsayilanAdres)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  "Varsayılan Teslimat Adresi",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: const Color(0xFF007AFF).withOpacity(0.8),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      _buildActionMenu(),
                    ],
                  ),
                  
                  const SizedBox(height: 20),

                  // --- ADDRESS BODY ---
                  Text(
                    '${adres.mahalle} ${adres.adresSatiri1}',
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Color(0xFF424245),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (adres.adresSatiri2.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        adres.adresSatiri2,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF86868B),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 18),

                  // --- DATA FOOTER: CHIPS ---
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      if (phoneNumber != null && phoneNumber!.isNotEmpty)
                        _buildDataChip(Icons.phone_iphone_rounded, phoneNumber!),
                      _buildDataChip(Icons.map_rounded, '${adres.ilce}, ${adres.il}'),
                      _buildDataChip(Icons.pin_drop_rounded, adres.postaKodu),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderIcon() {
    final bool isSpecial = adres.varsayilanAdres;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSpecial ? const Color(0xFF007AFF).withOpacity(0.08) : const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (isSpecial)
            BoxShadow(
              color: const Color(0xFF007AFF).withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Icon(
        _getModernIcon(adres.adresTipi),
        color: isSpecial ? const Color(0xFF007AFF) : const Color(0xFF86868B),
        size: 22,
      ),
    );
  }

  Widget _buildActionMenu() {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: const Icon(Icons.more_horiz_rounded, color: Color(0xFF86868B)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      offset: const Offset(0, 40),
      onSelected: (value) {
        if (value == 'edit') onEdit?.call();
        if (value == 'delete') onDelete?.call();
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_note_rounded, size: 20, color: Colors.blue[600]),
              const SizedBox(width: 12),
              const Text('Düzenle', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        const PopupMenuDivider(height: 1),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_sweep_rounded, size: 20, color: Colors.redAccent),
              const SizedBox(width: 12),
              Text('Sil', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.redAccent)),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getModernIcon(String type) {
    switch (type.toLowerCase()) {
      case 'ev': return Icons.home_outlined;
      case 'is':
      case 'iş': return Icons.business_center_rounded;
      case 'teslimat': return Icons.local_shipping_rounded;
      case 'fatura': return Icons.receipt_long_rounded;
      default: return Icons.location_on_rounded;
    }
  }

  Widget _buildDataChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7).withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8ED), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF86868B)),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF424245),
              letterSpacing: -0.2,
            ),
          ),
        ],
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
                  AppColors.secondary(context).withOpacity(0.1),
                  AppColors.secondary(context).withOpacity(0.05),
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
                    color: AppColors.secondary(context).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getAddressIcon(adresTipi),
                    color: AppColors.secondary(context),
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
                          color:  AppColors.secondary(context).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          adresTipi.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color:  AppColors.secondary(context),
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
                          color: AppColors.primary(context),
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
                            color:  AppColors.secondary(context),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Değiştir',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color:  AppColors.secondary(context),
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
                      color:  AppColors.secondary(context).withOpacity(0.7),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        ilIlce,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary(context),
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
                      color:  AppColors.secondary(context).withOpacity(0.7),
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
