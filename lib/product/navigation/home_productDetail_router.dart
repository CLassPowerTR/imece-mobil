import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imecehub/core/widgets/buttons/textButton.dart';
import 'package:imecehub/core/widgets/buildLoadingBar.dart';
import 'package:imecehub/providers/products_provider.dart';
import 'package:imecehub/screens/products/productsDetail/products_detail_screen.dart';

class HomeProductDetailRouter extends ConsumerWidget {
  const HomeProductDetailRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productId = ModalRoute.of(context)!.settings.arguments as int?;
    if (productId == null) {
      return const Scaffold(
        body: Center(child: Text('Ürün bilgisi bulunamadı.')),
      );
    }

    final productAsync = ref.watch(productProvider(productId));

    return productAsync.when(
      loading: () => Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [buildLoadingBar(context), const SizedBox(height: 16)],
        ),
      ),
      error: (error, _) => Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Error: $error'),
              textButton(
                context,
                'Tekrar Dene',
                onPressed: () {
                  ref.invalidate(productProvider(productId));
                },
              ),
            ],
          ),
        ),
      ),
      data: (product) => ProductsDetailScreen(product: product),
    );
  }
}
