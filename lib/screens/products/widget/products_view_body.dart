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
  String notFoundImageUrl = 'https://www.halifuryasi.com/Upload/null.png';
  // Statik cache değişkeni: Tüm örnekler arasında paylaşılır.

  static List<Product>? cachedProducts;
  late Future<List<Product>> _futureProducts;
  static List<int> sepetUrunIdList = [];
  bool isLoggedIn = false;
  List<int> favoriteProductIds = [];
  Map<int, int> productIdToFavoriteId = {};
  late Future<void> _futureFavorites;

  @override
  void initState() {
    super.initState();
    // Aşağıdaki kodu initState içine ekleyerek, eğer cachedProducts dolu ise
    // API çağrısı yapmadan cache'den verileri kullanıyoruz.
    if (cachedProducts != null && cachedProducts!.isNotEmpty) {
      // Cache dolu ise: direkt veriyi Future.value ile sarıyoruz.
      _futureProducts = Future.value(cachedProducts);
    } else {
      // İlk açılışta veya cache boşsa API'den verileri çek
      _futureProducts = ApiService.fetchProducts(id: widget.categoryId);
      _futureProducts.then((products) {
        // Gelen veriyi cache'e atıyoruz.
        cachedProducts = products;
      });
    }
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
    // API'den verileri çek ve cache'i güncelle
    List<Product> freshProducts = await ApiService.fetchProducts(
      id: widget.categoryId,
    );
    await _fetchFavorites();
    _futureFavorites = _fetchFavorites();

    setState(() {
      cachedProducts = freshProducts;
      _futureProducts = Future.value(freshProducts);
    });
  }

  @override
  bool get wantKeepAlive => true; // Ekran arası geçişte state'in korunmasını sağlar

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeData = HomeStyle(context: context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
                _futureProductsItems(height, width),
              ],
            ),
          ),
        );
      },
    );
  }

  FutureBuilder<List<Product>> _futureProductsItems(
    double height,
    double width,
  ) {
    return FutureBuilder<List<Product>>(
      future: _futureProducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ProductsGridShimmer(itemCount: 4),
              const SizedBox(height: 16),
            ],
          );
        } else if (snapshot.hasError) {
          // Hata durumu
          return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
        } else {
          // Veri başarıyla alındı

          final products = snapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _productCards(height, width, products),
              SizedBox(height: height * 0.12),
            ],
          );
        }
      },
    );
  }

  GridView _productCards(double height, double width, products) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.68,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        int? urunId = products[index].urunId ?? products[index]['urun_id'];
        bool isInSepet = urunId != null && sepetUrunIdList.contains(urunId);
        bool isInFavorites =
            urunId != null && favoriteProductIds.contains(urunId);
        bool favoriteProduct = isInFavorites;
        return productsCard(
          sepeteEkle: () async {
            if (isLoggedIn) {
              if (isInSepet) {
                ref.read(bottomNavIndexProvider.notifier).state = 2;
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (route) => false,
                  arguments: {'refresh': true},
                );
              } else {
                if (products[index].stokDurumu <= 0) {
                  showTemporarySnackBar(
                    context,
                    'Bu ürün stokta bulunmamaktadır',
                    type: SnackBarType.info,
                  );
                } else {
                  try {
                    await ApiService.fetchSepetEkle(
                      1,
                      products[index].urunId ?? 0,
                    );
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
                  final currentUrunId = products[index].urunId;
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
          product: products[index],
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
