import 'package:flutter/material.dart';
import 'package:imecehub/core/constants/app_colors.dart';
import 'package:imecehub/core/widgets/richText.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';
import 'package:imecehub/models/products.dart';
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
          Navigator.pushNamed(
            context,
            '/products/productsDetail',
            arguments: widget.product.urunId ?? 0,
          );
        });
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: themeData.surfaceContainer,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                // 3D Neumorphic Shadow - Dark
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  offset: const Offset(8, 8),
                  blurRadius: 15,
                  spreadRadius: 0,
                ),
                // 3D Neumorphic Shadow - Light
                BoxShadow(
                  color: Colors.white.withOpacity(0.7),
                  offset: const Offset(-8, -8),
                  blurRadius: 15,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              children: [
                Builder(
                  builder: (context) {
                    if (item['tahmini_teslimat_tarihi'] != null) {
                      return Text(
                        'Tahmini Teslim Tarihi: ${item['tahmini_teslimat_tarihi']}',
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 8,
                  children: [
                    // 3D Neumorphic Image Container
                    Container(
                      width: 125,
                      height: 95,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(4, 4),
                            blurRadius: 8,
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.6),
                            offset: const Offset(-4, -4),
                            blurRadius: 8,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child:
                            product.kapakGorseli != null &&
                                product.kapakGorseli != ''
                            ? Image.network(
                                product.kapakGorseli!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: themeData.surfaceContainer,
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      size: 40,
                                    ),
                                  );
                                },
                              )
                            : Container(
                                color: themeData.surfaceContainer,
                                child: const Icon(
                                  Icons.image_not_supported,
                                  size: 40,
                                ),
                              ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 5,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          richText(
                            context,
                            maxLines: 6,
                            color: themeData.primary,
                            textAlign: TextAlign.start,
                            children: [
                              TextSpan(
                                text: product.urunAdi ?? 'None',
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold,
                                  fontSize: themeData.bodyLarge.fontSize,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                Navigator.pushNamed(
                                  context,
                                  '/profil/sellerProfile',
                                  arguments: [widget.sellerProfile, false],
                                );
                              });
                            },
                            child: Text(
                              '\n${widget.sellerProfile.saticiProfili?.magazaAdi}',
                              style: TextStyle(
                                color: Colors.blue[300],
                                fontWeight: FontWeight.bold,
                                fontSize: themeData.bodyMedium.fontSize,
                              ),
                            ),
                          ),
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
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.only(
                          left: 12,
                          top: 4,
                          bottom: 4,
                        ),
                        decoration: BoxDecoration(
                          color: themeData.surfaceContainer,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            width: 2,
                            color: AppColors.surface(context),
                          ),
                          // İç kısım için pressed neumorphic
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(2, 2),
                              blurRadius: 4,
                              spreadRadius: 0,
                            ),
                            BoxShadow(
                              color: Colors.white.withOpacity(0.5),
                              offset: const Offset(-2, -2),
                              blurRadius: 4,
                              spreadRadius: 0,
                            ),
                          ],
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
                                Builder(
                                  builder: (context) {
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
                                  },
                                ),
                                // "+" butonu
                                Container(
                                  color: Colors.black,
                                  height: 20,
                                  width: 1,
                                ),
                                IconButton(
                                  icon: Icon(Icons.add, color: Colors.green),
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
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: ' ${product.urunParakendeFiyat} TL'),
                          TextSpan(
                            text: '\nMaks: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: '${product.stokDurumu} Adet'),
                        ],
                      ),
                      Expanded(
                        child: richText(
                          fontSize: themeData.bodyMedium.fontSize,
                          textAlign: TextAlign.center,
                          context,
                          maxLines: 6,
                          children: [
                            TextSpan(
                              text: 'Ürün Tutarı',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  '\n${((double.tryParse(item['miktar'].toString()) ?? 0) * (double.tryParse(product.urunParakendeFiyat.toString()) ?? 0)).toStringAsFixed(2)} TL',
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
          Builder(
            builder: (context) {
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
            },
          ),
        ],
      ),
    );
  }
}
