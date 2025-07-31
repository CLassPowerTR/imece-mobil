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
    return SellerProfil(
      id: json['id'] ?? 0,
      profilBanner: json['profil_banner'],
      profilTanitimYazisi: json['profil_tanitim_yazisi'],
      degerlendirmePuani: json['degerlendirme_puani'],
      magazaAdi: json['magaza_adi'],
      saticiVergiNumarasi: json['satici_vergi_numarasi'],
      saticiIban: json['satici_iban'],
      imeceOnay: json['imece_onay'] ?? false,
      imeceOnayLastDate: json['imece_onay_last_date'],
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
    return User(
      id: json['id'] ?? 0,
      lastLogin: json['last_login'] != null && json['last_login'] != ''
          ? DateTime.tryParse(json['last_login'])
          : null,
      isSuperuser: json['is_superuser'] ?? false,
      username: json['username'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      isStaff: json['is_staff'] ?? false,
      isActive: json['is_active'] ?? false,
      dateJoined: DateTime.tryParse(json['date_joined']) ?? DateTime.now(),
      rol: json['rol'] ?? '',
      telno: json['telno'],
      isOnline: json['is_online'] ?? false,
      profilFotograf: json['profil_fotograf'],
      hataYapmaOrani: json['hata_yapma_orani'] ?? '0.00',
      bakiye: json['bakiye'] ?? '0.00',
      groups: json['groups'] is List ? json['groups'] : [],
      userPermissions:
          json['user_permissions'] is List ? json['user_permissions'] : [],
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
