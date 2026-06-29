
part of '../products_screen.dart';

/// Aktif filtre chip'leri — Web ActiveFilters bileşeninin mobil karşılığı.
/// Seçili filtreleri yatay scroll ile gösterir, tıklayınca kaldırır.
class ProductsActiveFilters extends StatelessWidget {
  final ProductFilter filters;
  final ValueChanged<ProductFilter> onFiltersChanged;

  const ProductsActiveFilters({
    super.key,
    required this.filters,
    required this.onFiltersChanged,
  });

  @override
  Widget build(BuildContext context) {
    final chips = <_FilterChipData>[];

    // Arama chip'i
    if (filters.search != null && filters.search!.isNotEmpty) {
      chips.add(_FilterChipData(
        label: '"${filters.search}"',
        icon: Icons.search,
        onRemove: () => onFiltersChanged(filters.clearField('search')),
      ));
    }

    // Fiyat aralığı chip'i
    if ((filters.minFiyat != null && filters.minFiyat!.isNotEmpty) ||
        (filters.maxFiyat != null && filters.maxFiyat!.isNotEmpty)) {
      final min = filters.minFiyat ?? '0';
      final max = filters.maxFiyat ?? '∞';
      chips.add(_FilterChipData(
        label: '₺$min - ₺$max',
        icon: Icons.attach_money,
        onRemove: () => onFiltersChanged(filters.clearField('price')),
      ));
    }

    // Puan chip'i
    if (filters.minRating != null && filters.minRating!.isNotEmpty) {
      chips.add(_FilterChipData(
        label: '⭐ ${filters.minRating}+',
        icon: Icons.star,
        onRemove: () => onFiltersChanged(filters.clearField('minRating')),
      ));
    }

    // Kategori chip'leri
    for (final slug in filters.kategoriSlugs) {
      chips.add(_FilterChipData(
        label: slug,
        icon: Icons.category_outlined,
        onRemove: () => onFiltersChanged(filters.removeKategori(slug)),
      ));
    }

    // Dinamik attr filtre chip'leri
    for (final entry in filters.attrFilters.entries) {
      chips.add(_FilterChipData(
        label: entry.value,
        icon: Icons.tune,
        onRemove: () => onFiltersChanged(filters.removeAttr(entry.key)),
      ));
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...chips.map((chip) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: chip.onRemove,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            chip.label,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.close,
                            size: 14,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
                // Tümünü Temizle butonu
                GestureDetector(
                  onTap: () => onFiltersChanged(filters.reset()),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      'Temizle',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.red.shade400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChipData {
  final String label;
  final IconData icon;
  final VoidCallback onRemove;

  const _FilterChipData({
    required this.label,
    required this.icon,
    required this.onRemove,
  });
}
