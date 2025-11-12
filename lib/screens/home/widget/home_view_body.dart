part of '../home_screen.dart';

class _HomeViewBody extends StatefulWidget {
  const _HomeViewBody();

  @override
  State<_HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<_HomeViewBody> {
  static List<Category>? cachedCategories;
  static List<Company>? cachedSellers;
  static List<Product>? cachedPopulerProducts;
  late Future<List<Category>> _futureCategory;
  late Future<List<Company>> _futureSellers;
  late Future<List<Product>> _futurePopulerProducts;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _voidCachedCategories();
    _voidCachedSellers();
    _voidCachedPopulerProducts();
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

    List<Product> freshPopulerProducts =
        await ApiService.fetchPopulerProducts();
    setState(() {
      cachedPopulerProducts = freshPopulerProducts;
      _futurePopulerProducts = Future.value(freshPopulerProducts);
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final themeData = HomeStyle(context: context);
    return Scaffold(
      appBar: HomeHeaderAppBar(),
      body: RefreshIndicator(
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
                  _kampanyalarItems(width, height),
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
    );
  }

  Column _futurePopulerProductsView(double width, double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _populerUrunlerText(context),
        FutureBuilder<List<Product>>(
          future: _futurePopulerProducts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ProductsGridShimmer(itemCount: 2);
            } else if (snapshot.hasError) {
              return Text("Hata oluştu: ${snapshot.error}");
            } else if (snapshot.hasData) {
              List<Product> populerProducts = snapshot.data!;

              return _populerUrunCards(width, height, populerProducts);
            } else {
              return SizedBox();
            }
          },
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
        return productsCard2(
          product: populerProducts[index],
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

  Widget _kampanyalarItems(double width, double height) {
    return FutureBuilder<Campaigns>(
      future: ApiService.fetchProductsCampaings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(height: 200, child: CampaignsShimmer(height: 200));
        } else if (snapshot.hasError) {
          return Center(child: Text("Hata oluştu: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          final campaigns = snapshot.data!;
          if (campaigns.data.isEmpty) {
            return SizedBox.shrink();
          }
          return SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: campaigns.data.length,
              itemBuilder: (context, index) {
                final item = campaigns.data[index];
                return Padding(
                  padding: EdgeInsets.only(
                    right: index == campaigns.data.length - 1 ? 0 : 8,
                  ),
                  child: CampaingsCard(
                    item: item,
                    width: width,
                    height: height,
                  ),
                );
              },
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
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
      spacing: 5,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              Navigator.pushNamed(
                context,
                '/home/category',
                arguments: category.kategoriId,
              );
            });
          },
          child: Container(
            width: width * 0.20,
            height: height * 0.08,
            decoration: BoxDecoration(
              boxShadow: [boxShadow(context)],
              borderRadius: HomeStyle(
                context: context,
              ).bodyCategoryContainerBorderRadius,
              image: DecorationImage(
                image: category.gorsel.isNotEmpty
                    ? NetworkImage(category.gorsel)
                    : NetworkImage(NotFound.LogoPNGUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Expanded(
          child: customText(
            category.altKategoriAdi.toString(),
            context,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            color: HomeStyle(context: context).primary,
            size: HomeStyle(context: context).bodyMedium.fontSize,
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

  void _voidCachedPopulerProducts() {
    if (cachedPopulerProducts != null && cachedPopulerProducts!.isNotEmpty) {
      // Cache dolu ise: direkt veriyi Future.value ile sarıyoruz.
      _futurePopulerProducts = Future.value(cachedPopulerProducts);
    } else {
      // İlk açılışta veya cache boşsa API'den verileri çek
      _futurePopulerProducts = ApiService.fetchPopulerProducts();
      _futurePopulerProducts.then((populerProducts) {
        // Gelen veriyi cache'e atıyoruz.
        cachedPopulerProducts = populerProducts;
      });
    }
  }
}
