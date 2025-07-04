class UserAdress {
  final int id;
  final String ulke;
  final String il;
  final String ilce;
  final String mahalle;
  final String postaKodu;
  final String adresSatiri1;
  final String adresSatiri2;
  final String baslik;
  final String adresTipi;
  final bool varsayilanAdres;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int kullanici;

  UserAdress({
    required this.id,
    required this.ulke,
    required this.il,
    required this.ilce,
    required this.mahalle,
    required this.postaKodu,
    required this.adresSatiri1,
    required this.adresSatiri2,
    required this.baslik,
    required this.adresTipi,
    required this.varsayilanAdres,
    required this.createdAt,
    required this.updatedAt,
    required this.kullanici,
  });

  factory UserAdress.fromJson(Map<String, dynamic> json) {
    return UserAdress(
      id: json['id'] as int,
      ulke: json['ulke'] as String,
      il: json['il'] as String,
      ilce: json['ilce'] as String,
      mahalle: json['mahalle'] as String,
      postaKodu: json['posta_kodu'] as String,
      adresSatiri1: json['adres_satiri_1'] as String,
      adresSatiri2: json['adres_satiri_2'] as String,
      baslik: json['baslik'] as String,
      adresTipi: json['adres_tipi'] as String,
      varsayilanAdres: json['varsayilan_adres'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      kullanici: json['kullanici'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ulke': ulke,
      'il': il,
      'ilce': ilce,
      'mahalle': mahalle,
      'posta_kodu': postaKodu,
      'adres_satiri_1': adresSatiri1,
      'adres_satiri_2': adresSatiri2,
      'baslik': baslik,
      'adres_tipi': adresTipi,
      'varsayilan_adres': varsayilanAdres,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'kullanici': kullanici,
    };
  }
}
