class Category {
  final int kategoriId;
  final int anaKategoriAdi;
  final String altKategoriAdi;
  final String gorsel;

  Category({
    required this.kategoriId,
    required this.anaKategoriAdi,
    required this.altKategoriAdi,
    required this.gorsel,
  });

  // JSON'dan Category nesnesine dönüşüm
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      kategoriId: json['kategori_id'] as int? ?? 0,
      anaKategoriAdi: json['ana_kategori_adi'] as int? ?? 0,
      altKategoriAdi: json['alt_kategori_adi'] as String? ?? '',
      gorsel: json['gorsel'] as String? ?? '',
    );
  }

  // Category nesnesini JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'kategori_id': kategoriId,
      'ana_kategori_adi': anaKategoriAdi,
      'alt_kategori_adi': altKategoriAdi,
      'gorsel': gorsel,
    };
  }
}
