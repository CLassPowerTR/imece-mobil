class SellerProfil {
  final int id;
  final String? profilBanner;
  final String? profilTanitimYazisi;
  final String? degerlendirmePuani;
  final String? magazaAdi;
  final String? saticiVergiNumarasi;
  final String? saticiIban;
  final bool imeceOnay;
  final String? imeceOnayLastDate;
  final String? profession;
  final int kullanici;

  SellerProfil({
    required this.id,
    this.profilBanner,
    this.profilTanitimYazisi,
    this.degerlendirmePuani,
    this.magazaAdi,
    this.saticiVergiNumarasi,
    this.saticiIban,
    required this.imeceOnay,
    this.imeceOnayLastDate,
    this.profession,
    required this.kullanici,
  });

  factory SellerProfil.fromJson(Map<String, dynamic> json) {
    // imece_onay_last_date'i yıl-ay-gün formatına dönüştür
    String? formattedDate;
    final dynamic dateValue = json['imece_onay_last_date'];
    if (dateValue != null) {
      try {
        final dateStr = dateValue.toString();
        // ISO 8601 formatından sadece tarih kısmını al (YYYY-MM-DD)
        if (dateStr.contains('T')) {
          formattedDate = dateStr.split('T')[0];
        } else {
          formattedDate = dateStr;
        }
      } catch (e) {
        // Parse hatası durumunda orijinal değeri kullan
        formattedDate = dateValue.toString();
      }
    }

    return SellerProfil(
      id: json['id'] ?? 0,
      profilBanner: json['profil_banner'],
      profilTanitimYazisi: json['profil_tanitim_yazisi'] ?? '',
      degerlendirmePuani: json['degerlendirme_puani'],
      magazaAdi: json['magaza_adi'],
      saticiVergiNumarasi: json['satici_vergi_numarasi'],
      saticiIban: json['satici_iban'],
      imeceOnay: json['imece_onay'] ?? false,
      imeceOnayLastDate: formattedDate,
      profession: json['profession'],
      kullanici: json['kullanici'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profil_banner': profilBanner,
      'profil_tanitim_yazisi': profilTanitimYazisi,
      'degerlendirme_puani': degerlendirmePuani,
      'magaza_adi': magazaAdi,
      'satici_vergi_numarasi': saticiVergiNumarasi,
      'satici_iban': saticiIban,
      'imece_onay': imeceOnay,
      'imece_onay_last_date': imeceOnayLastDate,
      'profession': profession,
      'kullanici': kullanici,
    };
  }
}

class BuyerProfil {
  final int id;
  final double blockedBakiye;
  final String? cinsiyet;
  final String? adres;
  final int kullanici;

  BuyerProfil({
    required this.id,
    required this.blockedBakiye,
    this.cinsiyet,
    this.adres,
    required this.kullanici,
  });

  factory BuyerProfil.fromJson(Map<String, dynamic> json) {
    return BuyerProfil(
      id: json['id'] ?? 0,
      blockedBakiye:
          double.tryParse(json['blocked_bakiye']?.toString() ?? '0.0') ?? 0.0,
      cinsiyet: json['cinsiyet'],
      adres: json['adres'],
      kullanici: json['kullanici'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'blocked_bakiye': blockedBakiye,
      'cinsiyet': cinsiyet,
      'adres': adres,
      'kullanici': kullanici,
    };
  }
}

class User {
  final int id;
  final DateTime? lastLogin;
  final bool isSuperuser;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final bool isStaff;
  final bool isActive;
  final DateTime dateJoined;
  final String rol;
  final String? telno;
  final bool isOnline;
  final String? profilFotograf;
  final String hataYapmaOrani;
  final String bakiye;
  final List<dynamic> groups;
  final List<dynamic> userPermissions;
  final SellerProfil? saticiProfili;
  final BuyerProfil? aliciProfili;
  final List<dynamic>? removeFavoriUrunler;

  User({
    required this.id,
    this.lastLogin,
    required this.isSuperuser,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.isStaff,
    required this.isActive,
    required this.dateJoined,
    required this.rol,
    this.telno,
    required this.isOnline,
    this.profilFotograf,
    required this.hataYapmaOrani,
    required this.bakiye,
    required this.groups,
    required this.userPermissions,
    this.saticiProfili,
    this.aliciProfili,
    this.removeFavoriUrunler,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Zorunlu alan doğrulamaları ve güvenli parse
    final dynamic idRaw = json['id'];
    final int parsedId = idRaw is int
        ? idRaw
        : int.tryParse(idRaw?.toString() ?? '') ?? 0;

    final String username = (json['username'] ?? '').toString();
    final String email = (json['email'] ?? '').toString();

    final String? lastLoginStr = json['last_login']?.toString();
    final DateTime? lastLogin =
        (lastLoginStr != null && lastLoginStr.isNotEmpty)
        ? DateTime.tryParse(lastLoginStr)
        : null;

    final String dateJoinedStr = (json['date_joined'] ?? '').toString();
    final DateTime dateJoined =
        DateTime.tryParse(dateJoinedStr) ?? DateTime.now();

    final bool isSuperuser = json['is_superuser'] == true;
    final bool isStaff = json['is_staff'] == true;
    final bool isActive = json['is_active'] == true;
    final bool isOnline = json['is_online'] == true;

    final String hataYapmaOrani = (json['hata_yapma_orani'] ?? '0.00')
        .toString();
    final String bakiye = (json['bakiye'] ?? '0.00').toString();

    final List<dynamic> groups = json['groups'] is List ? json['groups'] : [];
    final List<dynamic> userPermissions = json['user_permissions'] is List
        ? json['user_permissions']
        : [];

    return User(
      id: parsedId,
      lastLogin: lastLogin,
      isSuperuser: isSuperuser,
      username: username,
      firstName: (json['first_name'] ?? '').toString(),
      lastName: (json['last_name'] ?? '').toString(),
      email: email,
      isStaff: isStaff,
      isActive: isActive,
      dateJoined: dateJoined,
      rol: (json['rol'] ?? '').toString(),
      telno: json['telno']?.toString(),
      isOnline: isOnline,
      profilFotograf: json['profil_fotograf']?.toString(),
      hataYapmaOrani: hataYapmaOrani,
      bakiye: bakiye,
      groups: groups,
      userPermissions: userPermissions,
      saticiProfili: json['satici_profili'] != null
          ? SellerProfil.fromJson(json['satici_profili'])
          : null,
      aliciProfili: json['alici_profili'] != null
          ? BuyerProfil.fromJson(json['alici_profili'])
          : null,
      removeFavoriUrunler: json['remove_favori_urunler'] is List
          ? json['remove_favori_urunler']
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'last_login': lastLogin?.toIso8601String(),
      'is_superuser': isSuperuser,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'is_staff': isStaff,
      'is_active': isActive,
      'date_joined': dateJoined.toIso8601String(),
      'rol': rol,
      'telno': telno,
      'is_online': isOnline,
      'profil_fotograf': profilFotograf,
      'hata_yapma_orani': hataYapmaOrani,
      'bakiye': bakiye,
      'groups': groups,
      'user_permissions': userPermissions,
      'satici_profili': saticiProfili?.toJson(),
      'alici_profili': aliciProfili?.toJson(),
      'remove_favori_urunler': removeFavoriUrunler,
    };
  }
}
