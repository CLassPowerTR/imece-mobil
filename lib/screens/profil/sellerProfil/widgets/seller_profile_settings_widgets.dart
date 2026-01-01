part of '../seller_profil_screen.dart';

class SellerProfileSettingsScreen extends ConsumerStatefulWidget {
  const SellerProfileSettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SellerProfileSettingsScreen> createState() =>
      _SellerProfileSettingsScreenState();
}

class _SellerProfileSettingsScreenState
    extends ConsumerState<SellerProfileSettingsScreen> {
  bool _initialized = false;
  bool _isSaving = false;
  late Map<String, String> _originalValues;
  late Map<String, String> _editedValues;

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _magazaAdiController;
  late TextEditingController _profilTanitimYazisiController;
  late TextEditingController _professionController;
  late TextEditingController _telnoController;
  late TextEditingController _ibanController;
  late TextEditingController _vergiNoController;

  late FocusNode _firstNameFocus;
  late FocusNode _lastNameFocus;
  late FocusNode _magazaAdiFocus;
  late FocusNode _profilTanitimYazisiFocus;
  late FocusNode _professionFocus;
  late FocusNode _telnoFocus;
  late FocusNode _ibanFocus;
  late FocusNode _vergiNoFocus;

  @override
  void initState() {
    super.initState();
    _originalValues = {
      'first_name': '',
      'last_name': '',
      'magaza_adi': '',
      'profil_tanitim_yazisi': '',
      'profession': '',
      'telno': '',
      'satici_iban': '',
      'satici_vergi_numarasi': '',
    };
    _editedValues = Map<String, String>.from(_originalValues);

    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _magazaAdiController = TextEditingController();
    _profilTanitimYazisiController = TextEditingController();
    _professionController = TextEditingController();
    _telnoController = TextEditingController();
    _ibanController = TextEditingController();
    _vergiNoController = TextEditingController();

    _firstNameFocus = FocusNode();
    _lastNameFocus = FocusNode();
    _magazaAdiFocus = FocusNode();
    _profilTanitimYazisiFocus = FocusNode();
    _professionFocus = FocusNode();
    _telnoFocus = FocusNode();
    _ibanFocus = FocusNode();
    _vergiNoFocus = FocusNode();

    // Controller'lara değişiklik dinleyicileri ekle
    _firstNameController.addListener(() {
      _editedValues['first_name'] = _normalize(_firstNameController.text);
    });
    _lastNameController.addListener(() {
      _editedValues['last_name'] = _normalize(_lastNameController.text);
    });
    _magazaAdiController.addListener(() {
      _editedValues['magaza_adi'] = _normalize(_magazaAdiController.text);
    });
    _profilTanitimYazisiController.addListener(() {
      _editedValues['profil_tanitim_yazisi'] = _normalize(
        _profilTanitimYazisiController.text,
      );
    });
    _professionController.addListener(() {
      _editedValues['profession'] = _normalize(_professionController.text);
    });
    _telnoController.addListener(() {
      // Telefon numarasından format karakterlerini kaldır
      String phoneText = _telnoController.text.replaceAll(
        RegExp(r'[^0-9]'),
        '',
      );
      _editedValues['telno'] = _normalize(phoneText);
    });
    _ibanController.addListener(() {
      // IBAN için TR prefix'ini ekle
      String ibanText = _ibanController.text;
      String ibanValue = ibanText.isEmpty ? '' : 'TR$ibanText';
      _editedValues['satici_iban'] = _normalize(ibanValue);
    });
    _vergiNoController.addListener(() {
      _editedValues['satici_vergi_numarasi'] = _normalize(
        _vergiNoController.text,
      );
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _magazaAdiController.dispose();
    _profilTanitimYazisiController.dispose();
    _professionController.dispose();
    _telnoController.dispose();
    _ibanController.dispose();
    _vergiNoController.dispose();

    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _magazaAdiFocus.dispose();
    _profilTanitimYazisiFocus.dispose();
    _professionFocus.dispose();
    _telnoFocus.dispose();
    _ibanFocus.dispose();
    _vergiNoFocus.dispose();
    super.dispose();
  }

  bool get _hasChanges {
    return _editedValues.entries.any(
      (entry) =>
          _normalize(entry.value) != _normalize(_originalValues[entry.key]),
    );
  }

  void _syncUser(User user) {
    final sellerProfil = user.saticiProfili;
    String iban = _normalize(sellerProfil?.saticiIban);
    // IBAN'dan TR'yi çıkar ve sadece rakamları al
    String ibanDigits = '';
    if (iban.isNotEmpty) {
      // TR'yi kaldır ve boşlukları temizle
      String clean = iban.replaceAll(' ', '').toUpperCase();
      if (clean.startsWith('TR')) {
        ibanDigits = clean.substring(2);
      } else {
        ibanDigits = clean.replaceAll(RegExp(r'[^0-9]'), '');
      }
      // Formatla: 2 rakam (boşluk) + 4'erli gruplar + son 2 rakam
      ibanDigits = _formatIbanDigits(ibanDigits);
    }

    final nextOriginal = {
      'first_name': _normalize(user.firstName),
      'last_name': _normalize(user.lastName),
      'magaza_adi': _normalize(sellerProfil?.magazaAdi),
      'profil_tanitim_yazisi': _normalize(sellerProfil?.profilTanitimYazisi),
      'profession': _normalize(sellerProfil?.profession),
      'telno': _normalize(user.telno).replaceAll(RegExp(r'[^0-9]'), ''),
      'satici_iban': iban.isNotEmpty ? 'TR$ibanDigits' : '',
      'satici_vergi_numarasi': _normalize(sellerProfil?.saticiVergiNumarasi),
    };

    // Controller'ları her zaman güncelle (API'den gelen yeni veri ile senkronize et)
    String firstNameValue = nextOriginal['first_name'] ?? '';
    String lastNameValue = nextOriginal['last_name'] ?? '';
    String magazaAdiValue = nextOriginal['magaza_adi'] ?? '';
    String profilTanitimYazisiValue =
        nextOriginal['profil_tanitim_yazisi'] ?? '';
    String professionValue = nextOriginal['profession'] ?? '';
    String telnoValue = nextOriginal['telno'] ?? '';
    String ibanValue = nextOriginal['satici_iban'] ?? '';
    String vergiNoValue = nextOriginal['satici_vergi_numarasi'] ?? '';

    // IBAN controller'a sadece rakamları yaz (TR olmadan)
    String ibanForController = '';
    if (ibanValue.isNotEmpty) {
      String ibanDigitsOnly = ibanValue.toUpperCase().startsWith('TR')
          ? ibanValue.substring(2)
          : ibanValue;
      ibanDigitsOnly = ibanDigitsOnly.replaceAll(RegExp(r'[^0-9]'), '');
      ibanForController = _formatIbanDigits(ibanDigitsOnly);
    }

    // Controller'ları güncelle (sadece focus'ta değilse, değer değişmişse ve kullanıcı düzenleme yapmamışsa)
    // Focus'ta olan alanları güncelleme, kullanıcının yazdığı metni koru
    // Eğer kullanıcı düzenleme yapmışsa (_editedValues != _originalValues), provider'dan gelen değeri yazma
    bool hasUserEdits = !_mapsEqual(_originalValues, _editedValues);

    if (!_firstNameFocus.hasFocus &&
        _firstNameController.text != firstNameValue &&
        (!hasUserEdits ||
            _normalize(_editedValues['first_name']) ==
                _normalize(_originalValues['first_name']))) {
      _firstNameController.text = firstNameValue;
    }
    if (!_lastNameFocus.hasFocus &&
        _lastNameController.text != lastNameValue &&
        (!hasUserEdits ||
            _normalize(_editedValues['last_name']) ==
                _normalize(_originalValues['last_name']))) {
      _lastNameController.text = lastNameValue;
    }
    if (!_magazaAdiFocus.hasFocus &&
        _magazaAdiController.text != magazaAdiValue &&
        (!hasUserEdits ||
            _normalize(_editedValues['magaza_adi']) ==
                _normalize(_originalValues['magaza_adi']))) {
      _magazaAdiController.text = magazaAdiValue;
    }
    if (!_profilTanitimYazisiFocus.hasFocus &&
        _profilTanitimYazisiController.text != profilTanitimYazisiValue &&
        (!hasUserEdits ||
            _normalize(_editedValues['profil_tanitim_yazisi']) ==
                _normalize(_originalValues['profil_tanitim_yazisi']))) {
      _profilTanitimYazisiController.text = profilTanitimYazisiValue;
    }
    if (!_professionFocus.hasFocus &&
        _professionController.text != professionValue &&
        (!hasUserEdits ||
            _normalize(_editedValues['profession']) ==
                _normalize(_originalValues['profession']))) {
      _professionController.text = professionValue;
    }
    // Telefon numarasını formatla
    String telnoFormatted = _formatPhoneNumber(telnoValue);
    if (!_telnoFocus.hasFocus &&
        _telnoController.text != telnoFormatted &&
        (!hasUserEdits ||
            _normalize(_editedValues['telno']) ==
                _normalize(_originalValues['telno']))) {
      _telnoController.text = telnoFormatted;
    }
    if (!_ibanFocus.hasFocus &&
        _ibanController.text != ibanForController &&
        (!hasUserEdits ||
            _normalize(_editedValues['satici_iban']) ==
                _normalize(_originalValues['satici_iban']))) {
      _ibanController.text = ibanForController;
    }
    if (!_vergiNoFocus.hasFocus &&
        _vergiNoController.text != vergiNoValue &&
        (!hasUserEdits ||
            _normalize(_editedValues['satici_vergi_numarasi']) ==
                _normalize(_originalValues['satici_vergi_numarasi']))) {
      _vergiNoController.text = vergiNoValue;
    }

    // Eğer değerler değişmemişse ve initialized ise, return et
    if (_initialized && _mapsEqual(_originalValues, nextOriginal)) {
      return;
    }

    setState(() {
      _originalValues = nextOriginal;
      _editedValues = Map<String, String>.from(nextOriginal);
      _initialized = true;
    });
  }

  String _formatPhoneNumber(String phone) {
    // Sadece rakamları al
    String digits = phone.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.isEmpty) {
      return '';
    }

    // Maksimum 11 rakam (0 + 10 haneli numara)
    if (digits.length > 11) {
      digits = digits.substring(0, 11);
    }

    // 0 ile başlamalı
    if (!digits.startsWith('0')) {
      if (digits.length == 10) {
        digits = '0$digits';
      } else {
        return digits;
      }
    }

    // Format: 0 (XXX) XXX XX XX
    if (digits.length <= 1) {
      return digits;
    } else if (digits.length <= 4) {
      return '${digits.substring(0, 1)} (${digits.substring(1)}';
    } else if (digits.length <= 7) {
      return '${digits.substring(0, 1)} (${digits.substring(1, 4)}) ${digits.substring(4)}';
    } else if (digits.length <= 9) {
      return '${digits.substring(0, 1)} (${digits.substring(1, 4)}) ${digits.substring(4, 7)} ${digits.substring(7)}';
    } else {
      return '${digits.substring(0, 1)} (${digits.substring(1, 4)}) ${digits.substring(4, 7)} ${digits.substring(7, 9)} ${digits.substring(9)}';
    }
  }

  String _formatIbanDigits(String digits) {
    // Sadece rakamları al
    String clean = digits.replaceAll(RegExp(r'[^0-9]'), '');

    if (clean.isEmpty) {
      return '';
    }

    // Maksimum 24 rakam
    if (clean.length > 24) {
      clean = clean.substring(0, 24);
    }

    // İlk 2 rakam
    if (clean.length <= 2) {
      return clean;
    }

    // İlk 2 rakam + boşluk
    String formatted = '${clean.substring(0, 2)} ';
    String remaining = clean.substring(2);

    // 4'erli gruplar
    while (remaining.length > 4) {
      formatted += '${remaining.substring(0, 4)} ';
      remaining = remaining.substring(4);
    }

    // Kalan kısmı ekle (kalan tüm rakamları yaz)
    if (remaining.isNotEmpty) {
      formatted += remaining;
    }

    return formatted.trimRight();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    if (user != null && user.saticiProfili != null) {
      _syncUser(user);
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 4,
        shadowColor: Colors.grey[300],
        leadingWidth: MediaQuery.of(context).size.width * 0.3,
        leading: TurnBackTextIcon(),
        title: customText(
          'Profil Ayarları',
          context,
          size: AppTextSizes.bodyLarge(context),
          weight: FontWeight.w600,
        ),
        actions: [
          if (_hasChanges)
            TextButton(
              onPressed: _isSaving ? null : () => _saveChanges(context),
              child: _isSaving
                  ? SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      'Kaydet',
                      style: TextStyle(
                        color: HomeStyle(context: context).secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
        ],
      ),
      body: user == null || user.saticiProfili == null
          ? Center(child: customText('Kullanıcı bilgisi bulunamadı', context))
          : ListView(
              padding: AppPaddings.all12,
              children: [
                // Ad Soyad - Yanyana
                Row(
                  children: [
                    Expanded(
                      child: textField(
                        context,
                        controller: _firstNameController,
                        labelText: 'Ad',
                        keyboardType: TextInputType.name,
                        focusNode: _firstNameFocus,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_lastNameFocus);
                        },
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: textField(
                        context,
                        controller: _lastNameController,
                        labelText: 'Soyad',
                        keyboardType: TextInputType.name,
                        focusNode: _lastNameFocus,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_magazaAdiFocus);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                // Mağaza Adı
                textField(
                  context,
                  controller: _magazaAdiController,
                  labelText: 'Mağaza Adı',
                  keyboardType: TextInputType.text,
                  focusNode: _magazaAdiFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(
                      context,
                    ).requestFocus(_profilTanitimYazisiFocus);
                  },
                ),
                SizedBox(height: 12),
                // Profil Tanıtım Yazısı
                textField(
                  context,
                  controller: _profilTanitimYazisiController,
                  labelText: 'Profil Tanıtım Yazısı',
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: 5,
                  focusNode: _profilTanitimYazisiFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_professionFocus);
                  },
                ),
                SizedBox(height: 12),
                // Meslek
                textField(
                  context,
                  controller: _professionController,
                  labelText: 'Meslek',
                  keyboardType: TextInputType.text,
                  focusNode: _professionFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_telnoFocus);
                  },
                ),
                SizedBox(height: 12),
                // Telefon
                textField(
                  context,
                  controller: _telnoController,
                  labelText: 'Telefon',
                  keyboardType: TextInputType.phone,
                  focusNode: _telnoFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_ibanFocus);
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    PhoneInputFormatter(),
                  ],
                ),
                SizedBox(height: 12),
                // IBAN
                TextField(
                  controller: _ibanController,
                  focusNode: _ibanFocus,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_vergiNoFocus);
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    IbanInputFormatter(),
                  ],
                  style: TextStyle(color: HomeStyle(context: context).primary),
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    isDense: true,
                    labelStyle: TextStyle(
                      color: HomeStyle(
                        context: context,
                      ).outline.withOpacity(0.5),
                    ),
                    labelText: 'IBAN',
                    prefixText: 'TR ',
                    prefixStyle: TextStyle(
                      color: HomeStyle(context: context).primary,
                      fontWeight: FontWeight.w600,
                    ),
                    hintText: '98 7654 3210 9876 5432 1098 76',
                    hintStyle: TextStyle(
                      color: HomeStyle(
                        context: context,
                      ).outline.withOpacity(0.5),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: HomeStyle(context: context).secondary,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: HomeStyle(context: context).secondary,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HomeStyle(context: context).secondary,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                // Vergi No
                textField(
                  context,
                  controller: _vergiNoController,
                  labelText: 'Vergi No',
                  keyboardType: TextInputType.number,
                  focusNode: _vergiNoFocus,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              ],
            ),
    );
  }

  Future<void> _saveChanges(BuildContext context) async {
    final payload = <String, dynamic>{};
    _editedValues.forEach((key, value) {
      if (_normalize(_originalValues[key]) != _normalize(value)) {
        String normalizedValue = _normalize(value);
        // IBAN için boşlukları kaldır
        if (key == 'satici_iban') {
          normalizedValue = normalizedValue.replaceAll(' ', '');
        }
        // Telefon için format karakterlerini kaldır (sadece rakamlar)
        if (key == 'telno') {
          normalizedValue = normalizedValue.replaceAll(RegExp(r'[^0-9]'), '');
        }
        payload[key] = normalizedValue;
      }
    });

    if (payload.isEmpty) return;

    setState(() => _isSaving = true);

    try {
      await ref.read(userProvider.notifier).updateUser(payload);
      // Kullanıcı verisi güncellendi, _initialized flag'ini false yap
      // Böylece _syncUser tekrar çalışacak ve controller'lar güncellenecek
      setState(() {
        _initialized = false;
        _originalValues = Map.from(_editedValues);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil bilgileri güncellendi.')),
        );
      }
    } catch (e) {
      if (mounted) {
        showTemporarySnackBar(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  String _normalize(String? value) => value?.trim() ?? '';

  bool _mapsEqual(Map<String, String> a, Map<String, String> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (_normalize(a[key]) != _normalize(b[key])) return false;
    }
    return true;
  }
}

// Telefon formatı için TextInputFormatter
// Format: 0 (555) 123 45 67
// 0 + (3 rakam) + boşluk + 3 rakam + boşluk + 2 rakam + boşluk + 2 rakam
// Toplam: 11 rakam (0 + 10 haneli numara)
class PhoneInputFormatter extends TextInputFormatter {
  static const int maxDigits = 11; // Maksimum 11 rakam

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Sadece rakamları al
    String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Maksimum 11 rakam sınırı
    if (digits.length > maxDigits) {
      digits = digits.substring(0, maxDigits);
    }

    if (digits.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // 0 ile başlamalı
    if (!digits.startsWith('0')) {
      if (digits.length == 10) {
        digits = '0$digits';
      } else if (digits.length < 10) {
        // Henüz 10 haneli değilse, olduğu gibi bırak
        return newValue.copyWith(
          text: digits,
          selection: TextSelection.collapsed(offset: digits.length),
        );
      }
    }

    // Format: 0 (XXX) XXX XX XX
    String formatted;
    if (digits.length <= 1) {
      formatted = digits;
    } else if (digits.length <= 4) {
      formatted = '${digits.substring(0, 1)} (${digits.substring(1)}';
    } else if (digits.length <= 7) {
      formatted =
          '${digits.substring(0, 1)} (${digits.substring(1, 4)}) ${digits.substring(4)}';
    } else if (digits.length <= 9) {
      formatted =
          '${digits.substring(0, 1)} (${digits.substring(1, 4)}) ${digits.substring(4, 7)} ${digits.substring(7)}';
    } else {
      formatted =
          '${digits.substring(0, 1)} (${digits.substring(1, 4)}) ${digits.substring(4, 7)} ${digits.substring(7, 9)} ${digits.substring(9)}';
    }

    // Cursor pozisyonunu hesapla
    int cursorPosition = newValue.selection.baseOffset;
    String oldDigits = oldValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    int oldDigitCount = oldDigits.length;
    int newDigitCount = digits.length;

    // Eğer rakam sayısı değiştiyse, cursor'ı sona koy
    if (newDigitCount != oldDigitCount) {
      cursorPosition = formatted.length;
    } else {
      // Rakam sayısı aynıysa, cursor pozisyonunu koru
      if (cursorPosition > formatted.length) {
        cursorPosition = formatted.length;
      }
    }

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}

// IBAN formatı için TextInputFormatter
// Format: 98 7654 3210 9876 5432 1098 76 (TR prefixText olarak eklenecek)
// 2 rakam (boşluk) + 4 rakam (boşluk) + 4 rakam (boşluk) + ... + son 2 rakam
// Toplam: 24 rakam
// Format: 2 rakam + boşluk + 4 rakam + boşluk + 4 rakam + boşluk + ... + son 2 rakam
class IbanInputFormatter extends TextInputFormatter {
  static const int maxDigits = 24; // Maksimum 24 rakam

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Sadece rakamları al
    String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Maksimum 24 rakam sınırı
    if (digits.length > maxDigits) {
      digits = digits.substring(0, maxDigits);
    }

    if (digits.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // İlk 2 rakam
    if (digits.length <= 2) {
      return newValue.copyWith(
        text: digits,
        selection: TextSelection.collapsed(offset: digits.length),
      );
    }

    // İlk 2 rakam + boşluk
    String formatted = '${digits.substring(0, 2)} ';
    String remaining = digits.substring(2);

    // 4'erli gruplar (kalan 22 rakam için)
    // 22 rakam = 5 grup (4+4+4+4+4) + 2 rakam
    // Ama format: 2 + 4 + 4 + 4 + 4 + 4 + 2 = 24 rakam
    while (remaining.length > 4) {
      formatted += '${remaining.substring(0, 4)} ';
      remaining = remaining.substring(4);
    }

    // Kalan kısmı ekle (kalan tüm rakamları yaz)
    if (remaining.isNotEmpty) {
      formatted += remaining;
    }

    // Cursor pozisyonunu hesapla - basitleştirilmiş versiyon
    // Her zaman cursor'ı sona koy, böylece kullanıcı rahatça yazabilir
    int cursorPosition = formatted.length;

    return newValue.copyWith(
      text: formatted.trimRight(),
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}
