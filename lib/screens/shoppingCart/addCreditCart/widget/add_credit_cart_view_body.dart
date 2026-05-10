part of '../add_credit_cart.dart';

class AddCreditCartViewBody extends StatefulWidget {
  final bool editMode;
  final String? cardId;
  final TextEditingController cartNumberController;
  final TextEditingController lateUseDateController;
  final TextEditingController cvvController;
  final TextEditingController cartUserNameController;
  final TextEditingController cartNameController;

  const AddCreditCartViewBody(
      {super.key,
      this.editMode = false,
      this.cardId,
      required this.cartNumberController,
      required this.lateUseDateController,
      required this.cvvController,
      required this.cartUserNameController,
      required this.cartNameController});

  @override
  State<AddCreditCartViewBody> createState() => _AddCreditCartViewBodyState();
}

class _AddCreditCartViewBodyState extends State<AddCreditCartViewBody> {
  final storage = FlutterSecureStorage();
  String? cardNumber;
  String? cardName;
  String? cardUserName;
  String? cardCvv;
  String? cardLateUseDate;
  bool _isSaveButton = false;
  bool _isChecked = false;
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    cardNumber = widget.cartNumberController.text;
    cardName = widget.cartNameController.text;
    cardUserName = widget.cartUserNameController.text;
    cardCvv = widget.cvvController.text;
    cardLateUseDate = widget.lateUseDateController.text;

    widget.cartNumberController.addListener(validateForm);
    widget.lateUseDateController.addListener(validateForm);
    widget.cvvController.addListener(validateForm);
    widget.cartNameController.addListener(validateForm);
    widget.cartUserNameController.addListener(validateForm);

    if (widget.editMode) {
      _isChecked = true; // Kayıtlı kart ise işaretli gelmeli
      _loadCardDetails();
    }
  }

  Future<void> _loadCardDetails() async {
    final storedCards = await storage.read(key: 'savedCards');
    if (storedCards != null && storedCards.isNotEmpty) {
      final List<dynamic> decoded = jsonDecode(storedCards);
      final cardsList = decoded.map((c) => CardInfo.fromJson(c)).toList();
      final card = cardsList.where((c) => c.id == widget.cardId).firstOrNull;
      if (card != null) {
        setState(() {
          _isDefault = card.isDefault;
        });
      }
    }
    validateForm();
  }

  void validateForm() {
    setState(() {
      cardNumber = widget.cartNumberController.text;
      cardName = widget.cartNameController.text;
      cardUserName = widget.cartUserNameController.text;
      cardCvv = widget.cvvController.text;
      cardLateUseDate = widget.lateUseDateController.text;
    });
    bool shouldEnable = widget.cartNumberController.text.length >= 16 &&
        widget.cartUserNameController.text.length > 1 &&
        widget.cvvController.text.length >= 3 &&
        widget.lateUseDateController.text.length >= 5 &&
        _isChecked == true;
    if (shouldEnable) {
      setState(() {
        _isSaveButton = true;
      });
    } else {
      setState(() {
        _isSaveButton = false;
      });
    }
  }

  @override
  void dispose() {
    widget.cartNumberController.dispose();
    widget.lateUseDateController.dispose();
    widget.cvvController.dispose();
    widget.cartUserNameController.dispose();
    widget.cartNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          spacing: 15,
          children: [
            CreditCartWidget(
              cardUserName: cardUserName ?? 'Kart sahibinin adı',
              cardNumber: cardNumber ?? '0000 0000 0000 0000',
              cardLateUseDate: cardLateUseDate ?? '00/00',
              cardCvv: cardCvv ?? '000',
            ),
            Column(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headerText(context, 'Kart Numarası'),
                textField(context,
                    hintText: "0000 0000 0000 0000",
                    keyboardType: TextInputType.datetime,
                    controller: widget.cartNumberController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(
                          16), // 16 rakam + 3 boşluk = 19 karakter
                      CardNumberInputFormatter(),
                    ]),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _headerText(context,  'Son Kullanma Tarihi'),
                  SizedBox(
                    child: textField(context,
                        hintText: '00/00',
                        keyboardType: TextInputType.datetime,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(
                              4), // 16 rakam + 3 bölü = 19 karakter
                          TwoCharSlashInputFormatter(),
                        ],
                        controller: widget.lateUseDateController),
                    width: width * 0.45,
                  ),
                ]),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5,
                  children: [
                    _headerText(context, 'CVV'),
                    SizedBox(
                      child: textField(context,
                          hintText: '000',
                          keyboardType: TextInputType.datetime,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(3),
                          ],
                          controller: widget.cvvController),
                      width: width * 0.45,
                    ),
                  ],
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                _headerText(context, 'Kart Sahibi Adı'),
                textField(context,
                    hintText: 'Kart sahibinin adı',
                    keyboardType: TextInputType.name,
                    controller: widget.cartUserNameController),
              ],
            ),
            CheckboxListTile(
              title: customText('Kartı daha sonrası için kaydet', context),
              value: _isChecked,
              activeColor: AppColors.primary(context),
              onChanged: (bool? newValue) {
                setState(() {
                  _isChecked = newValue ?? false;
                  validateForm();
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              title: customText('Varsayılan kart olarak ayarla', context),
              value: _isDefault,
              activeColor: AppColors.primary(context),
              onChanged: (bool? newValue) {
                setState(() {
                  _isDefault = newValue ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            textButton(
              context,
              'Kaydet',
              elevation: 6,
              weight: FontWeight.w600,
              fontSize: AppTextSizes.bodyLarge(context),
              buttonColor: _isSaveButton
                  ? AppColors.secondary(context)
                  : AppColors.primary(context).withOpacity(0.3),
              shadowColor: _isSaveButton
                  ? AppColors.secondary(context)
                  : AppColors.primary(context).withOpacity(0.3),
              onPressed: _isSaveButton
                  ? () async {
                      try {
                        final storedCards = await storage.read(key: 'savedCards');
                        List<CardInfo> cardsList = [];
                        if (storedCards != null && storedCards.isNotEmpty) {
                          final List<dynamic> decoded = jsonDecode(storedCards);
                          cardsList = decoded.map((c) => CardInfo.fromJson(c)).toList();
                        }

                        if (_isDefault) {
                          // Diğer kartların varsayılan durumunu kaldır
                          for (var i = 0; i < cardsList.length; i++) {
                            final c = cardsList[i];
                            cardsList[i] = CardInfo(
                              id: c.id,
                              cardNumber: c.cardNumber,
                              cardLateUseDate: c.cardLateUseDate,
                              cardCvv: c.cardCvv,
                              cardUserName: c.cardUserName,
                              cardName: c.cardName,
                              isDefault: false,
                              customColors: c.customColors,
                            );
                          }
                        }

                        final newCard = CardInfo(
                          id: widget.editMode ? (widget.cardId ?? DateTime.now().millisecondsSinceEpoch.toString()) : DateTime.now().millisecondsSinceEpoch.toString(),
                          cardNumber: cardNumber!,
                          cardLateUseDate: cardLateUseDate!,
                          cardCvv: cardCvv!,
                          cardUserName: cardUserName!,
                          cardName: cardName ?? 'Kartım',
                          isDefault: _isDefault,
                        );

                        if (widget.editMode) {
                          final index = cardsList.indexWhere((c) => c.id == widget.cardId);
                          if (index != -1) {
                            cardsList[index] = newCard;
                          } else {
                            cardsList.add(newCard);
                          }
                        } else {
                          cardsList.add(newCard);
                        }

                        final cardsJson = jsonEncode(cardsList.map((c) => c.toJson()).toList());
                        await storage.write(key: 'savedCards', value: cardsJson);

                        if (mounted) {
                          showTemporarySnackBar(context, 'Kart kaydedildi', type: SnackBarType.success);
                          Navigator.pop(context, true);
                        }
                      } catch (e) {
                        debugPrint('Kart kaydetme hatası: $e');
                        if (mounted) {
                          showTemporarySnackBar(context, 'Hata oluştu', type: SnackBarType.error);
                        }
                      }
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Padding _headerText(BuildContext context, String text) {
    return customText(text, context,
        size: AppTextSizes.bodyLarge(context), weight: FontWeight.w600);
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i + 1 != text.length) {
        buffer.write(' '); // Her 4 karakterden sonra bir boşluk ekle
      }
    }

    final formattedText = buffer.toString();
    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class TwoCharSlashInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 2 == 0 && i + 1 != text.length) {
        buffer.write('/'); // Her 2 karakterden sonra '/' ekle
      }
    }

    final formattedText = buffer.toString();
    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
