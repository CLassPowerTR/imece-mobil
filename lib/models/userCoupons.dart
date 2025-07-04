class UserCoupon {
  final int id;
  final int altLimit;
  final String miktar;
  final DateTime sonKullanmaTarihi;
  final int kullanici;
  final int satici;

  UserCoupon({
    required this.id,
    required this.altLimit,
    required this.miktar,
    required this.sonKullanmaTarihi,
    required this.kullanici,
    required this.satici,
  });

  factory UserCoupon.fromJson(Map<String, dynamic> json) {
    return UserCoupon(
      id: json['id'] as int,
      altLimit: json['alt_limit'] as int,
      miktar: json['miktar'] as String,
      sonKullanmaTarihi: DateTime.parse(json['son_kullanma_tarihi'] as String),
      kullanici: json['kullanici'] as int,
      satici: json['satici'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'alt_limit': altLimit,
      'miktar': miktar,
      'son_kullanma_tarihi': sonKullanmaTarihi.toIso8601String().split('T')[0],
      'kullanici': kullanici,
      'satici': satici,
    };
  }
}
