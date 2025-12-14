part of '../products_detail_screen.dart';

class ProductsDetailViewBody extends ConsumerStatefulWidget {
  final int productId;

  const ProductsDetailViewBody({super.key, required this.productId});

  @override
  ConsumerState<ProductsDetailViewBody> createState() =>
      _ProductsDetailViewBodyState();
}

class _ProductsDetailViewBodyState
    extends ConsumerState<ProductsDetailViewBody> {
  bool biggerContainer = false;
  final int activeIndex = 0;
  double urunAciklamaContainerHeight = 150;
  double sizedBoxHeight = 200;

  Future<User>? _futureUser;
  late Future<UrunYorumlarResponse> _futureUrunYorumlar;
  bool isFavorite = false;
  int? favoriteProductId;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
    // Product verisi provider'dan gelecek, bu yüzden initState'de sadece productId'ye göre işlem yapıyoruz
    _futureUrunYorumlar = ApiService.takeCommentsForProduct(
      urunId: widget.productId,
    );
  }

  Future<void> _checkFavorite() async {
    try {
      final favorites = await ApiService.fetchUserFavorites(
        null,
        null,
        null,
        null,
      );
      for (var item in favorites) {
        if (item['urun'] == widget.productId) {
          setState(() {
            isFavorite = true;
            favoriteProductId = item['id'];
          });
          return;
        }
      }
      setState(() {
        isFavorite = false;
        favoriteProductId = null;
      });
    } catch (e) {
      setState(() {
        isFavorite = false;
        favoriteProductId = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productProvider(widget.productId));

    return productAsync.when(
      loading: () => Center(child: buildLoadingBar(context)),
      error: (error, stackTrace) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Ürün yüklenemedi: $error', textAlign: TextAlign.center),
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
      data: (product) {
        double width = MediaQuery.of(context).size.width;
        final isSmallScreen = width < 360;
        final themeData = HomeStyle(context: context);
        final currentUser = ref.watch(userProvider);
        final isLoggedIn = currentUser != null;

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _urunFoto(width, themeData, isLoggedIn, currentUser, product),
              SizedBox(height: isSmallScreen ? 10 : 15),
              _urunBilgi(themeData, product, isSmallScreen),
              SizedBox(height: isSmallScreen ? 10 : 15),
              _urunStokBilgi(width, themeData, product, isSmallScreen),
              SizedBox(height: isSmallScreen ? 10 : 15),
              _urunSoruVeCevaplar(context, themeData, isSmallScreen),
              Divider(),
              _urunSaticiBilgli(themeData, width, product, isSmallScreen),
              _urunAciklama(
                context,
                themeData,
                width,
                product.aciklama ?? '',
                isSmallScreen,
              ),
              _urunYorumlari(context, width, themeData, isSmallScreen),
              _urunSoruCevap(context, themeData, width, isSmallScreen),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 12 : 15,
                  vertical: 8,
                ),
                child: customText(
                  'Benzer Ürünler',
                  context,
                  weight: FontWeight.bold,
                ),
              ),
              SizedBox(height: isSmallScreen ? 10 : 15),
            ],
          ),
        );
      },
    );
  }

  Container _urunSoruCevap(
    BuildContext context,
    HomeStyle themeData,
    double width,
    bool isSmallScreen,
  ) {
    return container(
      context,
      padding: EdgeInsets.only(
        left: isSmallScreen ? 12 : 20,
        top: isSmallScreen ? 8 : 10,
      ),
      color: themeData.surfaceContainer,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          customText(
            'Ürün Soru & Cevap',
            padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 8 : 10),
            context,
            size: isSmallScreen
                ? themeData.bodyMedium.fontSize
                : themeData.bodyLarge.fontSize,
            weight: FontWeight.w800,
          ),
          Divider(),
          SizedBox(
            height: 20.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                return soruCevapContainer(context, themeData, width, {
                  'soru': 'Soru ${index + 1}',
                  'cevap': 'Cevap ${index + 1}',
                  'cevapVeren': 'Cevap Veren Profil Adı',
                  'soruProfilAdi': 'Soru Profil Adı',
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _urunYorumlari(
    BuildContext context,
    double width,
    HomeStyle themeData,
    bool isSmallScreen,
  ) {
    return FutureBuilder<UrunYorumlarResponse>(
      future: _futureUrunYorumlar,
      builder: (context, yorumSnapshot) {
        if (yorumSnapshot.connectionState == ConnectionState.waiting) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildLoadingBar(context),
              SizedBox(height: isSmallScreen ? 12 : 16),
            ],
          );
        } else if (yorumSnapshot.hasError) {
          return Padding(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            child: Center(
              child: Text(
                'Yorumlar alınamadı: ${yorumSnapshot.error}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
              ),
            ),
          );
        } else if (!yorumSnapshot.hasData ||
            yorumSnapshot.data!.yorumlar.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            child: Center(
              child: Text(
                'Bu ürüne ait yorum bulunamadı',
                style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
              ),
            ),
          );
        }

        final filteredYorumlar = yorumSnapshot.data!;

        return container(
          context,
          width: width,
          color: themeData.surfaceContainer,
          padding: EdgeInsets.only(
            left: isSmallScreen ? 12 : 20,
            top: isSmallScreen ? 8 : 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              customText(
                'Ürün Yorumları',
                context,
                padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 8 : 10),
                size: isSmallScreen
                    ? themeData.bodyMedium.fontSize
                    : themeData.bodyLarge.fontSize,
                weight: FontWeight.w800,
              ),
              Divider(),
              SizedBox(
                height: isSmallScreen ? 160 : 175,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filteredYorumlar.yorumlar.length,
                  itemBuilder: (context, index) {
                    final yorum = filteredYorumlar.yorumlar[index];
                    final adSoyad = [
                      yorum.kullaniciAd.trim(),
                      yorum.kullaniciSoyad.trim(),
                    ].where((part) => part.isNotEmpty).toList();
                    final displayName = adSoyad.isEmpty
                        ? 'Kullanıcı'
                        : adSoyad.join(' ');
                    final yorumMap = {
                      'yorumName': displayName,
                      'rating': (yorum.puan).toDouble(),
                      'userImg': '',
                      'resimler': yorum.resimler,
                      'yorum': yorum.yorum,
                    };
                    return yorumContainer(context, themeData, width, yorumMap);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  AnimatedContainer _urunAciklama(
    BuildContext context,
    HomeStyle themeData,
    double width,
    String aciklama,
    bool isSmallScreen,
  ) {
    final shouldShowToggle = aciklama.trim().length > 180;
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 15,
        vertical: isSmallScreen ? 8 : 10,
      ),
      color: themeData.surfaceContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          richText(
            fontWeight: FontWeight.w300,
            fontSize: isSmallScreen
                ? themeData.bodySmall.fontSize
                : themeData.bodyMedium.fontSize,
            textAlign: TextAlign.left,
            context,
            maxLines: biggerContainer == false ? 4 : 999,
            overflow: TextOverflow.ellipsis,
            color: themeData.primary,
            children: [
              TextSpan(
                text: 'Açıklama\n\n',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(text: aciklama),
            ],
          ),
          Divider(),
          if (shouldShowToggle)
            SizedBox(
              width: width,
              height: isSmallScreen ? 30 : 35,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      biggerContainer = !biggerContainer;
                    });
                  },
                  child: customText(
                    biggerContainer == false ? 'Tüm Açıklamayı oku' : 'Kısalt',
                    context,
                    color: themeData.secondary,
                    weight: FontWeight.bold,
                    size: isSmallScreen ? 13 : null,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  FutureBuilder<User> _urunSaticiBilgli(
    HomeStyle themeData,
    double width,
    Product product,
    bool isSmallScreen,
  ) {
    // User verisini product'a göre yükle
    _futureUser ??= ApiService.fetchUserId(product.satici);
    return FutureBuilder<User>(
      future: _futureUser!,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildLoadingBar(context),
              SizedBox(height: isSmallScreen ? 12 : 16),
            ],
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            child: Center(
              child: Text(
                'Bir hata oluştu: ${snapshot.error}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
              ),
            ),
          );
        } else {
          final user = snapshot.data!;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 15),
            child: Column(
              children: [
                // Satıcı Bilgisi - Responsive Wrap
                Wrap(
                  spacing: isSmallScreen ? 4 : 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    customText(
                      'Ürünün Satıcısı:',
                      context,
                      color: themeData.primary.withOpacity(0.3),
                      size: isSmallScreen ? 12 : null,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/profil/sellerProfile',
                          arguments: [user, false],
                        );
                      },
                      child: customText(
                        user.username,
                        context,
                        color: Colors.blue,
                        weight: FontWeight.bold,
                        size: isSmallScreen ? 12 : null,
                      ),
                    ),
                    container(
                      context,
                      margin: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 4 : 8,
                      ),
                      alignment: Alignment.center,
                      borderRadius: BorderRadius.circular(4),
                      color: themeData.secondary,
                      width: isSmallScreen ? 30 : 35,
                      height: isSmallScreen ? 18 : 20,
                      isBoxShadow: false,
                      child: customText(
                        user.saticiProfili?.degerlendirmePuani.toString() ??
                            '0.0',
                        context,
                        color: themeData.onSecondary,
                        weight: FontWeight.bold,
                        size: isSmallScreen ? 10 : null,
                      ),
                    ),
                    Expanded(
                      child: customText(
                        '5(beş) üzerinden',
                        context,
                        maxLines: 2,
                        color: themeData.primary.withOpacity(0.3),
                        size: isSmallScreen ? 10 : themeData.bodySmall.fontSize,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isSmallScreen ? 12 : 15),

                // Butonlar - Responsive Row/Wrap
                Wrap(
                  spacing: isSmallScreen ? 8 : 12,
                  runSpacing: isSmallScreen ? 8 : 10,
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    // Favorilere Ekle Butonu
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: isSmallScreen ? width * 0.5 : width * 0.55,
                        maxWidth: isSmallScreen ? width * 0.92 : width * 0.6,
                      ),
                      child: textButton(
                        context,
                        isSmallScreen
                            ? 'Favorilere ekle'
                            : 'Satıcıyı favorilere ekle',
                        textAlignment: Alignment.center,
                        buttonColor: themeData.onSecondary,
                        titleColor: themeData.primary,
                        elevation: 0,
                        border: true,
                        fontSize: isSmallScreen
                            ? 11
                            : themeData.bodyMedium.fontSize,
                        icon: Image.network(
                          fit: BoxFit.cover,
                          width: isSmallScreen ? 12 : 15,
                          height: isSmallScreen ? 14 : 20,
                          'https://i.pinimg.com/736x/47/ef/b4/47efb45d1159f37da35e5031d7906cd9.jpg',
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 8 : 12,
                          vertical: isSmallScreen ? 8 : 10,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),

                    // İmece Onaylı Badge
                    Builder(
                      builder: (context) {
                        if (user.saticiProfili?.imeceOnay ?? false) {
                          return richText(
                            context,
                            fontSize: isSmallScreen ? 11 : 13,
                            children: [
                              TextSpan(text: 'İmece onaylı '),
                              WidgetSpan(
                                child: SizedBox(
                                  width: isSmallScreen ? 14 : 18,
                                  height: isSmallScreen ? 14 : 18,
                                  child: Image.network(
                                    color: Color.fromRGBO(255, 229, 0, 1),
                                    fit: BoxFit.cover,
                                    'https://icons.veryicon.com/png/o/miscellaneous/linear/certificate-11.png',
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return ShaderMask(
                            shaderCallback: (bounds) =>
                                LinearGradient(
                                  colors: [
                                    Color.fromRGBO(255, 229, 0, 1),
                                    Color.fromRGBO(153, 138, 0, 1),
                                  ],
                                ).createShader(
                                  Rect.fromLTWH(
                                    0,
                                    0,
                                    bounds.width,
                                    bounds.height,
                                  ),
                                ),
                            child: richText(
                              context,
                              fontSize: isSmallScreen ? 11 : 13,
                              children: [
                                TextSpan(
                                  text: 'İmece onaylı ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                    fontSize: isSmallScreen ? 11 : 13,
                                  ),
                                ),
                                WidgetSpan(
                                  child: SizedBox(
                                    width: isSmallScreen ? 14 : 18,
                                    height: isSmallScreen ? 14 : 18,
                                    child: Image.network(
                                      'https://icons.veryicon.com/png/o/miscellaneous/linear/certificate-11.png',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }

  GestureDetector _urunSoruVeCevaplar(
    BuildContext context,
    HomeStyle themeData,
    bool isSmallScreen,
  ) {
    return GestureDetector(
      onTap: () {
        showTemporarySnackBar(
          context,
          'Soru ve Cevaplar',
          type: SnackBarType.info,
        );
      },
      child: Container(
        margin: EdgeInsets.only(left: isSmallScreen ? 12 : 15),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.message,
              color: themeData.secondary,
              size: isSmallScreen ? 18 : 24,
            ),
            SizedBox(width: isSmallScreen ? 4 : 8),
            Flexible(
              child: customText(
                'Ürün Soru & Cevapları (2)',
                context,
                size: isSmallScreen ? 12 : null,
              ),
            ),
            Icon(Icons.navigate_next, size: isSmallScreen ? 14 : 16),
          ],
        ),
      ),
    );
  }

  Widget _urunStokBilgi(
    double width,
    HomeStyle themeData,
    Product product,
    bool isSmallScreen,
  ) {
    // Column içindeki maxWidth constraint yüzünden Container varsayılan olarak genişliyor.
    // Burada IntrinsicWidth ile içerik kadar genişlemesini sağlıyoruz.
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 15),
      child: Align(
        alignment: Alignment.centerLeft,
        child: IntrinsicWidth(
          child: Container(
            alignment: Alignment.center,
            constraints: BoxConstraints(minHeight: isSmallScreen ? 26 : 30),
            padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Color.fromRGBO(255, 34, 34, 0.1),
            ),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: themeData.primary,
                  fontSize: isSmallScreen ? 11 : themeData.bodyMedium.fontSize,
                ),
                children: [
                  TextSpan(
                    text: 'Kalan KG:',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                  TextSpan(
                    text: ' ${product.stokDurumu.toString()}',
                    style: TextStyle(
                      color: getStokRengi(product.stokDurumu ?? 0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _urunBilgi(HomeStyle themeData, Product product, bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 15),
      child: RichText(
        maxLines: isSmallScreen ? 2 : 3,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          style: TextStyle(
            color: themeData.primary,
            fontSize: isSmallScreen
                ? themeData.bodyMedium.fontSize
                : themeData.bodyLarge.fontSize,
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(text: '${product.urunAdi}  - '),
            TextSpan(
              text: mainCategoryToString(
                mainCategoryFromInt(product.kategori) ?? MainCategory.meyveler,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stack _urunFoto(
    double width,
    HomeStyle themeData,
    bool isLoggedIn,
    User? currentUser,
    Product product,
  ) {
    final isSmallScreen = width < 360;
    final imageHeight = isSmallScreen ? 250.0 : 300.0;

    return Stack(
      children: [
        Container(
          height: imageHeight,
          width: width,
          decoration: BoxDecoration(
            border: Border.all(color: themeData.outline.withOpacity(0.5)),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                product.kapakGorseli == ''
                    ? NotFound.defaultBannerImageUrl
                    : product.kapakGorseli ?? NotFound.defaultBannerImageUrl,
              ),
            ),
          ),
        ),
        Positioned(
          height: isSmallScreen ? 11 : 13,
          bottom: 5,
          left: width / 2 - (isSmallScreen ? 12 : 15),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.7),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: List.generate(4, (index) {
                final bool isActive = (index + 1) == activeIndex;
                return Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 1.5 : 2,
                  ),
                  width: isSmallScreen ? 4 : 5,
                  height: isSmallScreen ? 4 : 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? Colors.grey.shade200
                        : Colors.grey.shade500,
                  ),
                );
              }),
            ),
          ),
        ),
        Builder(
          builder: (context) {
            final isSeller = currentUser?.rol == 'satici';
            return isLoggedIn && !isSeller
                ? Positioned(
                    width: isSmallScreen ? 36 : 40,
                    height: isSmallScreen ? 36 : 40,
                    right: isSmallScreen ? 8 : 10,
                    top: isSmallScreen ? 8 : 10,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: themeData.surfaceContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: favoriIconButton(context, () async {
                        if (!isLoggedIn || currentUser == null) {
                          showTemporarySnackBar(
                            context,
                            'Lütfen giriş yapınız',
                            type: SnackBarType.info,
                          );
                          return;
                        }
                        if (isFavorite && favoriteProductId != null) {
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
                        } else {
                          await ApiService.fetchUserFavorites(
                            null,
                            currentUser.id,
                            product.urunId,
                            null,
                          );
                          showTemporarySnackBar(
                            context,
                            'Favoriye eklendi',
                            type: SnackBarType.success,
                          );
                        }
                        await _checkFavorite();
                        setState(() {});
                      }, selected: isFavorite),
                    ),
                  )
                : SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
