import 'package:flutter/material.dart';
import 'package:imecehub/services/api_service.dart';
import 'package:intl/intl.dart';
import 'package:imecehub/models/products.dart';
import 'package:imecehub/core/widgets/text.dart';

class SepetProductsCard extends StatefulWidget {
  final Product product;
  final Map item;
  final BuildContext context;
  final Function deleteFromCart;

  const SepetProductsCard({
    Key? key,
    required this.product,
    required this.item,
    required this.context,
    required this.deleteFromCart,
  }) : super(key: key);

  @override
  State<SepetProductsCard> createState() => _SepetProductsCardState();
}

class _SepetProductsCardState extends State<SepetProductsCard> {
  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final item = widget.item;
    return GestureDetector(
      onTap: () {
        setState(() {
          Navigator.pushNamed(context, '/products/productsDetail',
              arguments: widget.product);
        });
      },
      child: Card(
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
                'Toplam Fiyat: ${_calculateTotalPrice(product.urunMinFiyat, item['miktar'])} TL',
                context,
              ),
              customText(
                  'Maks. Miktar: ${product.stokDurumu ?? '-'} Adet', context),
              customText(
                  'Eklenme Tarihi: ' +
                      (item['sepete_ekleme_tarihi'] != null
                          ? DateFormat('yyyy-MM-dd HH:mm').format(
                              DateTime.parse(item['sepete_ekleme_tarihi']))
                          : '-'),
                  context,
                  maxLines: 2),
              customText(
                  'Tahmini Teslimat Tarihi: ${item['tahmini_teslimat_tarihi'] ?? 'Henüz Belirli Değil'}',
                  context,
                  maxLines: 2),
            ],
          ),
          trailing: IconButton(
            onPressed: () {
              widget.deleteFromCart();
            },
            icon: Icon(Icons.delete_outline, color: Colors.red),
          ),
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
