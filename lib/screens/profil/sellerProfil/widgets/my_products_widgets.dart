import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imecehub/core/constants/app_colors.dart';
import 'package:imecehub/core/constants/app_paddings.dart';
import 'package:imecehub/core/widgets/buildLoadingBar.dart';
import 'package:imecehub/core/widgets/buttons/turnBackTextIcon.dart';
import 'package:imecehub/core/widgets/cards/productsCard2.dart';
import 'package:imecehub/core/widgets/text.dart';
import 'package:imecehub/models/products.dart';
import 'package:imecehub/models/sellerProducts.dart';
import 'package:imecehub/models/users.dart';
import 'package:imecehub/providers/products_provider.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';

class MyProductsGrid extends ConsumerWidget {
  final User seller;
  final String title;

  const MyProductsGrid({
    super.key,
    required this.seller,
    this.title = 'Ürünlerim',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProducts = ref.watch(
      sellerProductsProvider(seller.saticiProfili?.kullanici ?? 0),
    );
    final theme = HomeStyle(context: context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width * 0.3,
        leading: const TurnBackTextIcon(),
        centerTitle: true,
        title: customText(
          title,
          context,
          weight: FontWeight.w700,
          size: theme.bodyLarge.fontSize,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppPaddings.h10v10,
          child: asyncProducts.when(
            loading: () => Center(child: buildLoadingBar(context)),
            error: (error, _) => Center(
              child: customText(
                'Ürünler yüklenemedi:\n$error',
                context,
                textAlign: TextAlign.center,
                color: AppColors.error(context),
              ),
            ),
            data: (items) {
              if (items.isEmpty) {
                return Center(
                  child: customText(
                    'Henüz ürün eklenmemiş.',
                    context,
                    color: theme.outline,
                  ),
                );
              }

              final products = items.map(_mapSellerProductToProduct).toList();
              return GridView.builder(
                padding: EdgeInsets.only(top: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return productsCard2(
                    myProducts: true,
                    product: product,
                    width: size.width,
                    context: context,
                    height: size.height,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Product _mapSellerProductToProduct(SellerProducts item) {
    return Product(
      urunId: item.urunId,
      urunAdi: item.urunAdi,
      aciklama: item.aciklama,
      stokDurumu: item.stokDurumu,
      urunParakendeFiyat: item.urunPerakendeFiyati,
      urunMinFiyat: item.urunMinFiyati,
      degerlendirmePuani: item.degerlendirmePuani,
      kapakGorseli: item.kapakGorseli,
      imeceOnayli: item.imeceOnayli,
      urunGorunurluluk: item.urunGorunurluluk,
      satis_turu: item.satisTuru,
      satici: item.satici,
      kategori: item.kategori,
    );
  }
}
