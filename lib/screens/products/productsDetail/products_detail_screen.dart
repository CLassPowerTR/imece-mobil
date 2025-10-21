import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imecehub/core/constants/app_colors.dart';
import 'package:imecehub/core/constants/app_radius.dart';
import 'package:imecehub/core/widgets/buildLoadingBar.dart';
import 'package:imecehub/core/widgets/container.dart';
import 'package:imecehub/core/widgets/buttons/iconButtons.dart';
import 'package:imecehub/core/widgets/richText.dart';
import 'package:imecehub/core/widgets/showTemporarySnackBar.dart';
import 'package:imecehub/core/widgets/soruCevapContainer.dart';
import 'package:imecehub/core/widgets/text.dart';
import 'package:imecehub/core/widgets/buttons/textButton.dart';
import 'package:imecehub/core/widgets/textField.dart';
import 'package:imecehub/core/widgets/yorumContainer.dart';
import 'package:imecehub/models/products.dart';
import 'package:imecehub/models/users.dart';
import 'package:imecehub/providers/auth_provider.dart';
import 'package:imecehub/screens/home/home_screen.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';
import 'package:imecehub/services/api_service.dart';
import 'package:imecehub/models/urunYorum.dart';
import 'package:imecehub/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/variables/mainCategoryNames.dart';

part 'widget/products_detail_view_header.dart';
part 'widget/products_detail_view_body.dart';
part 'widget/products_detail_view_bottom.dart';

class ProductsDetailScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductsDetailScreen({super.key, required this.product});

  @override
  ConsumerState<ProductsDetailScreen> createState() =>
      _ProductsDetailScreenState();
}

class _ProductsDetailScreenState extends ConsumerState<ProductsDetailScreen> {
  bool isLoggedIn = false;
  static List<int> sepetUrunIdList = [];

  @override
  void initState() {
    super.initState();
    _checkLogin();
    _checkGetSepet();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkGetSepet().then((_) {
      setState(() {});
    });
  }

  Future<bool> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accesToken') ?? '';
    setState(() {
      this.isLoggedIn = token.isNotEmpty;
    });
    return isLoggedIn;
  }

  Future<void> _checkGetSepet() async {
    final sepet = await ApiService.fetchSepetGet();
    // Sepet doluysa ürün id'lerini static listeye ata
    if (sepet['durum'] == 'SEPET_DOLU' && sepet['sepet'] is List) {
      sepetUrunIdList = (sepet['sepet'] as List)
          .map<int>((item) => item['urun'] as int)
          .toList();
    } else {
      sepetUrunIdList = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: true,
      left: true,
      right: true,
      child: Scaffold(
        appBar: _productsDetailAppBar(context),
        body: ProductsDetailViewBody(
            product: widget.product, isLoggedIn: isLoggedIn),
        bottomNavigationBar: ProductsDetailViewBottom(
            sepeteEkle: () async {
              if (sepetUrunIdList.contains(widget.product.urunId)) {
                ref.read(bottomNavIndexProvider.notifier).state = 2;
                Navigator.pushNamedAndRemoveUntil(
                    context, '/home', (route) => false,
                    arguments: {'refresh': true});
              } else {
                if (isLoggedIn) {
                  if (widget.product.stokDurumu! <= 0) {
                    showTemporarySnackBar(
                        context, 'Bu ürün stokta bulunmamaktadır',
                        type: SnackBarType.info);
                  } else {
                    try {
                      await ApiService.fetchSepetEkle(
                          1, widget.product.urunId ?? 0);
                      showTemporarySnackBar(context, 'Sepete eklendi');
                    } catch (e) {
                      showTemporarySnackBar(
                          context, 'Sepete eklenirken bir hata oluştu: $e');
                    } finally {
                      setState(() async {
                        await _checkGetSepet();
                        await _checkLogin();
                      });
                    }
                  }
                } else {
                  showTemporarySnackBar(context, 'Lütfen giriş yapınız!');
                }
              }
            },
            product: widget.product,
            isLoggedIn: isLoggedIn,
            sepetUrunIdList: sepetUrunIdList),
      ),
    );
  }
}
