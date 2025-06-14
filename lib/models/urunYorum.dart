class UrunYorum {
  final int id;
  final String yorum;
  final dynamic puan;
  final DateTime olusturulmaTarihi;
  final int urun;
  final int kullanici;
  final int magaza;

  UrunYorum({
    required this.id,
    required this.yorum,
    required this.puan,
    required this.olusturulmaTarihi,
    required this.urun,
    required this.kullanici,
    required this.magaza,
  });

  factory UrunYorum.fromJson(Map<String, dynamic> json) {
    return UrunYorum(
      id: json['id'],
      yorum: json['yorum'],
      puan: json['puan'],
      olusturulmaTarihi: DateTime.parse(json['olusturulma_tarihi']),
      urun: json['urun'],
      kullanici: json['kullanici'],
      magaza: json['magaza'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'yorum': yorum,
      'puan': puan,
      'olusturulma_tarihi': olusturulmaTarihi.toIso8601String(),
      'urun': urun,
      'kullanici': kullanici,
      'magaza': magaza,
    };
  }
}
