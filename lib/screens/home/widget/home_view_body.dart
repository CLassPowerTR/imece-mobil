part of '../home_screen.dart';

class _HomeViewBody extends ConsumerStatefulWidget {
  const _HomeViewBody();

  @override
  ConsumerState<_HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends ConsumerState<_HomeViewBody> {
  static List<Category>? cachedCategories;
  static List<Company>? cachedSellers;
  late Future<List<Category>> _futureCategory;
  late Future<List<Company>> _futureSellers;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _voidCachedCategories();
    _voidCachedSellers();
    _checkLogin();
  }

  Future<bool> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accesToken') ?? '';
    setState(() {
      this.isLoggedIn = token.isNotEmpty;
    });
    return isLoggedIn;
  }

  // Refresh işlemini gerçekleştiren metod:
  Future<void> _refreshFutures() async {
    // API'den verileri çek ve cache'i güncelle
    List<Category> freshCategory = await ApiService.fetchCategories();
    setState(() {
      cachedCategories = freshCategory;
      _futureCategory = Future.value(freshCategory);
    });
    List<Company> freshSellers = await ApiService.fetchSellers();
    setState(() {
      cachedSellers = freshSellers;
      _futureSellers = Future.value(freshSellers);
    });

    // Products repository'deki cache'leri temizle
    try {
      final repository = ref.read(productsRepositoryProvider);
      repository.invalidatePopulerProducts();
      repository.invalidateCampaigns();
      debugPrint('Home: Popüler ürünler ve kampanyalar cache temizlendi');
    } catch (e) {
      debugPrint('Home: Cache temizlenirken hata: $e');
    }

    // Popüler ürünler ve kampanyalar provider'larını invalidate et
    ref.invalidate(populerProductsProvider);
    ref.invalidate(campaignsProvider);

    // Provider'ların yeniden yüklenmesini bekle (cache temizlendikten sonra)
    try {
      await Future.wait([
        ref.read(populerProductsProvider.future),
        ref.read(campaignsProvider.future),
      ]);
      debugPrint('Home: Provider\'lar başarıyla yenilendi');
    } catch (e) {
      debugPrint('Home: Provider yenilenirken hata: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final themeData = HomeStyle(context: context);
    final isOnline = ref.watch(isOnlineProvider);
    
    return Scaffold(
      appBar: HomeHeaderAppBar(),
      body: Column(
        children: [
          // Offline Banner
          if (!isOnline)
            OfflineBanner(
              onRetry: () {
                _refreshFutures();
              },
            ),
          Expanded(
            child: RefreshIndicator(
        color: themeData.secondary,
        backgroundColor: Colors.white,
        onRefresh: _refreshFutures,
        child: SafeArea(
          child: Padding(
            padding: HomeStyle(context: context).bodyPadding,
            child: SingleChildScrollView(
              child: Column(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _futureCategories(width, height),
                  CampaignsItemsCard(width: width, height: height),
                  //_saticilarList(height, context, width),
                  //SizedBox(height: 16),
                  StoryCampaingsCard(height: height, width: width),
                  _futureSellersView(height, width, themeData),
                  _alimTipiContainer(height, context),
                  //_populerUrunCards(width, height),
                  _futurePopulerProductsView(width, height),
                  _onerilerContainer(height, context, width),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.14),
                ],
              ),
            ),
          ),
        ),
      ),
          ),
        ],
      ),
    );
  }

  Column _futurePopulerProductsView(double width, double height) {
    final populerProductsAsync = ref.watch(populerProductsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _populerUrunlerText(context),
        populerProductsAsync.when(
          loading: () => ProductsGridShimmer(itemCount: 2),
          error: (error, _) => Text("Hata oluştu: $error"),
          data: (populerProducts) =>
              _populerUrunCards(width, height, populerProducts),
        ),
      ],
    );
  }

  Widget _futureSellersView(double height, double width, themeData) {
    return FutureBuilder<List<Company>>(
      future: _futureSellers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(height: height * 0.14, child: SellersShimmer());
        } else if (snapshot.hasError) {
          return SizedBox(
            height: height * 0.14,
            child: container(
              context,
              color: themeData.surfaceContainer,
              borderRadius: BorderRadius.circular(8),
              isBoxShadow: true,
              margin: EdgeInsets.only(bottom: 15),
              padding: EdgeInsets.all(8),
              child: customText(
                "Hata oluştu: ${snapshot.error}",
                context,
                color: themeData.secondary,
              ),
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          double saticiContainerWidth = width * 0.2;
          double avatarContainerHeight = 87;
          List<Company> sellers = snapshot.data!;

          return SizedBox(
            height: height * 0.14,
            child: _sellerList(
              sellers,
              avatarContainerHeight,
              saticiContainerWidth,
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  ListView _sellerList(
    List<Company> sellers,
    double avatarContainerHeight,
    double saticiContainerWidth,
  ) {
    return ListView.builder(
      itemCount: sellers.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        double containerHeight = sellers[index].adi.length < 12
            ? avatarContainerHeight * 0.5
            : avatarContainerHeight * 0.3;
        return GestureDetector(
          onTap: () {
            setState(() {
              showTemporarySnackBar(context, 'onPressed ${sellers[index].adi}');
            });
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            width: saticiContainerWidth,
            height: containerHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: HomeStyle(context: context).secondary,
                  child: SvgPicture.network(
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.person_outline_sharp);
                    },
                    sellers[index].logo,
                    fit: BoxFit.cover,
                  ),
                ),
                customText(
                  '${sellers[index].adi}',
                  context,
                  maxLines: 2,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Column _futureCategories(double width, double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        //_categoriesText(context),
        SizedBox(
          height: 130,
          child: FutureBuilder<List<Category>>(
            future: _futureCategory,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CategoriesShimmer(
                  padding: HomeStyle(context: context).bodyPadding,
                  crossAxisCount: 4,
                  childAspectRatio: 1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  itemCount: 4,
                );
              } else if (snapshot.hasError) {
                return Text("Hata oluştu: ${snapshot.error}");
              } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                return SizedBox.shrink();
              } else if (snapshot.hasData) {
                List<Category> categories = snapshot.data!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _categoriesText(context),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          //final category = categories[index];

                          return Padding(
                            padding: EdgeInsets.only(
                              right: index == categories.length - 1 ? 0 : 8,
                            ),
                            child: _categories(
                              categories[index],
                              width,
                              height,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return Text("Veri bulunamadı");
              }
            },
          ),
        ),
      ],
    );
  }

  Row _onerilerContainer(double height, BuildContext context, double width) {
    return Row(
      spacing: 15,
      children: [
        Expanded(
          flex: 1,
          child: _imageContainer(
            height,
            context,
            width,
            'İndirimli',
            ' Ürünleri İncele',
          ),
        ),
        Expanded(
          flex: 1,
          child: _imageContainer(
            height,
            context,
            width,
            'Bizim',
            'seçtiklerimiz',
          ),
        ),
      ],
    );
  }

  Container _imageContainer(
    double height,
    BuildContext context,
    double width,
    String title,
    String title2,
  ) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      height: height * 0.15,
      decoration: BoxDecoration(
        boxShadow: [boxShadow(context)],
        borderRadius: HomeStyle(
          context: context,
        ).bodyCategoryContainerBorderRadius,
        image: const DecorationImage(
          image: AssetImage('assets/image/grupalim.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        spacing: height * 0.15 * 0.1,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          RichText(
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: TextStyle(
                fontSize: HomeStyle(context: context).bodyLarge.fontSize,
                fontWeight: FontWeight.bold,
                color: HomeStyle(context: context).secondary,
              ),
              children: [
                TextSpan(
                  text: title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: HomeStyle(
                      context: context,
                    ).headlineSmall.fontSize,
                    color: HomeStyle(
                      context: context,
                    ).secondary, // "Alıcı" kelimesinin istediğiniz rengi
                  ),
                ),
                TextSpan(
                  text: title2,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: HomeStyle(
                      context: context,
                    ).headlineSmall.fontSize,
                    color: HomeStyle(
                      context: context,
                    ).surface, // "Alıcı" kelimesinin istediğiniz rengi
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: customText(
              'Tıkla...',
              context,
              size: HomeStyle(context: context).bodyLarge.fontSize,
              weight: FontWeight.bold,
              color: HomeStyle(context: context).secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _populerUrunCards(double width, double height, populerProducts) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisExtent: height * 0.4,
        crossAxisCount: 2, // İki sütun
        crossAxisSpacing: 10, // Sütunlar arası yatay boşluk
        mainAxisSpacing: 10, // Satırlar arası dikey boşluk
      ),
      itemCount: populerProducts.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final product = populerProducts[index];
        return productsCard2(
          product: product,
          width: width,
          context: context,
          height: height,
        );
      },
    );
  }

  Padding _populerUrunlerText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: customText(
        'Popüler ürünler',
        context,
        size: HomeStyle(context: context).bodyLarge.fontSize,
        weight: FontWeight.bold,
        color: HomeStyle(context: context).primary,
      ),
    );
  }

  Row _alimTipiContainer(double height, BuildContext context) {
    return Row(
      spacing: 25,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            height: height * 0.15,
            decoration: BoxDecoration(
              boxShadow: [boxShadow(context)],
              borderRadius: HomeStyle(
                context: context,
              ).bodyCategoryContainerBorderRadius,
              image: const DecorationImage(
                image: AssetImage('assets/image/saticiOl.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RichText(
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: HomeStyle(context: context).bodyLarge.fontSize,
                      fontWeight: FontWeight.bold,
                      color: HomeStyle(context: context).secondary,
                    ),
                    children: [
                      TextSpan(
                        text: 'Grup alım için',
                        style: TextStyle(
                          color: HomeStyle(
                            context: context,
                          ).surface, // "Alıcı" kelimesinin istediğiniz rengi
                        ),
                      ),
                      TextSpan(
                        text: ' tıkla',
                        style: TextStyle(
                          color: HomeStyle(context: context).secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            height: height * 0.15,
            decoration: BoxDecoration(
              boxShadow: [boxShadow(context)],
              borderRadius: HomeStyle(
                context: context,
              ).bodyCategoryContainerBorderRadius,
              image: const DecorationImage(
                image: AssetImage('assets/image/saticiOl.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RichText(
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: HomeStyle(context: context).bodyLarge.fontSize,
                      fontWeight: FontWeight.bold,
                      color: HomeStyle(context: context).secondary,
                    ),
                    children: [
                      TextSpan(
                        text: 'Tekil alım için',
                        style: TextStyle(
                          color: HomeStyle(
                            context: context,
                          ).surface, // "Alıcı" kelimesinin istediğiniz rengi
                        ),
                      ),
                      TextSpan(
                        text: ' tıkla',
                        style: TextStyle(
                          color: HomeStyle(context: context).secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Padding _categoriesText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: customText(
        'Kategoriler',
        context,
        maxLines: 1,
        size: HomeStyle(context: context).bodyLarge.fontSize,
        weight: FontWeight.bold,
        color: HomeStyle(context: context).primary,
      ),
    );
  }

  Container _kayitContainer(BuildContext context, double height) {
    return Container(
      height: height * 0.2,
      margin: EdgeInsets.only(top: 25, bottom: 25),
      child: Row(
        spacing: 25,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [boxShadow(context)],
                borderRadius: HomeStyle(
                  context: context,
                ).bodyCategoryContainerBorderRadius,
                image: const DecorationImage(
                  image: AssetImage('assets/image/saticiOl.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RichText(
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: HomeStyle(
                          context: context,
                        ).headlineSmall.fontSize,
                        fontWeight: FontWeight.bold,
                        color: HomeStyle(context: context).secondary,
                      ),
                      children: [
                        TextSpan(
                          text: 'Satıcı',
                          style: TextStyle(
                            color: HomeStyle(
                              context: context,
                            ).secondary, // "Alıcı" kelimesinin istediğiniz rengi
                          ),
                        ),
                        TextSpan(
                          text: ' olarak kayıt ol',
                          style: TextStyle(
                            color: HomeStyle(context: context).surface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [boxShadow(context)],
                borderRadius: HomeStyle(
                  context: context,
                ).bodyCategoryContainerBorderRadius,
                image: const DecorationImage(
                  image: AssetImage('assets/image/aliciOl.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RichText(
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: HomeStyle(
                          context: context,
                        ).headlineSmall.fontSize,
                        fontWeight: FontWeight.bold,
                        color: HomeStyle(context: context).secondary,
                      ),
                      children: [
                        TextSpan(
                          text: 'Alıcı',
                          style: TextStyle(
                            color: HomeStyle(
                              context: context,
                            ).secondary, // "Alıcı" kelimesinin istediğiniz rengi
                          ),
                        ),
                        TextSpan(
                          text: ' olarak kayıt ol',
                          style: TextStyle(
                            color: HomeStyle(context: context).surface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categories(Category category, double width, double height) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/home/category',
              arguments: category.kategoriId,
            );
          },
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB), // bg-gray-50
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFF3F4F6), width: 1), // border-gray-100
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2), // shadow-sm
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: category.gorsel.isNotEmpty
                  ? Image.network(
                      category.gorsel,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.network(NotFound.LogoPNGUrl),
                    )
                  : Image.network(NotFound.LogoPNGUrl),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: Text(
            category.altKategoriAdi.toString(),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF4B5563), // text-gray-600
            ),
          ),
        ),
      ],
    );
  }

  void _voidCachedCategories() {
    //_futureCategory = ApiService.fetchCategories() as Future<List<Category>>;
    // Aşağıdaki kodu initState içine ekleyerek, eğer cachedProducts dolu ise
    // API çağrısı yapmadan cache'den verileri kullanıyoruz.
    if (cachedCategories != null && cachedCategories!.isNotEmpty) {
      // Cache dolu ise: direkt veriyi Future.value ile sarıyoruz.
      _futureCategory = Future.value(cachedCategories);
    } else {
      // İlk açılışta veya cache boşsa API'den verileri çek
      _futureCategory = ApiService.fetchCategories();
      _futureCategory.then((categories) {
        // Gelen veriyi cache'e atıyoruz.
        cachedCategories = categories;
      });
    }
  }

  void _voidCachedSellers() {
    if (cachedSellers != null && cachedSellers!.isNotEmpty) {
      // Cache dolu ise: direkt veriyi Future.value ile sarıyoruz.
      _futureSellers = Future.value(cachedSellers);
    } else {
      // İlk açılışta veya cache boşsa API'den verileri çek
      _futureSellers = ApiService.fetchSellers();
      _futureSellers.then((sellers) {
        // Gelen veriyi cache'e atıyoruz.
        cachedSellers = sellers;
      });
    }
  }
}
