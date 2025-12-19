import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imecehub/core/constants/app_colors.dart';
import 'package:imecehub/core/constants/app_radius.dart';
import 'package:imecehub/core/variables/url.dart';
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
import 'package:imecehub/providers/products_provider.dart';
import 'package:imecehub/screens/home/home_screen.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';
import 'package:imecehub/services/api_service.dart';
import 'package:imecehub/models/urunYorum.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/variables/mainCategoryNames.dart';

part 'widget/products_detail_view_header.dart';
part 'widget/products_detail_view_body.dart';
part 'widget/products_detail_view_bottom.dart';

class ProductsDetailScreen extends ConsumerStatefulWidget {
  final int productId;

  const ProductsDetailScreen({super.key, required this.productId});

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
    // Logout sonrası statik sepet listesi temizlenmezse "sepette" görünümü devam edebilir.
    ref.listen<User?>(userProvider, (previous, next) async {
      if (!mounted) return;

      if (next == null) {
        // Logout oldu - sepet state'ini temizle
        setState(() {
          isLoggedIn = false;
          sepetUrunIdList = [];
        });
        return;
      }

      // Login olduysa sepeti yeniden yükle
      await _checkLogin();
      await _checkGetSepet();
      if (mounted) setState(() {});
    });
    
    final productAsync = ref.watch(productProvider(widget.productId));

    return productAsync.when(
      loading: () => SafeArea(
        bottom: true,
        top: true,
        left: true,
        right: true,
        child: Scaffold(
          appBar: _productsDetailAppBar(context),
          body: Center(child: buildLoadingBar(context)),
        ),
      ),
      error: (error, stackTrace) => SafeArea(
        bottom: true,
        top: true,
        left: true,
        right: true,
        child: Scaffold(
          appBar: _productsDetailAppBar(context),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Ürün yüklenemedi: $error'),
                const SizedBox(height: 16),
                textButton(
                  context,
                  'Tekrar Dene',
                  onPressed: () {
                    ref.invalidate(productProvider(widget.productId));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      data: (product) => SafeArea(
        bottom: true,
        top: true,
        left: true,
        right: true,
        child: Scaffold(
          appBar: _productsDetailAppBar(context),
          body: ProductsDetailViewBody(productId: widget.productId),
          bottomNavigationBar: ProductsDetailViewBottom(
            sepeteEkle: () async {
              if (sepetUrunIdList.contains(product.urunId)) {
                ref.read(bottomNavIndexProvider.notifier).setIndex(2);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (route) => false,
                  arguments: {'refresh': true},
                );
              } else {
                if (isLoggedIn) {
                  if (product.stokDurumu! <= 0) {
                    showTemporarySnackBar(
                      context,
                      'Bu ürün stokta bulunmamaktadır',
                      type: SnackBarType.info,
                    );
                  } else {
                    try {
                      await ApiService.fetchSepetEkle(1, product.urunId ?? 0);
                      showTemporarySnackBar(context, 'Sepete eklendi');
                    } catch (e) {
                      showTemporarySnackBar(
                        context,
                        'Sepete eklenirken bir hata oluştu: $e',
                      );
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
            productId: widget.productId,
            sepetUrunIdList: sepetUrunIdList,
          ),
        ),
      ),
    );
  }
}
