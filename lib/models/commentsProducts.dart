class CommentsProduct {
  final String yorum;
  final int puan;
  final int urun;
  final int kullanici;
  final int magaza;

  CommentsProduct({
    required this.yorum,
    required this.puan,
    required this.urun,
    required this.kullanici,
    required this.magaza,
  });

  factory CommentsProduct.fromJson(Map<String, dynamic> json) {
    return CommentsProduct(
      yorum: json['yorum'] as String,
      puan: json['puan'] as int,
      urun: json['urun'] as int,
      kullanici: json['kullanici'] as int,
      magaza: json['magaza'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'yorum': yorum,
      'puan': puan,
      'urun': urun,
      'kullanici': kullanici,
      'magaza': magaza,
    };
  }
}
