/// Ürün listeleme sayfası için filtre state modeli.
/// Web tarafındaki useFilterState hook'unun Flutter karşılığı.
class ProductFilter {
  final String? search;
  final String sort;
  final String? minFiyat;
  final String? maxFiyat;
  final String? minRating;
  final List<String> kategoriSlugs;
  final Map<String, String> attrFilters; // key: "renk", value: "Kırmızı"

  const ProductFilter({
    this.search,
    this.sort = 'popular',
    this.minFiyat,
    this.maxFiyat,
    this.minRating,
    this.kategoriSlugs = const [],
    this.attrFilters = const {},
  });

  ProductFilter copyWith({
    String? search,
    String? sort,
    String? minFiyat,
    String? maxFiyat,
    String? minRating,
    List<String>? kategoriSlugs,
    Map<String, String>? attrFilters,
  }) {
    return ProductFilter(
      search: search ?? this.search,
      sort: sort ?? this.sort,
      minFiyat: minFiyat ?? this.minFiyat,
      maxFiyat: maxFiyat ?? this.maxFiyat,
      minRating: minRating ?? this.minRating,
      kategoriSlugs: kategoriSlugs ?? this.kategoriSlugs,
      attrFilters: attrFilters ?? this.attrFilters,
    );
  }

  /// Filtre değeri temizleme — null olarak set etmek için
  ProductFilter clearField(String field) {
    switch (field) {
      case 'search':
        return ProductFilter(
          sort: sort, minFiyat: minFiyat, maxFiyat: maxFiyat,
          minRating: minRating, kategoriSlugs: kategoriSlugs,
          attrFilters: attrFilters,
        );
      case 'price':
        return ProductFilter(
          search: search, sort: sort,
          minRating: minRating, kategoriSlugs: kategoriSlugs,
          attrFilters: attrFilters,
        );
      case 'minRating':
        return ProductFilter(
          search: search, sort: sort, minFiyat: minFiyat, maxFiyat: maxFiyat,
          kategoriSlugs: kategoriSlugs, attrFilters: attrFilters,
        );
      default:
        return this;
    }
  }

  /// Belirli bir attr_ filtresini kaldır
  ProductFilter removeAttr(String key) {
    final newAttrs = Map<String, String>.from(attrFilters);
    newAttrs.remove(key);
    return copyWith(attrFilters: newAttrs);
  }

  /// Belirli bir kategoriyi kaldır
  ProductFilter removeKategori(String slug) {
    final newList = kategoriSlugs.where((s) => s != slug).toList();
    return copyWith(kategoriSlugs: newList);
  }

  /// Tüm filtreleri sıfırla
  ProductFilter reset() {
    return const ProductFilter();
  }

  /// Aktif filtre sayısı (badge için)
  int get activeFilterCount {
    int count = 0;
    if (search != null && search!.isNotEmpty) count++;
    if (minFiyat != null && minFiyat!.isNotEmpty) count++;
    if (maxFiyat != null && maxFiyat!.isNotEmpty) count++;
    if (minRating != null && minRating!.isNotEmpty) count++;
    count += kategoriSlugs.length;
    count += attrFilters.length;
    return count;
  }

  /// Herhangi bir filtre aktif mi?
  bool get hasActiveFilters => activeFilterCount > 0;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProductFilter) return false;
    return search == other.search &&
        sort == other.sort &&
        minFiyat == other.minFiyat &&
        maxFiyat == other.maxFiyat &&
        minRating == other.minRating &&
        _listEquals(kategoriSlugs, other.kategoriSlugs) &&
        _mapEquals(attrFilters, other.attrFilters);
  }

  @override
  int get hashCode => Object.hash(
    search, sort, minFiyat, maxFiyat, minRating,
    Object.hashAll(kategoriSlugs),
    Object.hashAll(attrFilters.entries),
  );

  static bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  static bool _mapEquals(Map<String, String> a, Map<String, String> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (a[key] != b[key]) return false;
    }
    return true;
  }
}
