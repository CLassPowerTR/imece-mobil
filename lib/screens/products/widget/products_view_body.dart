part of '../products_screen.dart';

class ProductsScreenBodyView extends ConsumerStatefulWidget {
  final String? categoryId;

  const ProductsScreenBodyView({super.key, this.categoryId});

  @override
  ConsumerState<ProductsScreenBodyView> createState() =>
      _ProductsScreenBodyView();
}

class _ProductsScreenBodyView extends ConsumerState<ProductsScreenBodyView>
    with AutomaticKeepAliveClientMixin, RouteAware {
  List<dynamic> productCategories = [
    {'name': 'Sırala', 'icon': Icon(Icons.compare_arrows_outlined)},
    {'name': 'Filtrele', 'icon': Icon(Icons.filter_alt_outlined)},
    {'name': 'Satıcı', 'icon': Icon(Icons.home_filled)},
    {'name': 'Fiyat', 'icon': Icon(Icons.price_change_outlined)},
  ];
  static List<int> sepetUrunIdList = [];
  bool isLoggedIn = false;
  List<int> favoriteProductIds = [];
  Map<int, int> productIdToFavoriteId = {};
  late Future<void> _futureFavorites;

  @override
  void initState() {
    super.initState();
    _checkLogin().then((loggedIn) async {
      if (loggedIn) {
        await ref.read(userProvider.notifier).fetchUserMe();
      }
    });
    _checkGetSepet();
    _futureFavorites = _fetchFavorites();
  }

  // didChangeDependencies already exists below; keep one implementation only

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() async {
    // Başka ekrandan geri gelindi
    await _refreshProducts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
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

  Future<void> _fetchFavorites() async {
    try {
      final favorites = await ApiService.fetchUserFavorites(
        null,
        null,
        null,
        null,
      );
      favoriteProductIds = favorites
          .map<int>((item) => item['urun'] as int)
          .toList();
      productIdToFavoriteId = {
        for (var item in favorites) item['urun'] as int: item['id'] as int,
      };
    } catch (e) {
      favoriteProductIds = [];
      productIdToFavoriteId = {};
    }
  }

  // Refresh işlemini gerçekleştiren metod:
  Future<void> _refreshProducts() async {
    // Repository cache'ini temizle
    final repository = ref.read(productsRepositoryProvider);
    repository.invalidateProducts(categoryId: widget.categoryId);

    // Provider'ı invalidate et ve yeniden yükle
    ref.invalidate(productsProvider(widget.categoryId));
    try {
      await ref.read(productsProvider(widget.categoryId).future);
    } catch (e) {
      debugPrint('Products provider yenilenirken hata: $e');
    }

    // Favorileri yenile
    final favoritesFuture = _fetchFavorites();
    setState(() {
      _futureFavorites = favoritesFuture;
    });
    await favoritesFuture;
  }

  @override
  bool get wantKeepAlive => true; // Ekran arası geçişte state'in korunmasını sağlar

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    // Logout/login olduğunda sepet/favori state'lerini sıfırla veya yeniden yükle.
    // Problem: sepetUrunIdList statik olduğu için logout sonrası "hala sepette" görünebiliyordu.
    ref.listen(userProvider, (previous, next) async {
      if (!mounted) return;

      if (next == null) {
        // Logout oldu - tüm sepet/favori state'lerini temizle
        setState(() {
          isLoggedIn = false;
          sepetUrunIdList = [];
          favoriteProductIds = [];
          productIdToFavoriteId = {};
          _futureFavorites = Future.value();
        });
        return;
      }

      // Login olduysa sepet & favorileri yenile
      await _checkLogin();
      await _checkGetSepet();
      final favoritesFuture = _fetchFavorites();
      setState(() {
        _futureFavorites = favoritesFuture;
      });
      await favoritesFuture;
    });
    
    final themeData = HomeStyle(context: context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final productsAsync = ref.watch(productsProvider(widget.categoryId));
    return FutureBuilder<void>(
      future: _futureFavorites,
      builder: (context, snapshot) {
        return RefreshIndicator(
          color: themeData.secondary,
          backgroundColor: Colors.white,
          onRefresh: _refreshProducts,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Builder(
                  builder: (context) {
                    if (widget.categoryId == null) {
                      return _categoryButtons(context, height);
                    } else {
                      return SizedBox();
                    }
                  },
                ),
                _productsSection(productsAsync, height, width),
                SizedBox(height: height * 0.1),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _productsSection(
    AsyncValue<List<Product>> productsAsync,
    double height,
    double width,
  ) {
    return productsAsync.when(
      loading: () => Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          ProductsGridShimmer(itemCount: 4),
          SizedBox(height: 16),
        ],
      ),
      error: (error, _) => Center(child: Text('Bir hata oluştu: $error')),
      data: (products) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _productCards(height, width, products),
          SizedBox(height: height * 0.12),
        ],
      ),
    );
  }

  GridView _productCards(double height, double width, List<Product> products) {
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
        final urunId = product.urunId;
        final bool isInSepet =
            urunId != null && sepetUrunIdList.contains(urunId);
        final bool favoriteProduct =
            urunId != null && favoriteProductIds.contains(urunId);
        return productsCard(
          productId: product.urunId ?? 0,
          sepeteEkle: () async {
            if (isLoggedIn) {
              if (isInSepet) {
                ref.read(bottomNavIndexProvider.notifier).setIndex(2);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (route) => false,
                  arguments: {'refresh': true},
                );
              } else {
                if ((product.stokDurumu ?? 0) <= 0) {
                  showTemporarySnackBar(
                    context,
                    'Bu ürün stokta bulunmamaktadır',
                    type: SnackBarType.info,
                  );
                } else {
                  try {
                    await ApiService.fetchSepetEkle(1, product.urunId ?? 0);
                    showTemporarySnackBar(
                      context,
                      'Sepete eklendi',
                      type: SnackBarType.success,
                    );
                  } catch (e) {
                    showTemporarySnackBar(
                      context,
                      'Sepete eklenirken bir hata oluştu: $e',
                      type: SnackBarType.error,
                    );
                  } finally {
                    await _checkGetSepet();
                    setState(() {});
                  }
                }
              }
            } else {
              showTemporarySnackBar(
                context,
                'Lütfen giriş yapınız',
                type: SnackBarType.info,
              );
            }
          },
          favoriEkle: () {
            setState(() async {
              if (isLoggedIn) {
                var user = ref.read(userProvider);
                if (user == null) {
                  // Kullanıcı state'i henüz yüklenmemiş olabilir; yüklemeyi dene
                  await ref.read(userProvider.notifier).fetchUserMe();
                  user = ref.read(userProvider);
                }
                if (user == null) {
                  showTemporarySnackBar(
                    context,
                    'Lütfen giriş yapınız',
                    type: SnackBarType.info,
                  );
                  return;
                }
                if (favoriteProduct) {
                  // Favoriden çıkar
                  final favoriteProductId = productIdToFavoriteId[urunId];

                  if (favoriteProductId != null) {
                    try {
                      await ApiService.fetchUserFavorites(
                        null,
                        null,
                        null,
                        favoriteProductId,
                      );
                      showTemporarySnackBar(
                        context,
                        'Favoriden çıkarıldı',
                        type: SnackBarType.success,
                      );
                    } catch (e) {
                      showTemporarySnackBar(
                        context,
                        'Hata: $e',
                        type: SnackBarType.error,
                      );
                    } finally {
                      await _fetchFavorites();
                      setState(() {});
                    }
                  }
                } else {
                  // Favoriye ekle
                  final currentUrunId = product.urunId;
                  if (currentUrunId == null) {
                    showTemporarySnackBar(
                      context,
                      'Ürün bilgisi eksik (urunId boş)',
                    );
                    return;
                  }
                  try {
                    await ApiService.fetchUserFavorites(
                      null,
                      user.id,
                      currentUrunId,
                      null,
                    );
                    showTemporarySnackBar(
                      context,
                      'Favoriye eklendi',
                      type: SnackBarType.success,
                    );
                  } catch (e) {
                    showTemporarySnackBar(
                      context,
                      'Hata: $e',
                      type: SnackBarType.error,
                    );
                  } finally {
                    await _fetchFavorites();
                    setState(() {});
                  }
                }
                setState(() async {
                  await _fetchFavorites();
                  setState(() {});
                });
              } else {
                showTemporarySnackBar(
                  context,
                  'Lütfen giriş yapınız',
                  type: SnackBarType.info,
                );
              }
            });
          },
          isSepet: isInSepet,
          isFavorite: favoriteProduct,
          width: width,
          context: context,
          height: height,
        );
      },
    );
  }

  Container _categoryButtons(BuildContext context, double height) {
    return Container(
      alignment: Alignment.topCenter,
      transformAlignment: Alignment.topCenter,
      decoration: BoxDecoration(
        color: HomeStyle(context: context).surface,
        boxShadow: [boxShadow(context)],
      ),
      height: height * 0.07,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        itemCount: productCategories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final items = productCategories[index];
          return Padding(
            padding: const EdgeInsets.only(
              left: 16,
            ), // Butonlar arasında yatay boşluk
            child: ProductsCategoryButtons(index: index, items: items),
          );
        },
      ),
    );
  }
}
