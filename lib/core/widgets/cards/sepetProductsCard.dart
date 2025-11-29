import 'package:flutter/material.dart';
import 'package:imecehub/core/widgets/container.dart';
import 'package:imecehub/core/widgets/richText.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';
import 'package:imecehub/services/api_service.dart';
import 'package:intl/intl.dart';
import 'package:imecehub/models/products.dart';
import 'package:imecehub/core/widgets/text.dart';
import 'package:imecehub/models/users.dart';

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
    return GestureDetector(
      onTap: () {
        setState(() {
          Navigator.pushNamed(context, '/products/productsDetail',
              arguments: widget.product.urunId ?? 0);
        });
      },
      child: Stack(
        children: [
          container(
            context,
            color: themeData.surfaceContainer,
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.symmetric(vertical: 4),
            borderRadius: BorderRadius.circular(8),
            child: Column(
              children: [
                Builder(builder: (context) {
                  if (item['tahmini_teslimat_tarihi'] != null) {
                    return Text(
                        'Tahmini Teslim Tarihi: ${item['tahmini_teslimat_tarihi']}');
                  }
                  return SizedBox.shrink();
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 8,
                  children: [
                    product.kapakGorseli != null && product.kapakGorseli != ''
                        ? Image.network(product.kapakGorseli!,
                            width: 125, height: 95, fit: BoxFit.cover)
                        : Icon(Icons.image_not_supported),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 5,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          richText(context,
                              maxLines: 6,
                              color: themeData.primary,
                              textAlign: TextAlign.start,
                              children: [
                                TextSpan(
                                    text: product.urunAdi ?? 'None',
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            themeData.bodyLarge.fontSize)),
                              ]),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                Navigator.pushNamed(
                                    context, '/profil/sellerProfile',
                                    arguments: [widget.sellerProfile, false]);
                              });
                            },
                            child: Text(
                                '\n${widget.sellerProfile.saticiProfili?.magazaAdi}',
                                style: TextStyle(
                                    color: Colors.blue[300],
                                    fontWeight: FontWeight.bold,
                                    fontSize: themeData.bodyMedium.fontSize)),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Row(
                    spacing: 10,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          color:
                              Colors.grey[200], // İsteğe bağlı arka plan rengi
                          borderRadius:
                              BorderRadius.circular(5), // Köşe yuvarlaklığı 5
                          border: Border.all(
                              width: 1,
                              color: themeData
                                  .outline), // İnce bir kenarlık (opsiyonel)
                        ),
                        child: Row(
                          children: [
                            // Sol tarafta "11 KG" yazısı
                            Text(
                              '${item['miktar']} Adet',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            // Sağ tarafta - ve + butonları
                            Row(
                              children: [
                                // "-" butonu
                                Builder(builder: (context) {
                                  if (item['miktar'] > 1) {
                                    return IconButton(
                                      icon: Icon(
                                        Icons.remove,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          widget.removeCart();
                                        });
                                      },
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),
                                      iconSize: 20,
                                    );
                                  } else {
                                    return IconButton(
                                      icon: Icon(
                                        Icons.delete_forever_outlined,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          widget.deleteFromCart();
                                        });
                                      },
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),
                                      iconSize: 20,
                                    );
                                  }
                                }),
                                // "+" butonu
                                Container(
                                  color: Colors.black,
                                  height: 20,
                                  width: 1,
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors.green,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      widget.updateCart();
                                    });
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                  iconSize: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      richText(
                          textAlign: TextAlign.left,
                          fontSize: themeData.bodyMedium.fontSize,
                          context,
                          children: [
                            TextSpan(
                                text: '1 Adet: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: ' ${product.urunParakendeFiyat} TL',
                            ),
                            TextSpan(
                                text: '\nMaks: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: '${product.stokDurumu} Adet')
                          ]),
                      Expanded(
                        child: richText(
                            fontSize: themeData.bodyMedium.fontSize,
                            textAlign: TextAlign.center,
                            context,
                            maxLines: 6,
                            children: [
                              TextSpan(
                                  text: 'Ürün Tutarı',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      '\n${((double.tryParse(item['miktar'].toString()) ?? 0) * (double.tryParse(product.urunParakendeFiyat.toString()) ?? 0)).toStringAsFixed(2)} TL')
                            ]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Builder(builder: (context) {
            if (item['miktar'] > 1) {
              return Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(Icons.close_rounded, color: Colors.red),
                  onPressed: () {
                    widget.deleteFromCart();
                  },
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          }),
        ],
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
