part of '../buyer_profil_screen.dart';

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  bool isLoggedIn = false;
  List<int> sepetUrunIdList = [];
  List<int> favoriteProductIds = [];
  Map<int, int> productIdToFavoriteId = {};

  @override
  void initState() {
    super.initState();
    _checkLogin();
    _checkGetSepet();
    _fetchFavorites();
  }

  Future<void> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accesToken') ?? '';
    setState(() {
      isLoggedIn = token.isNotEmpty;
    });
  }

  Future<void> _checkGetSepet() async {
    final sepet = await ApiService.fetchSepetGet();
    if (sepet['durum'] == 'SEPET_DOLU' && sepet['sepet'] is List) {
      setState(() {
        sepetUrunIdList = (sepet['sepet'] as List)
            .map<int>((item) => item['urun'] as int)
            .toList();
      });
    } else {
      setState(() {
        sepetUrunIdList = [];
      });
    }
  }

  Future<void> _fetchFavorites() async {
    try {
      final favorites =
          await ApiService.fetchUserFavorites(null, null, null, null);
      setState(() {
        favoriteProductIds =
            favorites.map<int>((item) => item['urun'] as int).toList();
        productIdToFavoriteId = {
          for (var item in favorites) item['urun'] as int: item['id'] as int
        };
      });
    } catch (e) {
      setState(() {
        favoriteProductIds = [];
        productIdToFavoriteId = {};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 4,
          shadowColor: Colors.grey[300],
          leadingWidth: MediaQuery.of(context).size.width * 0.3,
          title: customText('Favorilerim', context,
              size: HomeStyle(context: context).bodyLarge.fontSize,
              weight: FontWeight.w600),
          leading: TurnBackTextIcon(),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FutureBuilder(
                future: Future.wait([
                  ApiService.fetchUserFavorites(null, null, null, null),
                  ApiService.fetchProducts(),
                ]),
                builder: (context, snapshot) {
                  // Son gösterilen ürünleri saklamak için bir değişken
                  List<Product> lastProducts = [];
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Eğer daha önce veri geldiyse, onları göster
                    if (snapshot.hasData) {
                      final favList = snapshot.data![0];
                      final allProducts = snapshot.data![1] as List<Product>;
                      final favoriteIds = favList
                          .map<int>((item) => item['urun'] as int)
                          .toList();
                      lastProducts = allProducts
                          .where((p) => favoriteIds.contains(p.urunId))
                          .toList();
                    }
                    double height = MediaQuery.of(context).size.height;
                    double width = MediaQuery.of(context).size.width;
                    return Stack(
                      children: [
                        // En altta eski veri veya boş bir Container
                        lastProducts.isNotEmpty
                            ? productCards(
                                height: height,
                                width: width,
                                products: lastProducts,
                                context: context,
                                isInSepet: (product) =>
                                    sepetUrunIdList.contains(product.urunId),
                                isFavorite: (product) =>
                                    favoriteProductIds.contains(product.urunId),
                                onSepeteEkle: (product) => () async {
                                  await handleSepetAction(
                                    context: context,
                                    isLoggedIn: isLoggedIn,
                                    isInSepet: sepetUrunIdList
                                        .contains(product.urunId),
                                    urunId: product.urunId,
                                    onSuccess: () async {
                                      await _checkGetSepet();
                                      setState(() {});
                                    },
                                    onFail: () {},
                                    onNavigateToCart: () {
                                      ref
                                          .read(bottomNavIndexProvider.notifier)
                                          .state = 2;
                                      Navigator.pushNamedAndRemoveUntil(
                                          context, '/home', (route) => false,
                                          arguments: {'refresh': true});
                                    },
                                  );
                                },
                                onFavoriEkle: (product) => () async {
                                  await handleFavoriteAction(
                                    context: context,
                                    ref: ref,
                                    isLoggedIn: isLoggedIn,
                                    isFavorite: favoriteProductIds
                                        .contains(product.urunId),
                                    urunId: product.urunId,
                                    productIdToFavoriteId:
                                        productIdToFavoriteId,
                                    onSuccess: () async {
                                      await _fetchFavorites();
                                      setState(() {});
                                    },
                                    onFail: () {},
                                  );
                                },
                              )
                            : Container(),
                        // Karartma ve loading
                        Container(
                          color: Colors.black.withOpacity(0.3),
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        Center(child: buildLoadingBar(context)),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Hata: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final favList = snapshot.data![0];
                    final allProducts = snapshot.data![1] as List<Product>;
                    final favoriteIds = favList
                        .map<int>((item) => item['urun'] as int)
                        .toList();
                    final products = allProducts
                        .where((p) => favoriteIds.contains(p.urunId))
                        .toList();

                    if (products.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.2),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              textButton(
                                context,
                                '+ Favori ekle',
                                elevation: 0,
                                shadowColor:
                                    HomeStyle(context: context).secondary,
                                fontSize: HomeStyle(context: context)
                                    .bodyLarge
                                    .fontSize,
                                weight: FontWeight.bold,
                                onPressed: () {
                                  ref
                                      .read(bottomNavIndexProvider.notifier)
                                      .state = 1;
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/home',
                                    (route) => false,
                                    arguments: {'refresh': true},
                                  );
                                },
                              ),
                            ]),
                      );
                    }
                    double height = MediaQuery.of(context).size.height;
                    double width = MediaQuery.of(context).size.width;
                    int? urunId = products[0].urunId;
                    bool isInSepet =
                        urunId != null && sepetUrunIdList.contains(urunId);
                    bool isInFavorites =
                        urunId != null && favoriteProductIds.contains(urunId);
                    bool favoriteProduct = isInFavorites;
                    return productCards(
                      height: height,
                      width: width,
                      products: products,
                      context: context,
                      isInSepet: (product) =>
                          sepetUrunIdList.contains(product.urunId),
                      isFavorite: (product) =>
                          favoriteProductIds.contains(product.urunId),
                      onSepeteEkle: (product) => () async {
                        await handleSepetAction(
                          context: context,
                          isLoggedIn: isLoggedIn,
                          isInSepet: sepetUrunIdList.contains(product.urunId),
                          urunId: product.urunId,
                          onSuccess: () async {
                            await _checkGetSepet();
                            setState(() {});
                          },
                          onFail: () {},
                          onNavigateToCart: () {
                            ref.read(bottomNavIndexProvider.notifier).state = 2;
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/home', (route) => false,
                                arguments: {'refresh': true});
                          },
                        );
                      },
                      onFavoriEkle: (product) => () async {
                        await handleFavoriteAction(
                          context: context,
                          ref: ref,
                          isLoggedIn: isLoggedIn,
                          isFavorite:
                              favoriteProductIds.contains(product.urunId),
                          urunId: product.urunId,
                          productIdToFavoriteId: productIdToFavoriteId,
                          onSuccess: () async {
                            await _fetchFavorites();
                            setState(() {});
                          },
                          onFail: () {},
                        );
                      },
                    );
                  } else {
                    return Center(child: Text('Veri bulunamadı.'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
