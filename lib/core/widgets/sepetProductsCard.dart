import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:imecehub/models/products.dart';
import 'package:imecehub/core/widgets/text.dart';

class SepetProductsCard extends StatelessWidget {
  final Product product;
  final Map item;
  final BuildContext context;

  const SepetProductsCard({
    Key? key,
    required this.product,
    required this.item,
    required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: product.kapakGorseli != null && product.kapakGorseli != ''
            ? Image.network(product.kapakGorseli!,
                width: 56, height: 56, fit: BoxFit.cover)
            : Icon(Icons.image_not_supported),
        title: customText(product.urunAdi ?? 'Ürün Adı Yok', context),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customText(
                'Adet Fiyat: ${product.urunMinFiyat ?? '-'} TL', context),
            customText('Miktar: ${item['miktar'] ?? '-'} Adet', context),
            customText(
              'Eklenme Tarihi: ' +
                  (item['sepete_ekleme_tarihi'] != null
                      ? DateFormat('yyyy-MM-dd HH:mm')
                          .format(DateTime.parse(item['sepete_ekleme_tarihi']))
                      : '-'),
              context,
            ),
            customText(
              'Toplam Fiyat: ${_calculateTotalPrice(product.urunMinFiyat, item['miktar'])} TL',
              context,
            ),
            customText(
                'Maks. Miktar: ${product.stokDurumu ?? '-'} Adet', context),
          ],
        ),
      ),
    );
  }

  String _calculateTotalPrice(dynamic fiyat, dynamic miktar) {
    try {
      final doubleFiyat = double.tryParse(fiyat?.toString() ?? '') ?? 0.0;
      final intMiktar = int.tryParse(miktar?.toString() ?? '') ?? 0;
      return (doubleFiyat * intMiktar).toStringAsFixed(2);
    } catch (e) {
      return '-';
    }
  }
}
