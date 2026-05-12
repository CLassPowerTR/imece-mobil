class Category {
  final int kategoriId;
  final String name;
  final int? parent;
  final String? parentName;
  final String? slug;
  final String? icon;
  final bool isActive;
  final List<dynamic>? attributeTemplate;
  final int anaKategoriAdi;
  final String? altKategoriAdi;
  final String? gorsel;

  Category({
    required this.kategoriId,
    required this.name,
    this.parent,
    this.parentName,
    this.slug,
    this.icon,
    required this.isActive,
    this.attributeTemplate,
    required this.anaKategoriAdi,
    this.altKategoriAdi,
    this.gorsel,
  });

  // JSON'dan Category nesnesine dönüşüm
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      kategoriId: json['kategori_id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      parent: json['parent'] as int?,
      parentName: json['parent_name'] as String?,
      slug: json['slug'] as String?,
      icon: json['icon'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      attributeTemplate: json['attribute_template'] as List<dynamic>?,
      anaKategoriAdi: json['ana_kategori_adi'] as int? ?? 0,
      altKategoriAdi: json['alt_kategori_adi'] as String?,
      gorsel: json['gorsel'] as String?,
    );
  }

  // Category nesnesini JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'kategori_id': kategoriId,
      'name': name,
      'parent': parent,
      'parent_name': parentName,
      'slug': slug,
      'icon': icon,
      'is_active': isActive,
      'attribute_template': attributeTemplate,
      'ana_kategori_adi': anaKategoriAdi,
      'alt_kategori_adi': altKategoriAdi,
      'gorsel': gorsel,
    };
  }
}
