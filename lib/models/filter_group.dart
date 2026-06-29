/// Dinamik filtre grubu modeli.
/// GET /api/products/urunler/available_filters/ endpoint'inden dönen
/// filtreleri temsil eder (renk, beden vb.)
class FilterGroup {
  final String slug;
  final String label;
  final List<String> values;

  const FilterGroup({
    required this.slug,
    required this.label,
    required this.values,
  });

  factory FilterGroup.fromJson(Map<String, dynamic> json) {
    return FilterGroup(
      slug: json['slug'] as String? ?? '',
      label: json['label'] as String? ?? '',
      values: (json['values'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'label': label,
      'values': values,
    };
  }
}
