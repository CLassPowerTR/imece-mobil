part of '../add_product_screen.dart';

class AddProductViewBody extends ConsumerStatefulWidget {
  final User profileName;
  final Product? product;

  const AddProductViewBody({
    super.key,
    required this.profileName,
    this.product,
  });

  @override
  ConsumerState<AddProductViewBody> createState() => _AddProductViewBodyState();
}

class _AddProductViewBodyState extends ConsumerState<AddProductViewBody> {
  final TextEditingController _controllerUrunAdi = TextEditingController();
  final TextEditingController _controllerUrunAciklama = TextEditingController();
  final TextEditingController _controllerUrunMiktari = TextEditingController();
  final TextEditingController _controllerUrunFiyati = TextEditingController();
  final TextEditingController _controllerMinFiyati = TextEditingController();
  String urunFiyatiKDV = '';
  int activeStep = 0;
  bool isNextButtonFirst = false;
  bool isNextButtonSecond = false;
  bool isNextButtonThird = false;
  int? selectedUrunTipiIndex;
  // Varsayılan değerler; seçilmediğinde null gösterip hint ile "Saat"/"Dakika" yazdıracağız.
  String? selectedHour;
  String? selectedMinute;

  // Saatler 0-24 arası, dakikalar 0-60 arası string listesi oluşturulur.
  final List<String> hourItems = List.generate(25, (index) => index.toString());
  final List<String> minuteItems = List.generate(
    61,
    (index) => index.toString(),
  );
  // Sertifika/Lab PDF dosyaları
  String? urunSertifikaPdfName;
  String? urunLabSonucPdfName;
  PlatformFile? _kapakGorselFile;
  Uint8List? _kapakGorselPreviewBytes;
  // Mevcut ürün görselleri (URL'ler)
  String? _existingKapakGorselUrl;
  String? _existingSertifikaPdfUrl;
  String? _existingLabSonucPdfUrl;

  // Kategori veri kümesi
  static const List<Map<String, Object>> kategoriler = [
    {'ad': 'Meyveler', 'kategori': 1},
    {'ad': 'Sebzeler', 'kategori': 2},
    {'ad': 'Elektronik', 'kategori': 3},
    {'ad': 'Moda ve Giyim', 'kategori': 4},
    {'ad': 'Ev ve Yaşam', 'kategori': 5},
    {'ad': 'Kozmetik ve Kişisel Bakım', 'kategori': 6},
    {'ad': 'Spor ve Outdoor', 'kategori': 7},
    {'ad': 'Anne & Bebek Ürünleri', 'kategori': 8},
    {'ad': 'Kitap, Film, Müzik ve Hobi', 'kategori': 9},
    {'ad': 'Otomobil ve Motosiklet', 'kategori': 10},
    {'ad': 'Süpermarket & Gıda', 'kategori': 11},
    {'ad': 'Pet Shop (Evcil Hayvan Ürünleri)', 'kategori': 12},
    {'ad': 'Sağlık ve Medikal Ürünler', 'kategori': 13},
  ];

  static const Map<String, List<String>> altKategoriler = {
    'Meyveler': ['Elma', 'Muz', 'Portakal'],
    'Sebzeler': ['Domates', 'Salatalık', 'Patlıcan'],
    'Elektronik': ['Telefon', 'Bilgisayar', 'Televizyon'],
    'Moda ve Giyim': ['Kadın Giyim', 'Erkek Giyim', 'Aksesuar'],
    'Ev ve Yaşam': ['Mobilya', 'Dekorasyon', 'Aydınlatma'],
    'Kozmetik ve Kişisel Bakım': ['Makyaj', 'Cilt Bakımı', 'Parfüm'],
    'Spor ve Outdoor': ['Fitness', 'Kamp Malzemeleri', 'Bisiklet'],
    'Anne & Bebek Ürünleri': ['Bebek Bezi', 'Oyuncaklar', 'Bebek Giyim'],
    'Kitap, Film, Müzik ve Hobi': ['Kitap', 'Müzik Aletleri', 'Puzzle'],
    'Otomobil ve Motosiklet': ['Oto Aksesuar', 'Lastik', 'Motor Parçaları'],
    'Süpermarket & Gıda': ['Kuru Gıdalar', 'İçecekler', 'Atıştırmalıklar'],
    'Pet Shop (Evcil Hayvan Ürünleri)': [
      'Kedi Maması',
      'Köpek Oyuncakları',
      'Kuş Kafesi',
    ],
    'Sağlık ve Medikal Ürünler': [
      'Tansiyon Aleti',
      'Medikal Cihazlar',
      'Vitaminler',
    ],
  };

  String? selectedCategoryName;
  String? selectedSubcategoryName;

  int? get selectedSatisTuru => selectedUrunTipiIndex == null
      ? null
      : (selectedUrunTipiIndex == 0 ? 1 : 2);

  @override
  void initState() {
    super.initState();
    // Eğer product varsa, form alanlarını doldur
    if (widget.product != null) {
      _initializeFromProduct(widget.product!);
    }
    // Her controller'a aynı doğrulama fonksiyonunu ekliyoruz.
    _controllerUrunAdi.addListener(_validateFormFirst);
    _controllerUrunAciklama.addListener(_validateFormFirst);
    _controllerUrunMiktari.addListener(_validateFormSecond);
    _controllerUrunFiyati.addListener(_validateFormSecond);
    _controllerMinFiyati.addListener(_validateFormSecond);
  }

  void _initializeFromProduct(Product product) {
    _controllerUrunAdi.text = product.urunAdi ?? '';
    _controllerUrunAciklama.text = product.aciklama ?? '';
    _controllerUrunMiktari.text = product.stokDurumu?.toString() ?? '';
    _controllerUrunFiyati.text = product.urunParakendeFiyat ?? '';
    _controllerMinFiyati.text = product.urunMinFiyat ?? '';

    // Satış türü
    if (product.satis_turu != null) {
      selectedUrunTipiIndex = product.satis_turu == 1 ? 0 : 1;
    }

    // Kategori - Product'ta kategori ID var, isim bulmamız gerekiyor
    if (product.kategori != null) {
      final categoryMap = kategoriler.firstWhere(
        (cat) => cat['kategori'] == product.kategori,
        orElse: () => const {'ad': '', 'kategori': 0},
      );
      if (categoryMap['ad'] != '') {
        selectedCategoryName = categoryMap['ad'] as String;
        // Alt kategori için de bir şey yapabiliriz ama Product'ta yok
      }
    }

    // PDF dosya isimleri ve URL'leri
    urunSertifikaPdfName = product.urunSertifikaPdf;
    urunLabSonucPdfName = product.labSonucPdf;
    _existingSertifikaPdfUrl = product.urunSertifikaPdf;
    _existingLabSonucPdfUrl = product.labSonucPdf;

    // Kapak görseli - URL'den yüklenebilir
    if (product.kapakGorseli != null && product.kapakGorseli!.isNotEmpty) {
      _existingKapakGorselUrl = product.kapakGorseli;
    }
  }

  void _validateFormFirst() {
    // Ürün adı ve açıklamasıyla birlikte kategori seçimlerinin de tamamlanmış olmasını bekle
    final bool hasCategory =
        selectedCategoryName != null && selectedCategoryName!.isNotEmpty;
    final bool hasSubcategory =
        selectedSubcategoryName != null && selectedSubcategoryName!.isNotEmpty;
    bool shouldEnable =
        _controllerUrunAdi.text.length >= 4 &&
        _controllerUrunAciklama.text.length >= 4 &&
        hasCategory &&
        hasSubcategory;

    // Değişiklik varsa UI'ı güncelle.
    if (shouldEnable != isNextButtonFirst) {
      setState(() {
        isNextButtonFirst = shouldEnable;
      });
    }
  }

  void _validateFormSecond() {
    final bool hasStock = _controllerUrunMiktari.text.isNotEmpty;
    final bool hasRetailPrice = _controllerUrunFiyati.text.isNotEmpty;
    final bool hasSaleType =
        selectedUrunTipiIndex != null; // 0: perakende(1), 1: toptan(2)
    final bool needsMinPrice = selectedUrunTipiIndex == 1;
    final bool hasMinPrice =
        !needsMinPrice || _controllerMinFiyati.text.isNotEmpty;
    bool shouldEnable2 =
        hasStock && hasRetailPrice && hasSaleType && hasMinPrice;
    setState(() {});
    urunFiyatiKDV = _controllerUrunFiyati.text;
    if (shouldEnable2 != isNextButtonSecond) {
      setState(() {
        isNextButtonSecond = shouldEnable2;
      });
    }
  }

  void _validateFormThird() {
    if (selectedHour!.isNotEmpty && selectedMinute!.isNotEmpty) {
      setState(() {
        isNextButtonThird = true;
      });
    } else {
      setState(() {
        isNextButtonThird = false;
      });
    }
  }

  Future<void> _pickKapakGorsel() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg'],
        withData: true,
      );
      if (!mounted) return;
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.single;
        setState(() {
          _kapakGorselFile = file;
          _kapakGorselPreviewBytes = file.bytes;
        });
      }
    } catch (e) {
      debugPrint('Kapak görseli seçilirken hata: $e');
    }
  }

  // kaldırıldı: _pickPdf - yerini onPick* callback'leri aldı

  @override
  void dispose() {
    // Controller'ları dispose etmeyi unutmayın.
    _controllerUrunAdi.dispose();
    _controllerUrunAciklama.dispose();
    _controllerUrunFiyati.dispose();
    _controllerMinFiyati.dispose();
    _controllerUrunMiktari.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Yerelleştirme: DateFormat('tr_TR') için gerekli
    initializeDateFormatting('tr_TR', null);
    Color? labelTextColor = HomeStyle(
      context: context,
    ).outline.withOpacity(0.5);
    final themeData = HomeStyle(context: context);
    double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 12),
            Row(
              children: [
                Expanded(
                  child: AddProductStepperWidget(
                    themeData: themeData,
                    activeStep: activeStep,
                    onStepReached: (index) {
                      setState(() {
                        if (index < activeStep) {
                          activeStep = index;
                        }
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: AppCloseButton(
                    context,
                    size: 26,
                    constraints: const BoxConstraints.tightFor(
                      width: 36,
                      height: 36,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 12, right: 12, bottom: 20),
              child: Builder(
                builder: (context) {
                  switch (activeStep) {
                    case 0:
                      return AddProductInfoSection(
                        labelTextColor: labelTextColor,
                        controllerUrunAdi: _controllerUrunAdi,
                        controllerUrunAciklama: _controllerUrunAciklama,
                        selectedCategoryName: selectedCategoryName,
                        selectedSubcategoryName: selectedSubcategoryName,
                        onCategoryChanged: (val) {
                          setState(() {
                            selectedCategoryName = val;
                            selectedSubcategoryName = null;
                            _validateFormFirst();
                          });
                        },
                        onSubcategoryChanged: (val) {
                          setState(() {
                            selectedSubcategoryName = val;
                            _validateFormFirst();
                          });
                        },
                        isNextEnabled: isNextButtonFirst,
                        onNext: () {
                          setState(() {
                            if (isNextButtonFirst) activeStep += 1;
                          });
                        },
                      );
                    case 1:
                      return AddProductSalesSection(
                        width: width,
                        selectedSatisTuru: selectedUrunTipiIndex == null
                            ? null
                            : (selectedUrunTipiIndex == 0 ? 1 : 2),
                        onSatisTuruChanged: (val) {
                          setState(() {
                            // 1 -> index 0, 2 -> index 1
                            selectedUrunTipiIndex = (val == 1) ? 0 : 1;
                            _validateFormSecond();
                          });
                        },
                        controllerStokMiktari: _controllerUrunMiktari,
                        controllerPerakendeFiyati: _controllerUrunFiyati,
                        controllerMinFiyati: _controllerMinFiyati,
                        urunFiyatiKDV: urunFiyatiKDV,
                        isNextEnabled: isNextButtonSecond,
                        onNext: () {
                          setState(() {
                            if (isNextButtonSecond) activeStep += 1;
                          });
                        },
                      );
                    case 2:
                      return AddProductFeaturesSection(
                        width: width,
                        selectedHour: selectedHour,
                        selectedMinute: selectedMinute,
                        hourItems: hourItems,
                        minuteItems: minuteItems,
                        onHourChanged: (val) {
                          setState(() {
                            selectedHour = val;
                            _validateFormThird();
                          });
                        },
                        onMinuteChanged: (val) {
                          setState(() {
                            selectedMinute = val;
                            _validateFormThird();
                          });
                        },
                        isNextEnabled: true,
                        onNext: () {
                          setState(() {
                            activeStep += 1;
                          });
                        },
                        urunSertifikaPdfName: urunSertifikaPdfName,
                        urunLabSonucPdfName: urunLabSonucPdfName,
                        existingSertifikaPdfUrl: _existingSertifikaPdfUrl,
                        existingLabSonucPdfUrl: _existingLabSonucPdfUrl,
                        onPickSertifika: () async {
                          try {
                            final result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['pdf'],
                            );
                            if (!mounted) return null;
                            if (result != null && result.files.isNotEmpty) {
                              setState(() {
                                urunSertifikaPdfName = result.files.single.name;
                              });
                              return result.files.single.name;
                            }
                          } catch (_) {}
                          return null;
                        },
                        onPickLab: () async {
                          try {
                            final result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['pdf'],
                            );
                            if (!mounted) return null;
                            if (result != null && result.files.isNotEmpty) {
                              setState(() {
                                urunLabSonucPdfName = result.files.single.name;
                              });
                              return result.files.single.name;
                            }
                          } catch (_) {}
                          return null;
                        },
                        isWholesale: selectedUrunTipiIndex == 1,
                      );
                    case 3:
                      return AddProductPhotosSection(
                        width: width,
                        previewBytes: _kapakGorselPreviewBytes,
                        existingImageUrl: _existingKapakGorselUrl,
                        onPickImage: _pickKapakGorsel,
                        isUpdate: widget.product != null,
                        productId: widget.product?.urunId,
                        onConfirm: () async {
                          try {
                            final int satisTuru = selectedSatisTuru ?? 1;
                            final int saticiId = widget.profileName.id;
                            final int kategoriId = _resolveSelectedCategoryId();
                            if (selectedCategoryName == null ||
                                selectedCategoryName!.isEmpty) {
                              showTemporarySnackBar(
                                context,
                                'Lütfen bir ana kategori seçin.',
                                type: SnackBarType.warning,
                              );
                              return;
                            }
                            if (selectedSubcategoryName == null ||
                                selectedSubcategoryName!.isEmpty) {
                              showTemporarySnackBar(
                                context,
                                'Lütfen bir alt kategori seçin.',
                                type: SnackBarType.warning,
                              );
                              return;
                            }
                            // Görsel seçimi sadece yeni ürün eklerken zorunlu
                            if (widget.product == null &&
                                (_kapakGorselFile == null ||
                                    _kapakGorselFile!.bytes == null)) {
                              showTemporarySnackBar(
                                context,
                                'Lütfen kapak görseli ekleyin.',
                                type: SnackBarType.warning,
                              );
                              return;
                            }
                            http.MultipartFile? kapakGorselMultipart;
                            if (_kapakGorselFile != null &&
                                _kapakGorselFile!.bytes != null) {
                              kapakGorselMultipart =
                                  http.MultipartFile.fromBytes(
                                    'kapak_gorsel',
                                    _kapakGorselFile!.bytes!,
                                    filename: _kapakGorselFile!.name,
                                  );
                            }

                            final Map<String, dynamic> productPayload = {
                              // Ürün düzenleme ise 'satici', yeni ürün ekleme ise 'satici_id'
                              if (widget.product != null)
                                'satici': saticiId
                              else
                                'satici_id': saticiId,
                              'urun_adi': _controllerUrunAdi.text.trim(),
                              'urun_aciklama': _controllerUrunAciklama.text
                                  .trim(),
                              // Güncelleme için aciklama da ekle (mapping sorununu önlemek için)
                              if (widget.product != null)
                                'aciklama': _controllerUrunAciklama.text.trim(),
                              'ana_kategori': selectedCategoryName ?? '',
                              'alt_kategori': selectedSubcategoryName ?? '',
                              'stok_miktari':
                                  int.tryParse(
                                    _controllerUrunMiktari.text.trim(),
                                  ) ??
                                  0,
                              'satis_turu': satisTuru,
                              'urun_perakende_fiyati':
                                  _controllerUrunFiyati.text.trim().isEmpty
                                  ? '0'
                                  : _controllerUrunFiyati.text.trim(),
                              'urun_min_fiyati':
                                  _controllerMinFiyati.text.trim().isEmpty
                                  ? '0'
                                  : _controllerMinFiyati.text.trim(),
                              'urun_sertifika_pdf':
                                  urunSertifikaPdfName ?? null,
                              'lab_sonuc_pdf': urunLabSonucPdfName ?? null,
                              'kategori_id': kategoriId,
                              'degerlendirme_puani': "0,0",
                              //'urun_uretim_tarihi': DateFormat(
                              //  'yyyy-MM-dd',
                              //).format(DateTime.now()),
                              //'imece_onayli': false,
                              //'degerlendirme_puani': '4',
                              //'urun_gorunurluluk': true,
                              //'kategori': kategoriId,
                            };
                            if (kapakGorselMultipart != null) {
                              productPayload['kapak_gorsel'] =
                                  kapakGorselMultipart;
                            }

                            if (widget.product != null &&
                                widget.product!.urunId != null) {
                              // Güncelleme işlemi için urun_gorunurluluk ekle
                              productPayload['urun_gorunurluluk'] = true;

                              // Güncelleme işlemi - Provider kullanarak
                              final repository = ref.read(
                                productsRepositoryProvider,
                              );
                              await repository.updateProduct(
                                widget.product!.urunId!,
                                productPayload,
                              );

                              // Product provider'ı invalidate et
                              ref.invalidate(
                                productProvider(widget.product!.urunId!),
                              );

                              // Seller products provider'ını invalidate et
                              if (productPayload.containsKey('satici') &&
                                  productPayload['satici'] != null) {
                                final sellerId = productPayload['satici'] is int
                                    ? productPayload['satici'] as int
                                    : int.tryParse(
                                        productPayload['satici'].toString(),
                                      );
                                if (sellerId != null) {
                                  ref.invalidate(
                                    sellerProductsProvider(sellerId),
                                  );
                                }
                              }

                              // Popüler ürünler provider'ını invalidate et (eğer güncellenen ürün popüler ürünler listesindeyse)
                              ref.invalidate(populerProductsProvider);

                              // Tüm kategori listelerini invalidate et (güncellenen ürün herhangi bir kategoride olabilir)
                              // Not: Tüm kategori listelerini invalidate etmek performans açısından maliyetli olabilir,
                              // ancak veri tutarlılığı için gerekli
                              repository.invalidateProducts();

                              // Provider'ların yenilenmesini bekle
                              try {
                                await Future.wait([
                                  ref.read(
                                    productProvider(widget.product!.urunId!)
                                        .future,
                                  ),
                                  if (productPayload.containsKey('satici') &&
                                      productPayload['satici'] != null)
                                    ref.read(
                                      sellerProductsProvider(
                                        productPayload['satici'] is int
                                            ? productPayload['satici'] as int
                                            : int.tryParse(
                                                productPayload['satici']
                                                    .toString(),
                                              ) ??
                                                0,
                                      ).future,
                                    ),
                                ]);
                              } catch (e) {
                                debugPrint(
                                  'Provider yenilenirken hata: $e',
                                );
                              }

                              showTemporarySnackBar(
                                context,
                                'Ürün başarıyla güncellendi!',
                                type: SnackBarType.success,
                              );
                            } else {
                              // Yeni ürün ekleme işlemi
                              await ApiService.postSellerAddProduct(
                                productPayload,
                              );
                              showTemporarySnackBar(
                                context,
                                'Ürün başarıyla eklendi!',
                                type: SnackBarType.success,
                              );
                            }
                            if (mounted) Navigator.pop(context);
                          } catch (e) {
                            showTemporarySnackBar(
                              context,
                              e.toString(),
                              type: SnackBarType.error,
                            );
                          }
                        },
                      );
                    default:
                      return Center(
                        child: Text('Bir Hata Olduktu. "Switch case default"'),
                      );
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

class AddProductInfoSection extends StatelessWidget {
  final Color? labelTextColor;
  final TextEditingController controllerUrunAdi;
  final TextEditingController controllerUrunAciklama;
  final String? selectedCategoryName;
  final String? selectedSubcategoryName;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onSubcategoryChanged;
  final bool isNextEnabled;
  final VoidCallback onNext;
  const AddProductInfoSection({
    super.key,
    required this.labelTextColor,
    required this.controllerUrunAdi,
    required this.controllerUrunAciklama,
    required this.selectedCategoryName,
    required this.selectedSubcategoryName,
    required this.onCategoryChanged,
    required this.onSubcategoryChanged,
    required this.isNextEnabled,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      spacing: 10,
      children: [
        textField(
          context,
          labelText: 'Ürün Adı',
          maxLines: 1,
          controller: controllerUrunAdi,
          labelTextColor: labelTextColor,
        ),
        CategorySelector(
          categories: _AddProductViewBodyState.kategoriler,
          subcategories: _AddProductViewBodyState.altKategoriler,
          selectedCategoryName: selectedCategoryName,
          selectedSubcategoryName: selectedSubcategoryName,
          onCategoryChanged: onCategoryChanged,
          onSubcategoryChanged: onSubcategoryChanged,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: textField(
            context,
            labelText: 'Ürün Açıklaması',
            maxLines: 15,
            expands: true,
            controller: controllerUrunAciklama,
          ),
        ),
        AddProductNextButton(enabled: isNextEnabled, onPressed: onNext),
      ],
    );
  }
}

class AddProductSalesSection extends StatelessWidget {
  final double width;
  final int? selectedSatisTuru; // 1 perakende, 2 toptan
  final void Function(int value) onSatisTuruChanged;
  final TextEditingController controllerStokMiktari;
  final TextEditingController controllerPerakendeFiyati;
  final TextEditingController controllerMinFiyati;
  final String urunFiyatiKDV;
  final bool isNextEnabled;
  final VoidCallback onNext;
  const AddProductSalesSection({
    super.key,
    required this.width,
    required this.selectedSatisTuru,
    required this.onSatisTuruChanged,
    required this.controllerStokMiktari,
    required this.controllerPerakendeFiyati,
    required this.controllerMinFiyati,
    required this.urunFiyatiKDV,
    required this.isNextEnabled,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      spacing: 10,
      children: [
        AddProductHeadlineText(text: 'Satış Türü'),
        Row(
          children: [
            Expanded(
              child: RadioListTile<int>(
                value: 1,
                groupValue: selectedSatisTuru,
                onChanged: (val) {
                  if (val != null) onSatisTuruChanged(val);
                },
                title: const Text('Perakende Satış'),
                dense: true,
              ),
            ),
            Expanded(
              child: RadioListTile<int>(
                value: 2,
                groupValue: selectedSatisTuru,
                onChanged: (val) {
                  if (val != null) onSatisTuruChanged(val);
                },
                title: const Text('Toptan Satış'),
                dense: true,
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        AddProductHeadlineText(text: 'Stok Miktarı'),
        textField(
          context,
          hintText: 'Stok miktarı',
          controller: controllerStokMiktari,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 15),
        AddProductHeadlineText(text: 'Perakende Fiyatı'),
        textField(
          context,
          hintText: 'Fiyatı belirleyiniz',
          controller: controllerPerakendeFiyati,
          keyboardType: TextInputType.number,
        ),
        if (selectedSatisTuru == 2) ...[
          SizedBox(height: 15),
          AddProductHeadlineText(text: 'Minimum Fiyat'),
          textField(
            context,
            hintText: 'Minimum fiyatı belirleyiniz',
            controller: controllerMinFiyati,
            keyboardType: TextInputType.number,
          ),
        ],
        Align(
          alignment: Alignment.center,
          child: AddProductNextButton(
            enabled: isNextEnabled,
            onPressed: onNext,
          ),
        ),
      ],
    );
  }
}

class AddProductFeaturesSection extends StatelessWidget {
  final double width;
  final String? selectedHour;
  final String? selectedMinute;
  final List<String> hourItems;
  final List<String> minuteItems;
  final ValueChanged<String?> onHourChanged;
  final ValueChanged<String?> onMinuteChanged;
  final bool isNextEnabled;
  final VoidCallback onNext;
  final String? urunSertifikaPdfName;
  final String? urunLabSonucPdfName;
  final String? existingSertifikaPdfUrl;
  final String? existingLabSonucPdfUrl;
  final Future<String?> Function() onPickSertifika;
  final Future<String?> Function() onPickLab;
  final bool isWholesale;
  const AddProductFeaturesSection({
    super.key,
    required this.width,
    required this.selectedHour,
    required this.selectedMinute,
    required this.hourItems,
    required this.minuteItems,
    required this.onHourChanged,
    required this.onMinuteChanged,
    required this.isNextEnabled,
    required this.onNext,
    this.urunSertifikaPdfName,
    this.urunLabSonucPdfName,
    this.existingSertifikaPdfUrl,
    this.existingLabSonucPdfUrl,
    required this.onPickSertifika,
    required this.onPickLab,
    required this.isWholesale,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      spacing: 10,
      children: [
        Row(
          spacing: 20,
          children: [
            GestureDetector(
              onTap: () async {
                await onPickSertifika();
              },
              child: SizedBox(
                width: width * 0.3,
                height: width * 0.3,
                child:
                    existingSertifikaPdfUrl != null &&
                        existingSertifikaPdfUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          existingSertifikaPdfUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.network(
                              'https://github.com/MuhammedIkbalAKGUNDOGDU/imece-test-website/blob/main/imece/src/assets/images/yuklemeYap.png?raw=true',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      )
                    : Image.network(
                        fit: BoxFit.cover,
                        'https://github.com/MuhammedIkbalAKGUNDOGDU/imece-test-website/blob/main/imece/src/assets/images/yuklemeYap.png?raw=true',
                      ),
              ),
            ),
            SizedBox(
              width: width * 0.55,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 6,
                children: [
                  customText(
                    'Ürün Sertifikasını Ekle',
                    context,
                    size: HomeStyle(context: context).bodyLarge.fontSize,
                    weight: FontWeight.bold,
                  ),
                  if (urunSertifikaPdfName != null)
                    customText(
                      'Seçilen dosya: ' + urunSertifikaPdfName!,
                      context,
                      size: HomeStyle(context: context).bodySmall.fontSize,
                      weight: FontWeight.w400,
                    ),
                ],
              ),
            ),
          ],
        ),
        Divider(),
        Row(
          spacing: 20,
          children: [
            GestureDetector(
              onTap: () async {
                await onPickLab();
              },
              child: SizedBox(
                width: width * 0.3,
                height: width * 0.3,
                child:
                    existingLabSonucPdfUrl != null &&
                        existingLabSonucPdfUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          existingLabSonucPdfUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.network(
                              'https://github.com/MuhammedIkbalAKGUNDOGDU/imece-test-website/blob/main/imece/src/assets/images/yuklemeYap.png?raw=true',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      )
                    : Image.network(
                        fit: BoxFit.cover,
                        'https://github.com/MuhammedIkbalAKGUNDOGDU/imece-test-website/blob/main/imece/src/assets/images/yuklemeYap.png?raw=true',
                      ),
              ),
            ),
            SizedBox(
              width: width * 0.55,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 6,
                children: [
                  richText(
                    context,
                    fontSize: HomeStyle(context: context).bodyLarge.fontSize,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.start,
                    maxLines: 10,
                    children: [
                      TextSpan(text: 'Lavoratuvar Sonuçlarını Ekle\n'),
                      TextSpan(text: '\n', style: TextStyle(fontSize: 4)),
                      TextSpan(
                        text:
                            'Değerli üreticimiz, ürününüzü laboratuvarda test ettirmeniz ve çıkan sonucu listelemeniz halinde sizlere x% kadar komisyon indirimi tanınacaktır.',
                        style: TextStyle(
                          fontSize: HomeStyle(
                            context: context,
                          ).bodyMedium.fontSize,
                          fontWeight: FontWeight.normal,
                          color: HomeStyle(
                            context: context,
                          ).primary.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                  if (urunLabSonucPdfName != null)
                    customText(
                      'Seçilen dosya: ' + urunLabSonucPdfName!,
                      context,
                      size: HomeStyle(context: context).bodySmall.fontSize,
                      weight: FontWeight.w400,
                    ),
                ],
              ),
            ),
          ],
        ),
        Divider(),
        //AddProductHeadlineText(text: 'Listeleme Süresi'),
        _ListingDateInfo(isWholesale: isWholesale),
        // Saat/Dakika seçimleri kaldırıldı; tarih bilgisi üstte kart içinde gösteriliyor.
        Center(
          child: AddProductNextButton(
            enabled: isNextEnabled,
            onPressed: onNext,
          ),
        ),
      ],
    );
  }
}

class AddProductPhotosSection extends StatelessWidget {
  final double width;
  final Uint8List? previewBytes;
  final String? existingImageUrl;
  final VoidCallback onPickImage;
  final VoidCallback onConfirm;
  final bool isUpdate;
  final int? productId;
  const AddProductPhotosSection({
    super.key,
    required this.width,
    required this.previewBytes,
    this.existingImageUrl,
    required this.onPickImage,
    required this.onConfirm,
    this.isUpdate = false,
    this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      spacing: 12,
      children: [
        AddProductHeadlineText(text: 'Ürün Görseli Yükleyin'),
        SizedBox(height: 15),
        _PhotoUploadArea(
          width: width,
          previewBytes: previewBytes,
          existingImageUrl: existingImageUrl,
          onPickImage: onPickImage,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: textButton(
            context,
            isUpdate ? 'Bilgileri Güncelle' : 'Onayla',
            elevation: 6,
            weight: FontWeight.bold,
            onPressed: onConfirm,
          ),
        ),
      ],
    );
  }
}

class _PhotoUploadArea extends StatelessWidget {
  final double width;
  final Uint8List? previewBytes;
  final String? existingImageUrl;
  final VoidCallback onPickImage;
  const _PhotoUploadArea({
    required this.width,
    required this.previewBytes,
    this.existingImageUrl,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return container(
      context,
      color: HomeStyle(context: context).surfaceContainer,
      isBoxShadow: true,
      padding: EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 20,
        children: [
          GestureDetector(
            onTap: onPickImage,
            child: Container(
              width: width,
              height: width * 0.45,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 2,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade50,
              ),
              alignment: Alignment.center,
              child: previewBytes != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.memory(
                        previewBytes!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    )
                  : existingImageUrl != null && existingImageUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        existingImageUrl!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Görsel Seç / Sürükle',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 8),
                        Text(
                          'Görsel Seç / Sürükle',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
            ),
          ),
          richText(
            maxLines: 20,
            context,
            children: [
              WidgetSpan(child: Text('📏 ')),
              TextSpan(text: 'Görsel 1200x1800, en fazla 5MB olmalı\n'),
              WidgetSpan(child: Text('📄 ')),
              TextSpan(text: 'Kuralları görmek için tıklayın\n'),
              WidgetSpan(child: Text('➕ ')),
              TextSpan(text: 'JPG veya PNG formatı olmalı'),
            ],
          ),
        ],
      ),
    );
  }
}

class AddProductHeadlineText extends StatelessWidget {
  final String text;
  const AddProductHeadlineText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return customText(
      text,
      context,
      size: HomeStyle(context: context).bodyLarge.fontSize,
      weight: FontWeight.bold,
    );
  }
}

class AddProductNextButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;
  const AddProductNextButton({
    super.key,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return textButton(
      context,
      'Devam Et',
      buttonColor: enabled
          ? null
          : HomeStyle(context: context).primary.withOpacity(0.3),
      titleColor: HomeStyle(context: context).onSecondary,
      weight: FontWeight.bold,
      elevation: 6,
      fontSize: HomeStyle(context: context).bodyLarge.fontSize,
      onPressed: enabled ? onPressed : null,
    );
  }
}

class AddProductStepperWidget extends StatelessWidget {
  final HomeStyle themeData;
  final int activeStep;
  final ValueChanged<int> onStepReached;
  const AddProductStepperWidget({
    super.key,
    required this.themeData,
    required this.activeStep,
    required this.onStepReached,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: EasyStepper(
        direction: Axis.horizontal,
        activeStep: activeStep,
        stepShape: StepShape.circle,
        showStepBorder: false,
        borderThickness: 0,
        padding: const EdgeInsets.all(0),
        internalPadding: 0,
        stepRadius: 25,
        finishedStepBorderColor: themeData.onSecondary,
        finishedStepTextColor: themeData.onSecondary,
        finishedStepBackgroundColor: themeData.secondary,
        activeStepIconColor: themeData.secondary,
        showLoadingAnimation: false,
        steps: [
          EasyStep(
            customStep: CircleAvatar(
              backgroundColor: activeStep >= 0
                  ? themeData.secondary
                  : themeData.onSecondary,
              child: Icon(
                Icons.settings_system_daydream_rounded,
                color: activeStep >= 0
                    ? themeData.onSecondary
                    : themeData.secondary,
              ),
            ),
            customTitle: customText(
              'Ürün Bilgileri',
              context,
              maxLines: 2,
              textAlign: TextAlign.center,
              weight: activeStep == 0 ? FontWeight.bold : FontWeight.normal,
              color: activeStep >= 1 ? themeData.secondary : themeData.primary,
            ),
          ),
          EasyStep(
            customStep: CircleAvatar(
              backgroundColor: activeStep >= 1
                  ? themeData.secondary
                  : themeData.onSecondary,
              child: Icon(
                activeStep >= 1 ? Icons.info_outline : Icons.info,
                color: activeStep >= 1
                    ? themeData.onSecondary
                    : themeData.secondary,
              ),
            ),
            customTitle: customText(
              'Satış Bilgileri',
              context,
              maxLines: 2,
              textAlign: TextAlign.center,
              weight: activeStep == 1 ? FontWeight.bold : FontWeight.normal,
              color: activeStep >= 2 ? themeData.secondary : themeData.primary,
            ),
          ),
          EasyStep(
            customStep: CircleAvatar(
              backgroundColor: activeStep >= 2
                  ? themeData.secondary
                  : themeData.onSecondary,
              child: Icon(
                Icons.display_settings_sharp,
                color: activeStep >= 2
                    ? themeData.onSecondary
                    : themeData.secondary,
              ),
            ),
            customTitle: customText(
              'Ürün Özellikleri',
              context,
              maxLines: 2,
              textAlign: TextAlign.center,
              weight: activeStep == 2 ? FontWeight.bold : FontWeight.normal,
              color: activeStep >= 3 ? themeData.secondary : themeData.primary,
            ),
          ),
          EasyStep(
            customStep: CircleAvatar(
              backgroundColor: activeStep >= 3
                  ? themeData.secondary
                  : themeData.onSecondary,
              child: Icon(
                activeStep >= 4 ? Icons.image_outlined : Icons.image,
                color: activeStep >= 3
                    ? themeData.onSecondary
                    : themeData.secondary,
              ),
            ),
            customTitle: customText(
              'Ürün Fotoğrafı',
              context,
              maxLines: 2,
              textAlign: TextAlign.center,
              weight: activeStep == 3 ? FontWeight.bold : FontWeight.normal,
              color: activeStep >= 4 ? themeData.secondary : themeData.primary,
            ),
          ),
        ],
        onStepReached: onStepReached,
      ),
    );
  }
}

class _ListingDateInfo extends StatelessWidget {
  final bool isWholesale;
  const _ListingDateInfo({required this.isWholesale});

  Map<String, String> _getListingDates() {
    final now = DateTime.now();
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 0);
    final threeDaysLaterBase = now.add(const Duration(days: 3));
    final threeDaysLaterEnd = DateTime(
      threeDaysLaterBase.year,
      threeDaysLaterBase.month,
      threeDaysLaterBase.day,
      23,
      59,
      0,
    );

    final formatter = DateFormat('d MMMM y HH:mm', 'tr_TR');
    return {
      'todayEnd': formatter.format(todayEnd),
      'threeDaysLaterEnd': formatter.format(threeDaysLaterEnd),
    };
  }

  @override
  Widget build(BuildContext context) {
    if (!isWholesale) return const SizedBox.shrink();
    final dates = _getListingDates();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        _InfoCard(
          title: 'Gurubun üye kabul başlangıç tarihi',
          description:
              'Bu tarih, grubun üye kabulünün başladığı gündür. Bugün saat 23:59\'a kadar geçerlidir.\nTarih: ${dates['todayEnd'] ?? ''}',
        ),
        const SizedBox(height: 8),
        _InfoCard(
          title: 'Gurubun üye kabul Bitiş tarihi',
          description:
              'Bu tarih, grubun üye kabulünün sona ereceği gündür. Üyelikler belirtilen tarihe kadar kabul edilir.\nTarih: ${dates['threeDaysLaterEnd'] ?? ''}',
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String description;
  const _InfoCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text(description, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}
