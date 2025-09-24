import 'package:flutter/material.dart';
import 'package:imecehub/core/constants/app_colors.dart';
import 'package:imecehub/core/constants/app_paddings.dart';
import 'package:imecehub/core/constants/app_radius.dart';
import 'package:imecehub/core/constants/app_textSizes.dart';
import 'package:imecehub/core/widgets/container.dart';
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

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: SizedBox(
              width: 100,
              height: 100,
              child: Image.network(
                icMapUrl,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox();
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 30, left: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    title,
                    context,
                    textAlign: TextAlign.left,
                    weight: FontWeight.bold,
                    size: AppTextSizes.bodyMedium(context),
                  ),
                  customText(
                    ilIlce,
                    context,
                    textAlign: TextAlign.left,
                    weight: FontWeight.bold,
                    size: 18,
                  ),
                  customText(
                    adres,
                    context,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    textAlign: TextAlign.left,
                  ),
                  Card(
                    color: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.r8,
                    ),
                    child: Padding(
                      padding: AppPaddings.all4,
                      child: Text(
                        adresTipi,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: AppTextSizes.bodyMedium(context),
                            color: AppColors.primary(context),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    margin: const EdgeInsets.all(0),
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                        onPressed: onLocationChange,
                        child: const Text(
                          'Konum bilgileri değiştir',
                          style: TextStyle(
                              color: Color.fromARGB(255, 34, 255, 34),
                              fontWeight: FontWeight.w900),
                        )),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
