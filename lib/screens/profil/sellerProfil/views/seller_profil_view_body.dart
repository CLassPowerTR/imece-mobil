part of '../seller_profil_screen.dart';

class SellerProfilBody extends ConsumerStatefulWidget {
  final User sellerProfil;

  final bool myProfile;

  const SellerProfilBody({
    super.key,
    required this.sellerProfil,
    required this.myProfile,
  });

  @override
  ConsumerState<SellerProfilBody> createState() => _SellerProfilBodyState();
}

class _SellerProfilBodyState extends ConsumerState<SellerProfilBody> {
  late User _currentSellerProfil;
  File? _selectedProfilFoto;
  File? _selectedKapakFoto;
  PlatformFile? _selectedProfilFotoPlatform;
  PlatformFile? _selectedKapakFotoPlatform;
  bool _hasImageChanges = false;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _currentSellerProfil = widget.sellerProfil;
  }

  double coverHeight = 133; // Kapak fotoğrafının yüksekliği
  double profileSize = 81; // Profil resminin boyutları

  // Refresh işlemini gerçekleştiren metod:
  Future<void> _refreshProducts() async {
    // Seller profil verilerini güncelle (opsiyonel - hata olsa bile diğer veriler güncellenir)
    try {
      final updatedSellerProfil = await ApiService.fetchSellerProfile(
        _currentSellerProfil.id,
      );
      if (mounted) {
        setState(() {
          _currentSellerProfil = updatedSellerProfil;
        });
      }

      // Eğer kendi profiliyse, userProvider'ı da güncelle
      if (widget.myProfile) {
        ref.read(userProvider.notifier).setUser(updatedSellerProfil);
      }
    } catch (e) {
      debugPrint('Seller profil güncellenirken hata: $e');
      // Hata olsa bile diğer verileri güncellemeye devam et
      if (mounted && widget.myProfile) {
        // Kendi profiliyse userProvider'dan güncellemeyi dene
        try {
          await ref.read(userProvider.notifier).fetchUserMe();
          final currentUser = ref.read(userProvider);
          if (currentUser != null && mounted) {
            setState(() {
              _currentSellerProfil = currentUser;
            });
          }
        } catch (e2) {
          debugPrint('userProvider güncellenirken hata: $e2');
        }
      }
    }

    // Products repository'deki seller products cache'ini temizle
    try {
      final repository = ref.read(productsRepositoryProvider);
      repository.invalidateSellerProducts(_currentSellerProfil.id);
      // Popüler ürünler cache'ini de temizle (seller'ın ürünleri popüler ürünler listesinde olabilir)
      repository.invalidatePopulerProducts();
      debugPrint(
        'Seller products cache temizlendi: ${_currentSellerProfil.id}',
      );
    } catch (e) {
      debugPrint('Seller products cache temizlenirken hata: $e');
    }

    // Seller products provider'ı invalidate et (cache temizlendikten sonra)
    ref.invalidate(sellerProductsProvider(_currentSellerProfil.id));

    // Popüler ürünler provider'ını invalidate et
    ref.invalidate(populerProductsProvider);

    // Stories provider'ları yenile
    ref.invalidate(storiesCampaignsProvider);
    if (_currentSellerProfil.id != 0) {
      ref.invalidate(storiesCampaignsBySellerProvider(_currentSellerProfil.id));
    }

    // Provider'ların yenilenmesini bekle (cache temizlendikten sonra)
    // Bu sayede güncel veriler API'den çekilir ve eski cache verileri gösterilmez
    try {
      await Future.wait([
        ref.read(sellerProductsProvider(_currentSellerProfil.id).future),
        ref.read(storiesCampaignsProvider.future),
        ref.read(populerProductsProvider.future),
      ]);
      debugPrint(
        'Seller profil: Provider\'lar başarıyla yenilendi (${_currentSellerProfil.id})',
      );
    } catch (e) {
      debugPrint('Provider yenilenirken hata: $e');
      // Hata olsa bile refresh indicator'ı kapat
    }
  }

  String hakkinda =
      "Ben, Anadolu'nın bereketli topraklarında doğmuş, ömrünü bu topraklara adamış bir çiftçiyim. Yıllar önce babamın nasihatleriyle başladığım bu yolda, hem tohum ektim hem de hayatın türlü zorluklarıyla mücadele ettim. Tarla sürmekten hasat toplamaya, hayvan yetiştirmekten kışa hazırlık yapmaya kadar her işte emeğimi verdim. Bu topraklar bana hem geçimimi sağladı hem de sabrın, çalışkanlığın ne demek olduğunu öğretti. Şimdi ise, yılların birikimiyle, bilgimi ve tecrübemi sizin damağınızı şenlik ettirecek meyveler için kullanacağım.";
  Map<dynamic, dynamic> profil = {
    'profilImage':
        'https://raw.githubusercontent.com/MuhammedIkbalAKGUNDOGDU/imece-test-website/refs/heads/main/imece/src/assets/images/profil_photo.png',
  };
  Map<dynamic, dynamic> gonderi = {
    'gonderiBaslik': 'Başlık',
    'gonderiAciklama': 'Gönderi Hakkındaki Bilgiler',
    'gonderiImages': [
      'https://s3-alpha-sig.figma.com/img/986c/b818/056dfacdfdf401a5c21aaab97ba5433e?Expires=1743379200&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=agP1c9UHbwkXLQgf8o8B3OURHWu~-nyK5j-Ez53Gc~UBhBRKrHSTW6mjQVO5L57APBlNZHn9IKkrtI-VFGt2OL48Qi-EftIDUCuFH00zqU6YCtIIehvURNkEWUveoZeGsPxpNDxBMY~l90yx2kURlgfg8uT4RH0buM0HD-~VIo9eBQSwHqGFNPNhEu~-ktNclfuQk90x8Iu1NGBrODiUpW3gCch9SopgNWWY3jySbJ~Fc0Xz21FhhAX5ve7wz7nIkeAY1K00H4NgH4-7MSS7jvTguOwJkLUJNQIDOf28LR-aOEyDVpHoKMAR4DpOvVzpPj5L2a1sb6tkcDWVjwDUmg__',
      'https://s3-alpha-sig.figma.com/img/986c/b818/056dfacdfdf401a5c21aaab97ba5433e?Expires=1743379200&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=agP1c9UHbwkXLQgf8o8B3OURHWu~-nyK5j-Ez53Gc~UBhBRKrHSTW6mjQVO5L57APBlNZHn9IKkrtI-VFGt2OL48Qi-EftIDUCuFH00zqU6YCtIIehvURNkEWUveoZeGsPxpNDxBMY~l90yx2kURlgfg8uT4RH0buM0HD-~VIo9eBQSwHqGFNPNhEu~-ktNclfuQk90x8Iu1NGBrODiUpW3gCch9SopgNWWY3jySbJ~Fc0Xz21FhhAX5ve7wz7nIkeAY1K00H4NgH4-7MSS7jvTguOwJkLUJNQIDOf28LR-aOEyDVpHoKMAR4DpOvVzpPj5L2a1sb6tkcDWVjwDUmg__',
      'https://s3-alpha-sig.figma.com/img/986c/b818/056dfacdfdf401a5c21aaab97ba5433e?Expires=1743379200&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=agP1c9UHbwkXLQgf8o8B3OURHWu~-nyK5j-Ez53Gc~UBhBRKrHSTW6mjQVO5L57APBlNZHn9IKkrtI-VFGt2OL48Qi-EftIDUCuFH00zqU6YCtIIehvURNkEWUveoZeGsPxpNDxBMY~l90yx2kURlgfg8uT4RH0buM0HD-~VIo9eBQSwHqGFNPNhEu~-ktNclfuQk90x8Iu1NGBrODiUpW3gCch9SopgNWWY3jySbJ~Fc0Xz21FhhAX5ve7wz7nIkeAY1K00H4NgH4-7MSS7jvTguOwJkLUJNQIDOf28LR-aOEyDVpHoKMAR4DpOvVzpPj5L2a1sb6tkcDWVjwDUmg__',
    ],
  };
  int rating = 5;
  Map<dynamic, dynamic> yorum = {
    'yorumName': 'Murat Y.',
    'rating': 5.0,
    'userImg': '',
    'yorum': 'Burada kişilerin yorumları görünecektir.',
  };

  List<dynamic> products = [
    {
      'imagePath': [
        'assets/image/aliciOl.png',
        'assets/image/aliciOl.png',
        'assets/image/aliciOl.png',
      ],
      'productName': 'Ürün Adı',
      'rating': 5,
      'description': 'Ürün açıklaması',
      'price': 20,
    },
    {
      'imagePath': ['assets/image/aliciOl.png', 'assets/image/aliciOl.png'],
      'productName': 'Ürün Adı 2',
      'rating': 4,
      'description': 'Ürün açıklaması 2',
      'price': 25,
    },
    {
      'imagePath': ['assets/image/aliciOl.png'],
      'productName': 'Ürün Adı 3',
      'rating': 3,
      'description': 'Ürün açıklaması 3',
      'price': 30,
    },
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final themeData = HomeStyle(context: context);
    final sellerProductsAsync = ref.watch(
      sellerProductsProvider(_currentSellerProfil.id),
    );
    return Scaffold(
      backgroundColor: Colors.grey[100]!.withOpacity(0.7),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshProducts,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //spacing: 20,
                children: [
                  _profilGiris(width, context),
                  _profilHakkinda(themeData, width, context),
                  _profilIstatikler(width, themeData, sellerProductsAsync),
                  _profilStories(context, width),
                  _profilDetailCards(width, themeData),
                  _profilGonderiler(context, themeData, width),
                  _profilLastComment(context, width, themeData),
                  _BenzerUrunlerText(context, themeData),
                  //_populerUrunlerCards(height, width) //Backend yapımından dolayı deployed
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Builder _profilDetailCards(double width, HomeStyle themeData) {
    final List<dynamic> detailCards = [
      {
        'title': 'Yeni Ürün Ekle',
        'subtitle':
            'Mağzanıza yeni bir ürünler ekleyin ve satışlarınızı arttırın',
        'icon': Icons.add,
        'iconColor': AppColors.succesful(context),
        'router': '/profil/addProduct',
      },
      {
        'title': 'Ürünlerimi Görüntüle',
        'subtitle': 'Mevcut ürünlerinizi yönetin ve güncelleyin',
        'icon': Icons.view_in_ar,
        'iconColor': AppColors.secondary(context),
        'router': '/profil/myProducts',
      },
      {
        'title': 'Siparişlerim',
        'subtitle': 'Siparişlerinizi takip edin ve kargo işlemlerini yönetin',
        'icon': Icons.shopping_bag_outlined,
        'iconColor': AppColors.error(context),
        'router': null,
      },
      {
        'title': 'Finansal Dashboard',
        'subtitle': 'Satış Raporlarınızı ve finansal durumunuzu takip edin',
        'icon': Icons.stacked_line_chart,
        'iconColor': AppColors.purple(context),
        'router': '/profil/wallet',
      },
      {
        'title': 'Profil Ayarları',
        'subtitle': 'Profil bilgilerinizi düzenleyin ve güncelleyin',
        'icon': Icons.person_2_outlined,
        'iconColor': AppColors.orange(context),
        'router': '/profil/settings/seller',
      },
    ];
    return Builder(
      builder: (context) {
        if (widget.myProfile) {
          return container(
            context,
            color: AppColors.surfaceContainer(context),
            margin: AppPaddings.h10v10,
            borderRadius: AppRadius.r16,
            padding: AppPaddings.all16,
            width: width,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double totalWidth = constraints.maxWidth;
                const double horizontalSpacing = 12;
                const double runSpacing = 12;
                final double itemWidth = (totalWidth - horizontalSpacing) / 2;
                return Wrap(
                  spacing: horizontalSpacing,
                  runSpacing: runSpacing,
                  children: List.generate(detailCards.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        if (detailCards[index]['router'] != null) {
                          Navigator.pushNamed(
                            context,
                            detailCards[index]['router']!,
                            arguments: _currentSellerProfil,
                          );
                        }
                      },
                      child: SizedBox(
                        width: itemWidth,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: container(
                            context,
                            color: AppColors.surfaceContainer(context),
                            padding: AppPaddings.all16,
                            borderRadius: AppRadius.r16,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    mainAxisSize: MainAxisSize.max,
                                    spacing: 6,
                                    children: [
                                      customText(
                                        detailCards[index]['title'],
                                        context,
                                        maxLines: 2,
                                        textAlign: TextAlign.start,
                                        style: AppTextStyle.bodyMediumBold(
                                          context,
                                        ),
                                      ),
                                      customText(
                                        detailCards[index]['subtitle'],
                                        context,
                                        textAlign: TextAlign.start,
                                        style: AppTextStyle.bodySmallMuted(
                                          context,
                                        ),
                                        maxLines: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 36,
                                    width: 36,
                                    decoration: BoxDecoration(
                                      color: detailCards[index]['iconColor']
                                          .withOpacity(0.1),
                                      borderRadius: AppRadius.r18,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        detailCards[index]['icon'],
                                        color: detailCards[index]['iconColor'],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          );
        } else {
          return SizedBox(height: 0, width: 0);
        }
      },
    );
  }

  Builder _profilStories(BuildContext context, double width) => Builder(
    builder: (context) {
      final sellerId = _currentSellerProfil.id;
      final dataAsync = sellerId != 0
          ? ref.watch(storiesCampaignsBySellerProvider(sellerId))
          : ref.watch(storiesCampaignsProvider);

      return dataAsync.when(
        loading: () => widget.myProfile
            ? _storiesSectionContent(context, width, showButtons: true)
            : SizedBox.shrink(),
        error: (_, __) => widget.myProfile
            ? _storiesSectionContent(context, width, showButtons: true)
            : SizedBox.shrink(),
        data: (data) {
          final shouldShow = widget.myProfile || data.hasContent;
          if (!shouldShow) {
            return SizedBox.shrink();
          }
          return _storiesSectionContent(
            context,
            width,
            showButtons: widget.myProfile,
          );
        },
      );
    },
  );

  Widget _storiesSectionContent(
    BuildContext context,
    double width, {
    required bool showButtons,
  }) {
    return container(
      context,
      color: AppColors.surfaceContainer(context),
      margin: AppPaddings.h10v10,
      borderRadius: AppRadius.r16,
      padding: AppPaddings.all16,
      width: width,
      child: Column(
        spacing: 18,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: customText(
              'Hikayeler',
              context,
              textAlign: TextAlign.left,
              style: AppTextStyle.bodyLargeBold(context),
            ),
          ),
          if (showButtons)
            Row(
              spacing: 6,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.blue(context),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.r8),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/profil/addPost',
                        arguments: {
                          'user': _currentSellerProfil,
                          'isStory': true,
                        },
                      );
                    },
                    label: customText(
                      'Hikaye Ekle',
                      context,
                      style: AppTextStyle.bodyMedium(
                        context,
                        color: AppColors.onPrimary(context),
                      ),
                    ),
                    icon: Icon(
                      Icons.add_outlined,
                      color: AppColors.onPrimary(context),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.succesful(context),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.r8),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/profil/addPost',
                        arguments: {
                          'user': _currentSellerProfil,
                          'isStory': false,
                        },
                      );
                    },
                    label: customText(
                      'Kampanya Ekle',
                      context,
                      style: AppTextStyle.bodyMedium(
                        context,
                        color: AppColors.onPrimary(context),
                      ),
                    ),
                    icon: Icon(
                      Icons.add_outlined,
                      color: AppColors.onPrimary(context),
                    ),
                  ),
                ),
              ],
            ),
          StoryCampaingsCard(
            width: width,
            height: MediaQuery.of(context).size.height,
            sellerId: _currentSellerProfil.id,
            margin: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  GridView _populerUrunlerCards(double height, double width) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisExtent: height * 0.4,
        crossAxisCount: 2, // İki sütun
        crossAxisSpacing: 10, // Sütunlar arası yatay boşluk
        mainAxisSpacing: 10, // Satırlar arası dikey boşluk
      ),
      itemCount: products.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final product = products[index];
        // products listesi dynamic tipinde, Map olabilir
        final productId = product is Map
            ? (product['urun_id'] ?? product['id'] ?? 0)
            : 0;
        return productsCard(
          sepeteEkle: () {},
          favoriEkle: () {},
          isFavorite: false,
          isSepet: false,
          productId: productId,
          width: width,
          context: context,
          height: height,
        );
      },
    );
  }

  Padding _BenzerUrunlerText(BuildContext context, HomeStyle themeData) {
    return customText(
      'Benzer Ürünler',
      context,
      padding: EdgeInsets.only(left: 10),
      textAlign: TextAlign.left,
      size: themeData.bodyLarge.fontSize,
      weight: FontWeight.w800,
    );
  }

  Container _profilLastComment(
    BuildContext context,
    double width,
    HomeStyle themeData,
  ) {
    return container(
      context,
      width: width,
      color: themeData.surfaceContainer,
      padding: EdgeInsets.only(left: 20, top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        //spacing: 10,
        children: [
          customText(
            'Son 4 Satışın Yorumları',
            context,
            size: themeData.bodyLarge.fontSize,
            weight: FontWeight.w800,
          ),
          Divider(),
          SizedBox(
            height: 200, // Yorum kutularının yüksekliği
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                return yorumContainer(context, themeData, width, yorum);
              },
            ),
          ),
        ],
      ),
    );
  }

  Container _profilGonderiler(
    BuildContext context,
    HomeStyle themeData,
    double width,
  ) {
    return container(
      context,
      color: themeData.surfaceContainer,
      borderRadius: AppRadius.r16,
      margin: AppPaddings.h10v10,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          customText(
            'Gönderiler',
            context,
            size: themeData.bodyLarge.fontSize,
            weight: FontWeight.w900,
          ),
          gonderiContainer(
            context,
            themeData,
            gonderi['gonderiBaslik'],
            gonderi['gonderiAciklama'],
            gonderi['gonderiImages'],
            profil['profilImage'],
            _currentSellerProfil.username,
          ),
          _seeAllPosts(width, themeData),
        ],
      ),
    );
  }

  SizedBox _seeAllPosts(double width, HomeStyle themeData) {
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: () {
          setState(() {
            print('Tüm gönderileri gör');
          });
        },
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: themeData.headlineSmall.fontSize,
              color: themeData.secondary,
            ), // Varsayılan stil
            children: [
              TextSpan(text: 'Tüm gönderileri gör'),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Icon(
                  size: themeData.headlineSmall.fontSize! * 1.1,
                  Icons.arrow_forward,
                  color: themeData.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profilHakkinda(
    HomeStyle themeData,
    double width,
    BuildContext context,
  ) {
    return Builder(
      builder: (context) {
        if (_currentSellerProfil.saticiProfili?.profilTanitimYazisi != '') {
          return container(
            context,
            color: themeData.surfaceContainer,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            borderRadius: AppRadius.r16,
            width: width,
            margin: AppPaddings.h10v10,
            //height: 268,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              spacing: 10,
              children: [
                customText(
                  'Hakkında',
                  context,
                  size: themeData.bodyLarge.fontSize,
                  weight: FontWeight.w800,
                ),
                customText(
                  _currentSellerProfil.saticiProfili?.profilTanitimYazisi == ''
                      ? 'NoName'
                      : _currentSellerProfil
                                .saticiProfili
                                ?.profilTanitimYazisi ??
                            '',
                  context,
                  weight: FontWeight.w400,
                  maxLines: 13,
                  size: themeData.bodyMedium.fontSize,
                ),
                Builder(
                  builder: (context) {
                    if (widget.myProfile) {
                      return Align(
                        alignment: Alignment.bottomRight,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/profil/settings/seller',
                            );
                          },
                          child: RichText(
                            textAlign: TextAlign.end,
                            text: TextSpan(
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: HomeStyle(
                                  context: context,
                                ).bodyMedium.fontSize,
                                color: themeData.secondary,
                              ), // Varsayılan stil
                              children: [
                                TextSpan(
                                  text: 'hakkında kısmını düzenle',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: themeData.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ],
            ),
          );
        }
        return SizedBox();
      },
    );
  }

  Builder _profilIstatikler(
    double width,
    HomeStyle themeData,
    AsyncValue<List<SellerProducts>> sellerProductsAsync,
  ) {
    return Builder(
      builder: (context) {
        if (widget.myProfile) {
          String _buildStatValue(
            int Function(List<SellerProducts> list) resolver,
          ) {
            return sellerProductsAsync.when(
              data: (list) => '${resolver(list)}',
              loading: () => '...',
              error: (_, __) => '—',
            );
          }

          final sellerProducts = sellerProductsAsync.asData?.value ?? [];
          final activeProducts = sellerProducts
              .where((e) => e.urunGorunurluluk == true)
              .toList();

          return container(
            context,
            margin: AppPaddings.h10v10,
            borderRadius: AppRadius.r16,
            padding: AppPaddings.all16,
            color: HomeStyle(context: context).surfaceContainer,
            width: width,
            child: Column(
              spacing: 18,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                customText(
                  'Profil istatistikleri',
                  context,
                  size: themeData.bodyLarge.fontSize,
                  weight: FontWeight.w800,
                ),
                Row(
                  spacing: 12,
                  children: [
                    Expanded(
                      child: _statisticsInfoCard(
                        context,
                        title: 'Toplam Ürün',
                        value: _buildStatValue((list) => list.length),
                        icon: Icons.person,
                        backgroundColor: AppColors.succesful(context),
                        payload: sellerProducts.cast<dynamic>(),
                        onTap: (list) {
                          if (list.isEmpty) return;
                          Navigator.pushNamed(
                            context,
                            '/profil/seller-products',
                            arguments: {
                              'products': list,
                              'filter': 'all',
                              'sellerId': _currentSellerProfil.id,
                            },
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: _statisticsInfoCard(
                        context,
                        title: 'Aktif  Ürün',
                        value: _buildStatValue(
                          (list) => list
                              .where((e) => e.urunGorunurluluk == true)
                              .length,
                        ),
                        icon: Icons.add_task,
                        backgroundColor: AppColors.succesful(context),
                        payload: activeProducts.cast<dynamic>(),
                        onTap: (list) {
                          if (list.isEmpty) return;
                          Navigator.pushNamed(
                            context,
                            '/profil/seller-products',
                            arguments: {
                              'products': list,
                              'filter': 'active',
                              'sellerId': _currentSellerProfil.id,
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  spacing: 12,
                  children: [
                    Expanded(
                      child: _statisticsInfoCard(
                        context,
                        title: 'Toplam Satış',
                        value: '0',
                        icon: Icons.shopping_bag_outlined,
                        backgroundColor: AppColors.orange(context),
                      ),
                    ),
                    Expanded(
                      child: _statisticsInfoCard(
                        context,
                        title: 'Aylık Gelir',
                        value: '0 ₺',
                        icon: Icons.attach_money,
                        backgroundColor: AppColors.error(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return SizedBox(height: 0, width: 0);
        }
      },
    );
  }

  Container _statisticsInfoCard(
    BuildContext context, {
    String? title,
    String? value,
    IconData? icon,
    Color? backgroundColor,
    List<dynamic>? payload,
    void Function(List<dynamic> list)? onTap,
  }) {
    final Color effectiveBackgroundColor =
        backgroundColor ??
        HomeStyle(context: context).secondary.withOpacity(0.15);
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadius.r16,
        border: Border(
          left: BorderSide(color: effectiveBackgroundColor, width: 4),
        ),
      ),
      child: GestureDetector(
        onTap: onTap == null
            ? null
            : () {
                onTap(payload ?? const []);
              },
        child: container(
          context,
          color: AppColors.surfaceContainer(context),
          padding: AppPaddings.all16,
          borderRadius: AppRadius.r16,
          child: Row(
            spacing: 12,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: effectiveBackgroundColor.withOpacity(0.15),
                  borderRadius: AppRadius.r18,
                ),
                child: Center(
                  child: Icon(
                    icon ?? Icons.info_outline,
                    color: effectiveBackgroundColor,
                  ),
                ),
              ),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${title ?? ''}\n',
                      style: AppTextStyle.bodyMedium(context),
                    ),
                    TextSpan(
                      text: value ?? '',
                      style: AppTextStyle.bodyLargeBold(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(bool isProfilFoto) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg'],
        allowMultiple: false,
        withData: true, // Bytes'ı direkt al
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.single;
        if (file.bytes != null) {
          setState(() {
            if (isProfilFoto) {
              _selectedProfilFotoPlatform = file;
              // File objesi de tut (preview için)
              if (file.path != null) {
                _selectedProfilFoto = File(file.path!);
              }
            } else {
              _selectedKapakFotoPlatform = file;
              // File objesi de tut (preview için)
              if (file.path != null) {
                _selectedKapakFoto = File(file.path!);
              }
            }
            _hasImageChanges = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Resim seçilirken hata: $e');
      if (mounted) {
        showTemporarySnackBar(
          context,
          'Resim seçilirken bir hata oluştu: $e',
          type: SnackBarType.error,
        );
      }
    }
  }

  // Profil fotoğrafı güncelleme fonksiyonu
  Future<void> _updateProfilFoto() async {
    if (_selectedProfilFotoPlatform == null ||
        _selectedProfilFotoPlatform!.bytes == null) {
      return;
    }

    try {
      final fileBytes = _selectedProfilFotoPlatform!.bytes!;
      final fileName = _selectedProfilFotoPlatform!.name;
      final contentType = fileName.toLowerCase().endsWith('.png')
          ? 'image/png'
          : 'image/jpeg';

      final multipartFile = http.MultipartFile.fromBytes(
        'profil_fotograf',
        fileBytes,
        filename: fileName,
        contentType: http.MediaType.parse(contentType),
      );

      debugPrint(
        'Profil fotoğrafı güncelleniyor - field: profil_fotograf, filename: $fileName, size: ${fileBytes.length}',
      );

      // userPayload içine profil_fotograf olarak ekle
      await ref.read(userProvider.notifier).updateUser({
        'profil_fotograf': multipartFile,
      }, isSeller: false);
    } catch (e) {
      debugPrint('Profil fotoğrafı güncellenirken hata: $e');
      rethrow;
    }
  }

  Future<void> _updateProfileImages() async {
    if (!_hasImageChanges || _isUpdating) return;

    setState(() {
      _isUpdating = true;
    });

    try {
      // Profil fotoğrafı güncelle
      if (_selectedProfilFotoPlatform != null &&
          _selectedProfilFotoPlatform!.bytes != null) {
        await _updateProfilFoto();
      }

      // Kapak fotoğrafı güncelle
      if (_selectedKapakFotoPlatform != null &&
          _selectedKapakFotoPlatform!.bytes != null) {
        final fileBytes = _selectedKapakFotoPlatform!.bytes!;
        final fileName = _selectedKapakFotoPlatform!.name;
        final contentType = fileName.toLowerCase().endsWith('.png')
            ? 'image/png'
            : 'image/jpeg';

        final multipartFile = http.MultipartFile.fromBytes(
          'profil_banner',
          fileBytes,
          filename: fileName,
          contentType: http.MediaType.parse(contentType),
        );

        debugPrint(
          'Kapak fotoğrafı güncelleniyor - field: profil_banner, filename: $fileName, size: ${fileBytes.length}',
        );

        // userPayload içine profil_banner olarak ekle
        await ref.read(userProvider.notifier).updateUser({
          'profil_banner': multipartFile,
        }, isSeller: true);
      }

      // Kullanıcı verilerini yeniden yükle
      await ref.read(userProvider.notifier).fetchUserMe();
      final updatedUser = ref.read(userProvider);
      if (updatedUser != null) {
        setState(() {
          _currentSellerProfil = updatedUser;
          _selectedProfilFoto = null;
          _selectedKapakFoto = null;
          _selectedProfilFotoPlatform = null;
          _selectedKapakFotoPlatform = null;
          _hasImageChanges = false;
        });
      }

      if (mounted) {
        showTemporarySnackBar(
          context,
          'Profil başarıyla güncellendi!',
          type: SnackBarType.success,
        );
      }
    } catch (e) {
      debugPrint('Profil güncellenirken hata: $e');
      if (mounted) {
        showTemporarySnackBar(
          context,
          'Profil güncellenirken bir hata oluştu: $e',
          type: SnackBarType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  Column _profilGiris(double width, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Profilimi Güncelle butonu (sadece resim değişikliği varsa)
        if (widget.myProfile && _hasImageChanges)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: SizedBox(
              width: double.infinity,
              child: textButton(
                context,
                _isUpdating ? 'Güncelleniyor...' : 'Profilimi Güncelle',
                minSizeHeight: 40,
                elevation: 5,
                buttonColor: HomeStyle(context: context).secondary,
                onPressed: _isUpdating ? null : _updateProfileImages,
              ),
            ),
          ),
        container(
          context,

          color: HomeStyle(context: context).surfaceContainer,
          //height: 306,
          padding: EdgeInsets.only(bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none, // Taşan kısımların kesilmemesi için
                children: [_kapakFoto(width), _profilFoto(width)],
              ),
              SizedBox(height: profileSize / 3),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _isimVeBilgi(context),
                    Column(
                      spacing: 5,
                      //crossAxisAlignment: CrossAxisAlignment.end,
                      //mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [_stickerEdit(context), _imeceOnay(context)],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 1,
                      child: widget.myProfile
                          ? textButton(
                              context,
                              'Profil Önizleme  ',
                              minSizeHeight: 32,
                              elevation: 5,
                              icon: Icon(
                                Icons.remove_red_eye_outlined,
                                color: AppColors.onPrimary(context),
                                size: 20,
                              ),

                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/profil/sellerProfile',
                                  arguments: [_currentSellerProfil, false],
                                );
                              },
                            )
                          : _currentSellerProfil.rol == 'satici'
                          ? FutureBuilder<List<dynamic>>(
                              future: ApiService.fetchUserFollow(),
                              builder: (context, snapshot) {
                                final kullanici = ref.read(userProvider);
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: buildLoadingBar(context),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('Takip durumu alınamadı');
                                } else {
                                  final takipEdilenler = snapshot.data ?? [];
                                  // Takip edilenler arasında bu satıcı var mı?
                                  final takipItem = takipEdilenler.firstWhere(
                                    (item) =>
                                        item['satici'] ==
                                        _currentSellerProfil.id,
                                    orElse: () => null,
                                  );
                                  final isFollowed = takipItem != null;
                                  return textButton(
                                    context,
                                    isFollowed ? 'Takipten Çık' : 'Takip Et',
                                    minSizeHeight: 32,
                                    elevation: 5,
                                    buttonColor: isFollowed
                                        ? Colors.orange[500]
                                        : HomeStyle(context: context).secondary,
                                    onPressed: () async {
                                      if (isFollowed) {
                                        // Takipten çık fonksiyonu (unfollow)
                                        try {
                                          await ApiService.deleteUserFollow(
                                            takipItem['id'],
                                          );
                                          showTemporarySnackBar(
                                            context,
                                            'Takipten çıkarıldı',
                                            type: SnackBarType.success,
                                          );
                                          setState(
                                            () {},
                                          ); // Takip durumu güncellensin
                                        } catch (e) {
                                          debugPrint(e.toString());
                                          showTemporarySnackBar(
                                            context,
                                            'Takipten çıkarken hata oluştu: $e',
                                            type: SnackBarType.error,
                                          );
                                        }
                                      } else {
                                        // Takip et fonksiyonu
                                        try {
                                          await ApiService.postUserFollow(
                                            _currentSellerProfil.id,
                                            kullanici!.id,
                                          );
                                          showTemporarySnackBar(
                                            context,
                                            'Takip Edildi',
                                            type: SnackBarType.success,
                                          );
                                          setState(
                                            () {},
                                          ); // Takip durumu güncellensin
                                        } catch (e) {
                                          showTemporarySnackBar(
                                            context,
                                            'Takip ederken hata oluştu: $e',
                                            type: SnackBarType.error,
                                          );
                                        }
                                      }
                                    },
                                  );
                                }
                              },
                            )
                          : SizedBox.shrink(),
                    ),
                    Expanded(
                      flex: 1,
                      child: widget.myProfile
                          ? textButton(
                              context,
                              'Mesaj Kutun',
                              minSizeHeight: 32,
                              elevation: 5,
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/profil/messaging',
                                );
                              },
                            )
                          : textButton(
                              context,
                              'Mesaj Gönder',
                              minSizeHeight: 32,
                              elevation: 5,
                              onPressed: () {
                                showTemporarySnackBar(
                                  context,
                                  'Mesaj Gönder Button (){onPressed}',
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column _imeceOnay(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        Builder(
          builder: (context) {
            if (_currentSellerProfil.saticiProfili?.imeceOnay ?? false) {
              return ShaderMask(
                shaderCallback: (bounds) =>
                    LinearGradient(
                      colors: [
                        Color.fromRGBO(255, 229, 0, 1),
                        Color.fromRGBO(153, 138, 0, 1),
                      ],
                    ).createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                child: RichText(
                  textAlign: TextAlign.end,
                  text: TextSpan(
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      decoration: TextDecoration.underline,
                      fontSize: HomeStyle(context: context).bodyMedium.fontSize,
                      color: Colors.white,
                    ), // Varsayılan stil
                    children: [
                      TextSpan(text: 'İmece Onaylı Satıcı  '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Image.asset(
                          fit: BoxFit.cover,
                          colorBlendMode: BlendMode.color,
                          cacheHeight: 13,
                          cacheWidth: 19,
                          'assets/icon/ic_certificate.jpg',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return SizedBox();
          },
        ),
        Builder(
          builder: (context) {
            if (widget.myProfile &&
                _currentSellerProfil.saticiProfili?.imeceOnayLastDate != null) {
              return customText(
                '${_currentSellerProfil.saticiProfili?.imeceOnayLastDate ?? ''} Tarihine kadar ',
                context,
                weight: FontWeight.w500,
                size: HomeStyle(context: context).bodySmall.fontSize,
              );
            } else {
              return SizedBox(height: 15);
            }
          },
        ),
      ],
    );
  }

  Column _stickerEdit(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        Builder(
          builder: (context) {
            if (_currentSellerProfil.rol == 'satici') {
              return FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                //flex: 2,
                child: TextButton(
                  style: TextButton.styleFrom(
                    side: BorderSide(
                      color: HomeStyle(context: context).outline,
                      width: 1,
                    ), // Çerçeve rengi ve kalınlığı
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        8,
                      ), // Kenar yumuşaklığı (circular 8)
                    ),
                  ),
                  onPressed: () {},
                  child: customText(
                    "${_currentSellerProfil.saticiProfili?.profession ?? ''}",
                    context,
                    weight: FontWeight.bold,
                    size: HomeStyle(context: context).bodySmall.fontSize,
                  ),
                ),
              );
            }
            return SizedBox();
          },
        ),
        Builder(
          builder: (context) {
            if (widget.myProfile) {
              return RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    fontSize: HomeStyle(context: context).bodyMedium.fontSize,
                    color: HomeStyle(context: context).secondary,
                  ), // Varsayılan stil
                  children: [
                    TextSpan(text: 'Etiket adını değiştir'),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Icon(
                        size: 18,
                        Icons.arrow_forward_rounded,
                        color: HomeStyle(context: context).secondary,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return SizedBox(height: 16, width: 0);
            }
          },
        ),
      ],
    );
  }

  Column _isimVeBilgi(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: [
        customText(
          _currentSellerProfil.saticiProfili?.magazaAdi ?? 'NoName',
          context,
          weight: FontWeight.bold,
          size: HomeStyle(context: context).bodyLarge.fontSize,
        ),
        customText(
          'çiftçi / hayvan üreticisi',
          context,
          weight: FontWeight.w500,
          size: HomeStyle(context: context).bodySmall.fontSize,
        ),
        customText(
          'Türkiye / Aydın / akbük',
          context,
          weight: FontWeight.w300,
          size: HomeStyle(context: context).bodySmall.fontSize,
        ),
      ],
    );
  }

  Positioned _profilFoto(double width) {
    return Positioned(
      top: coverHeight - profileSize / 1.5,
      left: 20, // Ortalamak için
      child: Stack(
        children: [
          Container(
            width: profileSize,
            height: profileSize,
            decoration: BoxDecoration(
              borderRadius: AppRadius.r12,
              border: Border.all(color: Colors.white, width: 2),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: _selectedProfilFoto != null
                    ? FileImage(_selectedProfilFoto!) as ImageProvider
                    : NetworkImage(
                        _currentSellerProfil.profilFotograf?.isNotEmpty == true
                            ? _currentSellerProfil.profilFotograf!
                            : NotFound.defaultProfileImageUrl,
                      ),
              ),
            ),
          ),
          // Online durumu göstergesi (sağ alt köşe)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(
                color: _currentSellerProfil.isOnline
                    ? AppColors.succesful(context)
                    : AppColors.error(context),
                borderRadius: AppRadius.r8,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
          // Düzenle butonu (sol alt köşe - sadece kendi profiliyse)
          if (widget.myProfile)
            Positioned(
              bottom: 0,
              left: 0,
              child: GestureDetector(
                onTap: () {
                  debugPrint('Profil fotoğrafı düzenle butonuna tıklandı');
                  _pickImage(true);
                },
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.secondary(context),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.edit,
                    size: 16,
                    color: AppColors.secondary(context),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Container _kapakFoto(double width) {
    return Container(
      width: width,
      height: coverHeight,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: _selectedKapakFoto != null
              ? FileImage(_selectedKapakFoto!) as ImageProvider
              : NetworkImage(
                  _currentSellerProfil.saticiProfili?.profilBanner == null
                      ? NotFound.defaultBannerImageUrl
                      : _currentSellerProfil.saticiProfili?.profilBanner ?? '',
                ),
          onError: (exception, stackTrace) => Image.network(
            NotFound.defaultBannerImageUrl,
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
      child: widget.myProfile
          ? Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: GestureDetector(
                  onTap: () => _pickImage(false),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.edit, size: 20, color: Colors.white),
                  ),
                ),
              ),
            )
          : SizedBox.shrink(),
    );
  }
}
