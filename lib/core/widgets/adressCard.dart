import 'package:flutter/material.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';
import 'package:imecehub/models/userAdress.dart';

class AdressCard extends StatelessWidget {
  final UserAdress adres;
  final VoidCallback? onEdit;
  const AdressCard({Key? key, required this.adres, this.onEdit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = HomeStyle(context: context);
    return Card(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.15),
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
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.home, color: theme.secondary, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        adres.baslik,
                        style: theme.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.secondary,
                        ),
                      ),
                      if (adres.varsayilanAdres) ...[
                        const SizedBox(width: 6),
                        Icon(Icons.star, color: Colors.amber, size: 18),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        adres.mahalle,
                        style: theme.bodyMedium,
                      ),
                      if (adres.adresSatiri1.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Text(
                          adres.adresSatiri1,
                          style: theme.bodyMedium,
                        ),
                      ],
                    ],
                  ),
                  if (adres.adresSatiri2.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      adres.adresSatiri2,
                      style: theme.bodyMedium,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    '${adres.il} / ${adres.ilce}',
                    style:
                        theme.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // Sağ kısım: Düzenle ikonu
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              color: theme.secondary,
              onPressed: onEdit,
              tooltip: 'Düzenle',
              padding: const EdgeInsets.all(0),
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}
