part of '../cart_screen.dart';

class _CartViewBody extends ConsumerStatefulWidget {
  const _CartViewBody({super.key});

  @override
  ConsumerState<_CartViewBody> createState() => _CartViewBodyState();
}

class _CartViewBodyState extends ConsumerState<_CartViewBody> {
  bool _confirm = false;
  bool isChecked = false; // "Tüm alışveriş koşullarını onaylıyorum" için
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _lateUseDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cartUserNameController = TextEditingController();
  final TextEditingController _cartNameController = TextEditingController();
  String ic_ticket = "https://www.svgrepo.com/show/326845/ticket-outline.svg";
  String ic_map =
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTHOfhJtpdasljGl-I0rWdz9xXqTRs9VK9qWMknPuaqOBlN6B3mxzou34HEu8hXbWlrlmg&usqp=CAU";
  String ic_truck =
      "https://static.vecteezy.com/system/resources/thumbnails/018/892/481/small_2x/truck-car-flat-icon-png.png";
  String ic_visacard =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Visa_Inc._logo.svg/2560px-Visa_Inc._logo.svg.png";
  String ic_mastercard =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b7/MasterCard_Logo.svg/1280px-MasterCard_Logo.svg.png";
  String ic_ziraatBank =
      "https://w7.pngwing.com/pngs/12/951/png-transparent-ziraat-bankas%C4%B1-turkiye-%C4%B0%C5%9F-bankas%C4%B1-credit-turkey-bank-text-payment-logo-thumbnail.png";
  String ic_addProduct =
      "https://cdn-icons-png.flaticon.com/512/7387/7387315.png";

  static Map<String, dynamic> sepetInfo = {};

  int urunKg = 11;
  late Future<Map<String, dynamic>> _sepetFuture;
  late Future<User> _sellerProfileFuture;
  final storage = FlutterSecureStorage();
  String? cardNumber;
  String? lateDate;
  String? cvv;
  String? cartUserName;
  String? cartName;

  FocusNode _focusNode = FocusNode();
  String? selectedCard = "Visa Card";
  String? selectedIban = "İban";
  TextEditingController couponController =
      TextEditingController(text: '000000');
  late Future<Map<String, dynamic>> _sepetInfoFuture;

  @override
  void initState() {
    super.initState();
    // Focus değişimlerini dinleyerek UI'nın güncellenmesini sağlıyoruz
    _focusNode.addListener(() {
      setState(() {});
    });
    _loadCardInfo();
    _fetchSepet();
  }

  // Otomatik ve manuel yenileme için fonksiyon
  void _fetchSepet() {
    setState(() {
      _sepetFuture = ApiService.fetchSepetGet();
      _sepetInfoFuture = ApiService.fetchSepetInfo();
    });
  }

  Future<void> _loadCardInfo() async {
    String? storedCardNumber = await storage.read(key: 'cardNumber');
    String? storedLateDate = await storage.read(key: 'lateDate');
    String? storedCvv = await storage.read(key: 'cvv');
    String? storedcartUserName = await storage.read(key: 'cartUserName');
    String? storedcartName = await storage.read(key: 'cartName');

    setState(() {
      cardNumber = storedCardNumber;
      lateDate = storedLateDate;
      cvv = storedCvv;
      cartUserName = storedcartUserName;
      cartName = storedcartName;
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = HomeStyle(context: context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: _getSepetItems(themeData, width, height),
    );
  }

  FutureBuilder<Map<String, dynamic>> _getSepetItems(
      HomeStyle themeData, double width, double height) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _sepetFuture,
      builder: (context, snapshot) {
        bool isLoading = snapshot.connectionState == ConnectionState.waiting;

        if (snapshot.hasError) {
          final errorText = snapshot.error?.toString() ?? '';
          if (errorText.contains('Unauthorized')) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('accesToken');
              await prefs.remove('refreshToken');
            });
            return _isNotLoggin(context, ref);
          } else {
            return Center(child: Text('Hata: $errorText'));
          }
        } else if (!snapshot.hasData) {
          return Scaffold(body: buildLoadingBar(context));
        } else {
          final data = snapshot.data!;
          final durum = data['durum'];
          if (durum == 'BOS_SEPET') {
            return Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Column(
                  spacing: 10,
                  children: [
                    Text(data['mesaj'] ?? 'Sepetinizde ürün yok.'),
                    _urunEkleButton(themeData),
                  ],
                ),
              ),
            );
          } else {
            final sepetList = data['sepet'] as List?;
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      container(
                        context,
                        color: themeData.surfaceContainer,
                        width: width,
                        isBoxShadow: true,
                        margin: EdgeInsets.all(8),
                        borderRadius: BorderRadius.circular(8),
                        child: Column(
                          children: [
                            _FutureFetchUserAdress(),
                            _teslimatBilgi(context, themeData),
                          ],
                        ),
                      ),
                      if (sepetList != null && sepetList.isNotEmpty)
                        container(
                          context,
                          color: themeData.surfaceContainer,
                          borderRadius: BorderRadius.circular(8),
                          margin: EdgeInsets.all(8),
                          padding:
                              EdgeInsets.only(left: 12, right: 12, bottom: 12),
                          child: Column(
                            spacing: 10,
                            children: [
                              Text('Sepetinizdeki Ürünler:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              ...(() {
                                final sortedList =
                                    List<Map<String, dynamic>>.from(sepetList);
                                sortedList.sort((a, b) => (a['urun'] as int)
                                    .compareTo(b['urun'] as int));
                                return sortedList.map<Widget>((item) {
                                  return FutureBuilder<Product>(
                                    future:
                                        ApiService.fetchProduct(item['urun']),
                                    builder: (context, productSnapshot) {
                                      if (productSnapshot.hasError) {
                                        return Text(
                                            'Ürün verisi alınamadı: ${productSnapshot.error}');
                                      } else if (productSnapshot.hasData) {
                                        final product = productSnapshot.data!;
                                        return FutureBuilder<User>(
                                          future: ApiService.fetchUserId(
                                              product.satici),
                                          builder: (context, sellerSnapshot) {
                                            if (sellerSnapshot.hasError) {
                                              return Text(
                                                  'Satıcı verisi alınamadı: ${sellerSnapshot.error}');
                                            } else if (sellerSnapshot.hasData) {
                                              final seller =
                                                  sellerSnapshot.data!;
                                              return SepetProductsCard(
                                                sellerProfile: seller,
                                                product: product,
                                                item: item,
                                                context: context,
                                                removeCart: () {
                                                  setState(() async {
                                                    try {
                                                      await ApiService
                                                          .fetchSepetEkle(
                                                              item['miktar'] -
                                                                  1,
                                                              product.urunId!);
                                                    } catch (e) {
                                                      showTemporarySnackBar(
                                                          context,
                                                          e.toString());
                                                    } finally {
                                                      setState(() {
                                                        _fetchSepet();
                                                      });
                                                    }
                                                  });
                                                },
                                                updateCart: () {
                                                  setState(() async {
                                                    try {
                                                      await ApiService
                                                          .fetchSepetEkle(
                                                              item['miktar'] +
                                                                  1,
                                                              product.urunId!);
                                                    } catch (e) {
                                                      showTemporarySnackBar(
                                                          context,
                                                          e.toString());
                                                    } finally {
                                                      setState(() {
                                                        _fetchSepet();
                                                      });
                                                    }
                                                  });
                                                },
                                                deleteFromCart: () {
                                                  setState(() async {
                                                    try {
                                                      await ApiService
                                                          .fetchSepetEkle(0,
                                                              product.urunId!);
                                                    } catch (e) {
                                                      showTemporarySnackBar(
                                                          context,
                                                          e.toString());
                                                    } finally {
                                                      setState(() {
                                                        _fetchSepet();
                                                      });
                                                    }
                                                  });
                                                },
                                              );
                                            } else {
                                              return Center(
                                                  child:
                                                      buildLoadingBar(context));
                                            }
                                          },
                                        );
                                      } else {
                                        return Center(
                                            child: buildLoadingBar(context));
                                      }
                                    },
                                  );
                                }).toList();
                              })(),
                              textButton(
                                context,
                                '+ Ürün ekle',
                                elevation: 6,
                                shadowColor: themeData.secondary,
                                fontSize: themeData.bodyLarge.fontSize,
                                weight: FontWeight.bold,
                                onPressed: () {
                                  setState(() {
                                    ref
                                        .read(bottomNavIndexProvider.notifier)
                                        .state = 1;
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/home',
                                      (route) => false,
                                      arguments: {'refresh': true},
                                    );
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      _fiyatDetay(themeData, width),
                      _odemeSecenegi(context, themeData, width),
                      _satinAlim(context, themeData),
                      SizedBox(height: height * 0.15),
                    ],
                  ),
                ),
                if (isLoading)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                      child: Center(
                        child: buildLoadingBar(context),
                      ),
                    ),
                  ),
              ],
            );
          }
        }
      },
    );
  }

  Container _satinAlim(BuildContext context, HomeStyle themeData) {
    return container(context,
        color: themeData.surfaceContainer,
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Satın alım koşullarını onaylıyorum",
                  style: TextStyle(fontSize: 15),
                ),
                Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    side: BorderSide(
                      color: Color.fromARGB(
                          255, 34, 255, 34), // Dış çizginin rengi
                      width: 2, // Dış çizginin kalınlığı
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          4), // Köşeleri yuvarlak yapmak için
                    ),

                    value: _confirm,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _confirm = newValue ?? false;
                      });
                    },
                    activeColor:
                        Color.fromARGB(255, 34, 255, 34), // Seçildiğinde rengi
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: richText(context,
                      fontSize: themeData.bodyLarge.fontSize,
                      textAlign: TextAlign.left,
                      children: [
                        TextSpan(
                            text: 'Total Ücret: ',
                            style: TextStyle(fontWeight: FontWeight.w900)),
                        TextSpan(text: '${sepetInfo['toplam_tutar']} TL')
                      ]),
                ),
                Expanded(
                    child: textButton(context, 'Satın Al',
                        fontSize: themeData.bodyLarge.fontSize,
                        weight: FontWeight.bold,
                        elevation: 6,
                        shadowColor: themeData.secondary))
              ],
            )
          ],
        ));
  }

  Container _odemeSecenegi(BuildContext context, themeData, width) {
    return container(
      context,
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(8),
      color: themeData.surfaceContainer,
      width: width,
      isBoxShadow: true,
      child: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ödeme için Kart Seç',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
          Container(
            //height: MediaQuery.of(context).size.height * 0.06,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey),
            ),
            child: DropdownButtonFormField<String>(
              alignment: Alignment.centerLeft,
              borderRadius: BorderRadius.circular(5),
              dropdownColor: Colors.white,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                border: InputBorder.none,
              ),
              value: selectedCard,
              isExpanded: true,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCard = newValue;
                });
              },
              items: [
                DropdownMenuItem(
                  value: 'Visa Card',
                  child: Row(
                    children: [
                      Image.network(ic_visacard, width: 24, height: 24),
                      SizedBox(width: 8),
                      Text(
                        'Visa Card',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'Master Card',
                  child: Row(
                    children: [
                      Image.network(ic_mastercard, width: 24, height: 24),
                      SizedBox(width: 8),
                      Text(
                        'Master Card',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'Troy Card',
                  child: Row(
                    children: [
                      Image.network(
                          'https://image.troyodeme.com//File/troy-acilim.png',
                          width: 24,
                          height: 24),
                      SizedBox(width: 8),
                      Text(
                        'Troy Card',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'İban',
                  child: Row(
                    children: [
                      Image.network(ic_ziraatBank, width: 18, height: 18),
                      SizedBox(width: 8),
                      Text(
                        'İban',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3),
          Text(
            'Kupon veya İndirim kodu gir',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          Row(
            spacing: 10,
            children: [
              Icon(Icons.discount_outlined, size: 20),
              Expanded(
                child: SizedBox(
                  height: 45,
                  child: TextField(
                    focusNode: _focusNode,
                    textAlign: TextAlign.left,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: 16,
                      ),
                      border: OutlineInputBorder(),
                      hintText: _focusNode.hasFocus ? '' : '0000000',
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 8),
          Builder(builder: (context) {
            if (cardNumber != null) {
              return Container(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      Navigator.pushNamed(
                        context,
                        '/cart/addCreditCart',
                        arguments: {
                          'cardNumber': cardNumber,
                          'lateUseDate': lateDate,
                          'cvv': cvv,
                          'cartUserName': cartUserName,
                          'cartName': cartName,
                        },
                      );
                    });
                  },
                  child: CreditCardUi(
                    cardHolderFullName: cartUserName ?? '',
                    cardNumber: cardNumber ?? '',
                    validFrom: '00/00',
                    validThru: lateDate ?? '00/00',
                    topLeftColor: Colors.blue,
                    doesSupportNfc: true,
                    placeNfcIconAtTheEnd: true,
                    bottomRightColor: Colors.purple,

                    cardType: CardType.debit,
                    //cardProviderLogo: FlutterLogo(),
                    cardProviderLogoPosition: CardProviderLogoPosition.right,
                    autoHideBalance: true,
                    enableFlipping: true, // 👈 Enables the flipping
                    cvvNumber: cvv ??
                        '000', // 👈 CVV number to be shown on the back of the card
                  ),
                ),
              );
            } else {
              return SizedBox();
            }
          }),
          textButton(
            context,
            'Kart Ekle',
            elevation: 6,
            fontSize: themeData.bodyLarge.fontSize,
            weight: FontWeight.bold,
            shadowColor: themeData.secondary,
            onPressed: () {
              setState(() {
                showTemporarySnackBar(context, 'Kart Ekle Buton (){onPressed}');
                Navigator.pushNamed(
                  context,
                  '/cart/addCreditCart',
                  arguments: {
                    'cardNumber': _cardNumberController.text,
                    'lateUseDate': _lateUseDateController.text,
                    'cvv': _cvvController.text,
                    'cartUserName': _cartUserNameController.text,
                    'cartName': _cartNameController.text,
                  },
                );
              });
            },
          )
        ],
      ),
    );
  }

  Container _fiyatDetay(themeData, width) {
    return container(
      context,
      color: themeData.surfaceContainer,
      width: width,
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      child: FutureBuilder<Map<String, dynamic>>(
          future: _sepetInfoFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Hata: ${snapshot.error}'));
            }
            if (snapshot.hasData) {
              final data = snapshot.data!;
              sepetInfo = data;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  richText(context,
                      fontWeight: FontWeight.w800,
                      fontSize: themeData.bodyMedium.fontSize,
                      textAlign: TextAlign.left,
                      children: [
                        TextSpan(
                            text: 'Ara Toplam',
                            style: TextStyle(
                              fontSize: themeData.bodyLarge.fontSize,
                            )),
                        TextSpan(text: '\n\n', style: TextStyle(fontSize: 15)),
                        TextSpan(text: 'Satın Alınan farklı ürün sayısı: '),
                        TextSpan(
                            text: '${data['adet']} Adet',
                            style: TextStyle(fontWeight: FontWeight.w400)),
                        TextSpan(text: '\n\n', style: TextStyle(fontSize: 8)),
                        TextSpan(text: 'Ürünlerin Tutarı: '),
                        TextSpan(
                            text: '${data['urun_toplam_tutari']} TL',
                            style: TextStyle(fontWeight: FontWeight.w400)),
                        TextSpan(text: '\n\n', style: TextStyle(fontSize: 8)),
                        TextSpan(text: 'Taşıma Ücreti: '),
                        TextSpan(
                            text: '${data['tasima_ucreti']} TL',
                            style: TextStyle(fontWeight: FontWeight.w400)),
                        TextSpan(text: '\n\n', style: TextStyle(fontSize: 8)),
                        TextSpan(text: 'Toplam: '),
                        TextSpan(
                            text: '${data['toplam_tutar']} TL ',
                            style: TextStyle(fontWeight: FontWeight.w400)),
                        TextSpan(
                            text: '(ek ücretler ve vergiler dahil)',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: themeData.primary.withOpacity(0.5))),
                        TextSpan(text: '\n\n', style: TextStyle(fontSize: 8)),
                        TextSpan(
                          text: 'Son Teslim Tarihi: ',
                        ),
                        TextSpan(
                            text: '${data['son_teslimat_tarihi']}',
                            style: TextStyle(fontWeight: FontWeight.w400)),
                      ]),
                ],
              );
            }
            return SizedBox();
          }),
    );
  }

  SizedBox _urunEkleButton(themeData) {
    return textButton(
      context,
      '+ Ürün ekle',
      elevation: 6,
      shadowColor: themeData.secondary,
      fontSize: themeData.bodyLarge.fontSize,
      weight: FontWeight.bold,
      onPressed: () {
        setState(() {
          ref.read(bottomNavIndexProvider.notifier).state = 1;
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false,
              arguments: {'refresh': true});
        });
      },
    );
  }

  Container _sepetUrunleriContainer(themeData) {
    return container(
      context,
      color: themeData.surfaceContainer,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 4),
      borderRadius: BorderRadius.circular(8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 8,
            children: [
              Image.network(
                'https://st4.depositphotos.com/16122460/38897/i/450/depositphotos_388975100-stock-photo-delicious-fresh-ripe-tangerines-background.jpg',
                width: 100,
                height: 100,
              ),
              Expanded(
                child: richText(context,
                    maxLines: 6,
                    color: themeData.primary,
                    textAlign: TextAlign.left,
                    children: [
                      TextSpan(
                          text: 'Turuncu Mandalina',
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              fontSize: themeData.bodyLarge.fontSize)),
                      TextSpan(
                          text: '\nTatlı, Sulu, Turuncu, mandalina, turunçgil',
                          style: TextStyle(
                            fontSize: themeData.bodyMedium.fontSize,
                            overflow: TextOverflow.ellipsis,
                          )),
                      TextSpan(
                          text: '\n\nMuhammet Yusuf Akar',
                          style: TextStyle(
                              fontSize: themeData.bodySmall.fontSize)),
                    ]),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red,
                  )),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Row(
              spacing: 10,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // İsteğe bağlı arka plan rengi
                    borderRadius:
                        BorderRadius.circular(5), // Köşe yuvarlaklığı 5
                    border: Border.all(
                        width: 1,
                        color:
                            themeData.outline), // İnce bir kenarlık (opsiyonel)
                  ),
                  child: Row(
                    children: [
                      // Sol tarafta "11 KG" yazısı
                      Text(
                        urunKg.toString() + ' KG',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // Sağ tarafta - ve + butonları
                      Row(
                        children: [
                          // "-" butonu
                          IconButton(
                            icon: Icon(
                              Icons.remove,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                urunKg -= 1;
                              });
                            },
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            iconSize: 20,
                          ),
                          // "+" butonu
                          Container(
                            color: Colors.black,
                            height: 20,
                            width: 1,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              setState(() {
                                urunKg += 1;
                              });
                            },
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            iconSize: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: richText(
                      textAlign: TextAlign.left,
                      fontSize: themeData.bodyMedium.fontSize,
                      context,
                      children: [
                        TextSpan(
                            text: '1KG: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: ' 36 TL',
                        ),
                        TextSpan(
                            text: '\nMaks. KG: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: ' 56')
                      ]),
                ),
                Expanded(
                  child: richText(
                      fontSize: themeData.bodyMedium.fontSize,
                      textAlign: TextAlign.center,
                      context,
                      children: [
                        TextSpan(
                            text: 'Ürün Tutarı',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: '\n${urunKg * 36} TL')
                      ]),
                ),
              ],
            ),
          ),
          //Divider(),
        ],
      ),
    );
  }

  Container _bosluk(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.03,
      color: Colors.grey[100],
    );
  }

  Container _teslimatBilgi(BuildContext context, themeData) {
    String? teslimatTarihiStr =
        sepetInfo['son_teslimat_tarihi'] != null && sepetInfo.isNotEmpty
            ? sepetInfo['son_teslimat_tarihi']
            : null;
    String gunFarkiText = '';
    if (teslimatTarihiStr != null && teslimatTarihiStr.isNotEmpty) {
      try {
        DateTime bugun = DateTime.now();
        DateTime teslimatTarihi = DateTime.parse(teslimatTarihiStr);
        int gunFarki = teslimatTarihi.difference(bugun).inDays;
        if (gunFarki >= 0) {
          gunFarkiText = '($gunFarki gün sonra)';
        } else {
          gunFarkiText = 'Teslimat tarihi geçti';
        }
      } catch (e) {
        gunFarkiText = 'Tarih formatı hatalı';
      }
    } else {
      gunFarkiText = 'Henüz Belirli Değil!';
    }
    return container(
      context,
      color: themeData.surfaceContainer,
      isBoxShadow: false,
      margin: EdgeInsets.all(20),
      child: Row(
        spacing: 10,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.25,
            margin: EdgeInsets.only(left: 10),
            child: Image.network(ic_truck),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                richText(context,
                    textAlign: TextAlign.left,
                    fontSize: themeData.bodyMedium.fontSize,
                    children: [
                      TextSpan(
                          text: 'Tahmini Teslimat Tarihi',
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 16)),
                      TextSpan(
                        text:
                            '\n${sepetInfo['son_teslimat_tarihi'] ?? 'Henüz Belirli Değil'}',
                        style: TextStyle(
                          color: Color.fromARGB(255, 34, 255, 34),
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                          decoration: TextDecoration.underline,
                          decorationStyle: TextDecorationStyle.solid,
                          decorationColor: Color.fromARGB(255, 34, 255, 34),
                        ),
                      ),
                      TextSpan(text: ' $gunFarkiText '),
                      TextSpan(text: '\nTeslimat zamanı değişebilir!'),
                      TextSpan(text: '\n${sepetInfo['adet']} Adet')
                    ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Card _siparisKonum(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: SizedBox(
              width: 100,
              height: 100,
              child: Image.network(ic_map),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(top: 30, left: 5),
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Türkiye / İstanbul',
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                    ),
                    Text(
                      'Çınar Mahallesi 878 sokak no 14 daire 1 İstanbul Bağcılar',
                      textAlign: TextAlign.left,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      margin: EdgeInsets.all(0),
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Konum bilgileri değiştir',
                            style: TextStyle(
                                color: Color.fromARGB(255, 34, 255, 34),
                                fontWeight: FontWeight.w900),
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  FutureBuilder<List<UserAdress>> _FutureFetchUserAdress() {
    final user = ref.watch(userProvider);
    return FutureBuilder<List<UserAdress>>(
      future: ApiService.fetchUserAdress(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: buildLoadingBar(context)),
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: Text('Adres verisi alınamadı.')),
          );
        } else if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: textButton(
              context,
              elevation: 0,
              "Adres Ekle",
              onPressed: () {
                Navigator.pushNamed(context, '/profil/adress',
                    arguments: {'buyerProfil': user});
              },
            ),
          );
        } else {
          final adresler = snapshot.data!;
          final hasVarsayilan =
              adresler.any((adres) => adres.varsayilanAdres == true);
          if (hasVarsayilan) {
            final varsayilanAdres =
                adresler.firstWhere((adres) => adres.varsayilanAdres == true);
            return AdressCardOrder(
              ilIlce: '${varsayilanAdres.il} / ${varsayilanAdres.ilce}',
              adres: varsayilanAdres.adresSatiri1,
              icMapUrl: ic_map,
              onLocationChange: () {
                // Konum değiştir fonksiyonu
              },
            );
          } else {
            // Varsayılan adres yok, ilk adresi göster ve buton ekle
            final ilkAdres = adresler.first;
            return Column(
              children: [
                AdressCardOrder(
                  ilIlce: '${ilkAdres.il} / ${ilkAdres.ilce}',
                  adres: ilkAdres.adresSatiri1,
                  icMapUrl: ic_map,
                  onLocationChange: () {
                    // Konum değiştir fonksiyonu
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: textButton(
                    context,
                    "Varsayılan adres olarak ayarla",
                    onPressed: () async {
                      await ApiService.updateUserAdress(
                        ilkAdres.id,
                        ilkAdres.ulke,
                        ilkAdres.il,
                        ilkAdres.ilce,
                        ilkAdres.mahalle,
                        ilkAdres.postaKodu,
                        ilkAdres.adresSatiri1,
                        ilkAdres.adresSatiri2,
                        ilkAdres.baslik,
                        ilkAdres.adresTipi,
                        true,
                        ilkAdres.kullanici,
                      );
                      setState(() {});
                    },
                  ),
                ),
              ],
            );
          }
        }
      },
    );
  }
}
