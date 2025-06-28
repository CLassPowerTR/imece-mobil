part of '../cart_screen.dart';

class _CartViewBody extends StatefulWidget {
  const _CartViewBody({super.key});

  @override
  State<_CartViewBody> createState() => _CartViewBodyState();
}

class _CartViewBodyState extends State<_CartViewBody> {
  bool _confirm = false;
  bool isChecked = false; // "Tüm alışveriş koşullarını onaylıyorum" için
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _lateUseDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cartUserNameController = TextEditingController();
  final TextEditingController _cartNameController = TextEditingController();
  String ic_ticket =
      "https://www.google.com/imgres?q=ticket%20icon&imgurl=https%3A%2F%2Fwww.svgrepo.com%2Fshow%2F326845%2Fticket-outline.svg&imgrefurl=https%3A%2F%2Fwww.svgrepo.com%2Fsvg%2F326845%2Fticket-outline&docid=R1UztiKmlx_AWM&tbnid=lwM-D8NyGUByPM&vet=12ahUKEwjQ8oj37pOOAxUvSfEDHYGzJ8cQM3oECBsQAA..i&w=800&h=800&hcb=2&ved=2ahUKEwjQ8oj37pOOAxUvSfEDHYGzJ8cQM3oECBsQAA";
  String ic_map =
      "https://www.google.com/imgres?q=map%20icon&imgurl=https%3A%2F%2Fpics.freeicons.io%2Fuploads%2Ficons%2Fpng%2F9143113441535956911-512.png&imgrefurl=https%3A%2F%2Ffreeicons.io%2Fdaily-use-and-life-style-icons%2Fmap-google%2520map-location-icon-1378&docid=ZDNuCXzNEhVl4M&tbnid=H3IKUVZ_YzUhaM&vet=12ahUKEwjMsYOK75OOAxWuVPEDHecfL3QQM3oECGcQAA..i&w=512&h=512&hcb=2&ved=2ahUKEwjMsYOK75OOAxWuVPEDHecfL3QQM3oECGcQAA";
  String ic_truck =
      "https://www.google.com/imgres?q=truck%20icon&imgurl=https%3A%2F%2Fwww.iconpacks.net%2Ficons%2F1%2Ffree-truck-icon-1058-thumb.png&imgrefurl=https%3A%2F%2Fwww.iconpacks.net%2Ffree-icon%2Ftruck-1058.html&docid=bizg7D8mL6GfRM&tbnid=uMWDGHndW9MY0M&vet=12ahUKEwi849ud75OOAxVdQ_EDHVMTN6cQM3oECGcQAA..i&w=512&h=512&hcb=2&ved=2ahUKEwi849ud75OOAxVdQ_EDHVMTN6cQM3oECGcQAA";
  String ic_mandalina =
      "https://www.google.com/imgres?q=mandalina%20icon&imgurl=https%3A%2F%2Fw7.pngwing.com%2Fpngs%2F336%2F120%2Fpng-transparent-mandarin-orange-tangerine-tangerine-orange-citrus-logo.png&imgrefurl=https%3A%2F%2Fwww.pngwing.com%2Ftr%2Ffree-png-zutdb&docid=B9CeoLM85ovNxM&tbnid=TVIincIwlMg4NM&vet=12ahUKEwifqt-x75OOAxWDQvEDHX1dMFQQM3oECH4QAA..i&w=920&h=598&hcb=2&itg=1&ved=2ahUKEwifqt-x75OOAxWDQvEDHX1dMFQQM3oECH4QAA";
  String ic_visacard =
      "https://www.google.com/imgres?q=visa%20icon&imgurl=https%3A%2F%2Fupload.wikimedia.org%2Fwikipedia%2Fcommons%2Fthumb%2F5%2F5e%2FVisa_Inc._logo.svg%2F2560px-Visa_Inc._logo.svg.png&imgrefurl=https%3A%2F%2Ftr.m.wikipedia.org%2Fwiki%2FDosya%3AVisa_Inc._logo.svg&docid=bMWGx7rZzuufMM&tbnid=HJwGCYTXeIHnwM&vet=12ahUKEwjrquzK75OOAxVRHBAIHVmjLuQQM3oECGQQAA..i&w=2560&h=829&hcb=2&ved=2ahUKEwjrquzK75OOAxVRHBAIHVmjLuQQM3oECGQQAA";
  String ic_mastercard =
      "https://www.google.com/imgres?q=mastercard%20icon&imgurl=https%3A%2F%2Fupload.wikimedia.org%2Fwikipedia%2Fcommons%2Fthumb%2Fb%2Fb7%2FMasterCard_Logo.svg%2F1280px-MasterCard_Logo.svg.png&imgrefurl=https%3A%2F%2Ftr.m.wikipedia.org%2Fwiki%2FDosya%3AMasterCard_Logo.svg&docid=-f50CVIx2-IFJM&tbnid=AqW71AenfQzC2M&vet=12ahUKEwjTqsja75OOAxXjBtsEHRcHOecQM3oECGUQAA..i&w=1280&h=768&hcb=2&ved=2ahUKEwjTqsja75OOAxXjBtsEHRcHOecQM3oECGUQAA";
  String ic_ziraatBank =
      "https://www.google.com/imgres?q=ziraat%20bank%20icon&imgurl=https%3A%2F%2Fw7.pngwing.com%2Fpngs%2F12%2F951%2Fpng-transparent-ziraat-bankas%25C4%25B1-turkiye-%25C4%25B0%25C5%259F-bankas%25C4%25B1-credit-turkey-bank-text-payment-logo-thumbnail.png&imgrefurl=https%3A%2F%2Fwww.pngwing.com%2Fen%2Fsearch%3Fq%3Dziraat%2BBankas%25C4%25B1&docid=dbQLdlvVAvUm4M&tbnid=5qRUTt0xEYJ_WM&vet=12ahUKEwiM76n38JOOAxVsXvEDHQ0lMHwQM3oECFcQAA..i&w=360&h=156&hcb=2&ved=2ahUKEwiM76n38JOOAxVsXvEDHQ0lMHwQM3oECFcQAA";
  String ic_addProduct =
      "https://www.google.com/imgres?q=add%20product%20icon&imgurl=https%3A%2F%2Fcdn-icons-png.flaticon.com%2F512%2F7387%2F7387315.png&imgrefurl=https%3A%2F%2Fwww.flaticon.com%2Ffree-icon%2Fadd-product_7387315&docid=3kI8IsrBfWJUwM&tbnid=fBsrgdgr-3F1wM&vet=12ahUKEwjspZ3j8JOOAxXGVPEDHWTQH5wQM3oECGwQAA..i&w=512&h=512&hcb=2&ved=2ahUKEwjspZ3j8JOOAxXGVPEDHWTQH5wQM3oECGwQAA";

  int urunKg = 11;
  late Future<Map<String, dynamic>> _sepetFuture;
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
      child: SingleChildScrollView(
        child: Column(children: [
          container(context,
              color: themeData.surfaceContainer,
              width: width,
              isBoxShadow: true,
              margin: EdgeInsets.all(8),
              borderRadius: BorderRadius.circular(8),
              child: Column(
                children: [
                  _siparisKonum(context),
                  _teslimatBilgi(context, themeData),
                ],
              )),
          _sepettekiUrunler(themeData, width),
          _fiyatDetay(themeData, width),
          _odemeSecenegi(context, themeData, width),
          _satinAlim(context, themeData),
          // Sepetteki ürünleri çekmek için örnek FutureBuilder

          SizedBox(
            height: height * 0.15,
          )
        ]),
      ),
    );
  }

  FutureBuilder<Map<String, dynamic>> _sepetItemsGet(context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _sepetFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showTemporarySnackBar(context, snapshot.error.toString());
          });
          return Text('Sepet verisi alınamadı.');
        } else if (snapshot.hasData) {
          final data = snapshot.data!;
          if (data['durum'] == 'SEPET_DOLU' && data['sepet'] is List) {
            final sepetList = data['sepet'] as List;
            // Sepet dolu ise, ürünleri listele
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sepetinizdeki Ürünler:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...sepetList.map<Widget>((item) {
                  return FutureBuilder<Product>(
                    future: ApiService.fetchProduct(item['urun']),
                    builder: (context, productSnapshot) {
                      if (productSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (productSnapshot.hasError) {
                        return Text(
                            'Ürün verisi alınamadı: \\${productSnapshot.error}');
                      } else if (productSnapshot.hasData) {
                        final product = productSnapshot.data!;
                        return SepetProductsCard(
                          product: product,
                          item: item,
                          context: context,
                        );
                      } else {
                        return Text('Ürün verisi bulunamadı.');
                      }
                    },
                  );
                }).toList(),
              ],
            );
          } else if (data['durum'] == 'BOS_SEPET') {
            return Text(data['mesaj'] ?? 'Sepetinizde ürün bulunmamaktadır.');
          } else {
            return Text('Bilinmeyen sepet durumu.');
          }
        } else {
          return Text('Sepet verisi bulunamadı.');
        }
      },
    );
  }

  Row _sepetRefreshButton() {
    return Row(
      children: [
        ElevatedButton(
          onPressed: _fetchSepet,
          child: Text('Sepeti Yenile'),
        ),
      ],
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
                        TextSpan(text: '${urunKg * 36} TL')
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
              Image.network(ic_ticket, width: 45, height: 45),
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
      child: Column(
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
                    text: '1 Adet',
                    style: TextStyle(fontWeight: FontWeight.w400)),
                TextSpan(text: '\n\n', style: TextStyle(fontSize: 8)),
                TextSpan(text: 'Ürünlerin Tutarı: '),
                TextSpan(
                    text: '${urunKg * 36 - 20} TL',
                    style: TextStyle(fontWeight: FontWeight.w400)),
                TextSpan(text: '\n\n', style: TextStyle(fontSize: 8)),
                TextSpan(text: 'Taşıma Ücreti: '),
                TextSpan(
                    text: '20 TL',
                    style: TextStyle(fontWeight: FontWeight.w400)),
                TextSpan(text: '\n\n', style: TextStyle(fontSize: 8)),
                TextSpan(text: 'Toplam: '),
                TextSpan(
                    text: '${urunKg * 36} TL ',
                    style: TextStyle(fontWeight: FontWeight.w400)),
                TextSpan(
                    text: '(ek ücretler ve vergiler dahil)',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: themeData.primary.withOpacity(0.5)))
              ]),
        ],
      ),
    );
  }

  Container _sepettekiUrunler(themeData, width) {
    return container(
      context,
      color: themeData.surfaceContainer,
      borderRadius: BorderRadius.circular(8),
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
      child: Column(
        spacing: 10,
        children: [
          _sepetRefreshButton(),
          //_sepetUrunleriContainer(themeData),
          _sepetItemsGet(context),
          textButton(
            context,
            '+ Ürün ekle',
            elevation: 6,
            shadowColor: themeData.secondary,
            fontSize: themeData.bodyLarge.fontSize,
            weight: FontWeight.bold,
            onPressed: () {
              setState(() {});
            },
          )
        ],
      ),
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
              Image.network(ic_mandalina),
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
                        text: '\n09 / 01 / 2025',
                        style: TextStyle(
                          color: Color.fromARGB(255, 34, 255, 34),
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                          decoration: TextDecoration.underline,
                          decorationStyle: TextDecorationStyle.solid,
                          decorationColor: Color.fromARGB(255, 34, 255, 34),
                        ),
                      ),
                      TextSpan(text: '(2 gün sonra)'),
                      TextSpan(text: '\nTeslimat zamanı değişebilir!')
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
}
