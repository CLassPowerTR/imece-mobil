import 'package:flutter/material.dart';
import 'package:imecehub/core/widgets/buttons/textButton.dart';
import 'package:imecehub/core/widgets/buildLoadingBar.dart';
import 'package:imecehub/models/products.dart';
import 'package:imecehub/screens/products/productsDetail/products_detail_screen.dart';

class HomeProductDetailRouter extends StatefulWidget {
  const HomeProductDetailRouter({super.key});

  @override
  State<HomeProductDetailRouter> createState() => _HomeProductDetailRouter();
}

class _HomeProductDetailRouter extends State<HomeProductDetailRouter> {
  @override
  Widget build(BuildContext context) {
    final Future<Product> futureProduct =
        ModalRoute.of(context)!.settings.arguments as Future<Product>;

    return FutureBuilder<Product>(
      future: futureProduct,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildLoadingBar(context),
                SizedBox(height: 16),
              ],
            ),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                  child: Column(
                children: [
                  Text('Error: ${snapshot.error}'),
                  textButton(
                    context,
                    'Tekrar Dene',
                    onPressed: () {
                      setState(() {});
                    },
                  )
                ],
              )));
        }
        return ProductsDetailScreen(product: snapshot.data!);
      },
    );
  }
}
