import 'package:flutter/material.dart';
import 'package:imecehub/core/constants/app_colors.dart';
import 'package:imecehub/core/constants/app_radius.dart';
import 'package:imecehub/core/widgets/container.dart';
import 'package:imecehub/core/widgets/raitingStars.dart';
import 'package:imecehub/core/widgets/showTemporarySnackBar.dart';
import 'package:imecehub/core/widgets/text.dart';
import 'package:imecehub/models/products.dart';
import 'package:imecehub/providers/auth_provider.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';
import 'package:imecehub/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class productsCard extends ConsumerStatefulWidget {
  final Product product;
  final double width;
  final BuildContext context;
  final double height;
  final bool isSepet;
  final bool isFavorite;
  final VoidCallback? sepeteEkle;
  final VoidCallback? favoriEkle;
  const productsCard(
      {super.key,
      required this.product,
      required this.width,
      required this.context,
      required this.height,
      required this.isSepet,
      required this.sepeteEkle,
      required this.favoriEkle,
      required this.isFavorite});

  @override
  ConsumerState<productsCard> createState() => _productsCardState();
}

class _productsCardState extends ConsumerState<productsCard> {
  String notFoundImageUrl = 'https://www.halifuryasi.com/Upload/null.png';
  bool cokluGorsel = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          Navigator.pushNamed(context, '/products/productsDetail',
              arguments: widget.product);
        });
      },
      child: Card(
        color: HomeStyle(context: context).surfaceContainer,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            spacing: 3,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Builder(builder: (context) {
                if (widget.product.kapakGorseli != '') {
                  return Expanded(
                    child: cokluGorsel == true
                        ? PageView.builder(
                            itemCount: widget.product.kapakGorseli!.length,
                            itemBuilder: (context, imgIndex) {
                              return Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: AssetImage(widget.product
                                                    .kapakGorseli![imgIndex] ==
                                                ''
                                            ? notFoundImageUrl
                                            : widget.product
                                                .kapakGorseli![imgIndex]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  // Görselin alt sağ köşesinde kaçıncı görsel olduğunu gösteren etiket
                                  Positioned(
                                    bottom: 4,
                                    right: 4,
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        color:
                                            HomeStyle(context: context).outline,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        "${imgIndex + 1}/${widget.product.kapakGorseli!.length}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          )
                        : Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        widget.product.kapakGorseli ??
                                            notFoundImageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ), // Görselin alt sağ köşesinde kaçıncı görsel olduğunu gösteren etiket
                              Positioned(
                                bottom: 4,
                                right: 4,
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 25,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    color: HomeStyle(context: context).outline,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "1/1",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  );
                } else {
                  return Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(notFoundImageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }
              }),
              const SizedBox(height: 4),
              // Bilgi bölümünü içerik kadar yer kaplayacak şekilde düzenliyoruz.
              customText(widget.product.urunAdi ?? '', context,
                  weight: FontWeight.bold,
                  size: HomeStyle(context: context).bodyLarge.fontSize),
              buildRatingStars(
                widget.product.degerlendirmePuani ?? 0.0,
              ),
              customText('${widget.product.aciklama}', context,
                  size: 14, maxLines: 2),
              customText("KG: ${widget.product.urunParakendeFiyat} TL", context,
                  size: HomeStyle(context: context).bodyLarge.fontSize,
                  color: HomeStyle(context: context).secondary),
              Row(
                spacing: 5,
                children: [
                  Expanded(
                    flex: 4,
                    child: SizedBox(
                      height: 30,
                      child: Builder(builder: (context) {
                        if (widget.product.stokDurumu! <= 0) {
                          return TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            child: customText('Stokta Yok', context,
                                color: Colors.white,
                                weight: FontWeight.bold,
                                textAlign: TextAlign.center,
                                size: HomeStyle(context: context)
                                    .bodySmall
                                    .fontSize),
                          );
                        } else {
                          return TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: widget.isSepet
                                  ? Colors.orangeAccent[200]
                                  : HomeStyle(context: context).secondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: widget.product.stokDurumu! >= 0
                                ? widget.sepeteEkle
                                : null,
                            child: customText(
                                widget.isSepet ? 'Sepete Git' : 'Sepete Ekle',
                                context,
                                color: Colors.white,
                                weight: FontWeight.bold,
                                size: HomeStyle(context: context)
                                    .bodySmall
                                    .fontSize),
                          );
                        }
                      }),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: widget.favoriEkle,
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.grey[200],
                        ),
                        child: Icon(
                          widget.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.isFavorite ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

GridView productCards({
  required double height,
  required double width,
  required List<Product> products,
  required bool Function(Product) isInSepet,
  required bool Function(Product) isFavorite,
  required VoidCallback Function(Product) onSepeteEkle,
  required VoidCallback Function(Product) onFavoriEkle,
  required BuildContext context,
}) {
  return GridView.builder(
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      mainAxisExtent: height * 0.4,
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
    ),
    itemCount: products.length,
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemBuilder: (context, index) {
      final product = products[index];
      return productsCard(
        sepeteEkle: onSepeteEkle(product),
        favoriEkle: onFavoriEkle(product),
        isSepet: isInSepet(product),
        isFavorite: isFavorite(product),
        product: product,
        width: width,
        context: context,
        height: height,
      );
    },
  );
}
