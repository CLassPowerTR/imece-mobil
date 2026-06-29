
part of '../products_screen.dart';

/// Bottom Sheet filtre paneli — Web FilterPanel bileşeninin mobil karşılığı.
/// Kategoriler, fiyat aralığı, dinamik filtreler ve puan filtreleri içerir.
class ProductsFilterSheet extends StatefulWidget {
  final ProductFilter filters;
  final List<FilterGroup> dynamicFilters;
  final ValueChanged<ProductFilter> onApply;

  const ProductsFilterSheet({
    super.key,
    required this.filters,
    required this.dynamicFilters,
    required this.onApply,
  });

  /// Bottom sheet olarak gösterir
  static Future<void> show(
    BuildContext context, {
    required ProductFilter filters,
    required List<FilterGroup> dynamicFilters,
    required ValueChanged<ProductFilter> onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (ctx, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: ProductsFilterSheet(
            filters: filters,
            dynamicFilters: dynamicFilters,
            onApply: (newFilters) {
              onApply(newFilters);
              Navigator.pop(ctx);
            },
          ),
        ),
      ),
    );
  }

  @override
  State<ProductsFilterSheet> createState() => _ProductsFilterSheetState();
}

class _ProductsFilterSheetState extends State<ProductsFilterSheet> {
  late ProductFilter _localFilters;
  final Map<String, bool> _expandedSections = {
    'categories': true,
    'price': true,
    'rating': true,
  };
  List<Category> _categories = [];
  List<Category> _categoryPath = [];
  bool _categoriesLoading = true;

  List<Category> _findPath(List<Category> cats, String targetSlug, List<Category> currentPath) {
    for (var cat in cats) {
      if (cat.slug == targetSlug) return [...currentPath, cat];
      if (cat.children != null) {
        final path = _findPath(cat.children!, targetSlug, [...currentPath, cat]);
        if (path.isNotEmpty) return path;
      }
    }
    return [];
  }

  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  static const _colorMap = {
    'Siyah': Color(0xFF000000),
    'Beyaz': Color(0xFFFFFFFF),
    'Kırmızı': Color(0xFFFF0000),
    'Mavi': Color(0xFF0000FF),
    'Yeşil': Color(0xFF008000),
    'Sarı': Color(0xFFFFFF00),
    'Turuncu': Color(0xFFFFA500),
    'Mor': Color(0xFF800080),
    'Pembe': Color(0xFFFFC0CB),
    'Gri': Color(0xFF808080),
    'Kahverengi': Color(0xFFA52A2A),
    'Lacivert': Color(0xFF000080),
    'Bordo': Color(0xFF800000),
    'Bej': Color(0xFFF5F5DC),
    'Altın': Color(0xFFFFD700),
    'Gümüş': Color(0xFFC0C0C0),
  };

  @override
  void initState() {
    super.initState();
    _localFilters = widget.filters;
    _minPriceController.text = widget.filters.minFiyat ?? '';
    _maxPriceController.text = widget.filters.maxFiyat ?? '';
    _fetchCategories();
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  Future<void> _fetchCategories() async {
    try {
      final cats = await ApiService.fetchCategoriesTree();
      if (mounted) {
        setState(() {
          _categories = cats;
          _categoriesLoading = false;
          if (_localFilters.kategoriSlugs.isNotEmpty) {
            final path = _findPath(cats, _localFilters.kategoriSlugs.first, []);
            if (path.isNotEmpty) {
              if (path.last.children != null && path.last.children!.isNotEmpty) {
                _categoryPath = path;
              } else {
                _categoryPath = path.sublist(0, path.length - 1);
              }
            }
          }
        });
      }
    } catch (e) {
      debugPrint('Kategori yükleme hatası: $e');
      if (mounted) {
        setState(() => _categoriesLoading = false);
      }
    }
  }

  void _toggleSection(String section) {
    setState(() {
      _expandedSections[section] = !(_expandedSections[section] ?? false);
    });
  }

  void _popCategory() {
    setState(() {
      if (_categoryPath.isNotEmpty) {
        _categoryPath.removeLast();
        if (_categoryPath.isNotEmpty) {
          _localFilters = _localFilters.copyWith(kategoriSlugs: [_categoryPath.last.slug!]);
        } else {
          _localFilters = _localFilters.copyWith(kategoriSlugs: []);
        }
      }
    });
  }

  void _handleCategorySelect(Category cat) {
    setState(() {
      final slug = cat.slug ?? '';
      final current = _localFilters.kategoriSlugs;
      if (current.contains(slug)) {
        if (_categoryPath.isNotEmpty) {
          _localFilters = _localFilters.copyWith(kategoriSlugs: [_categoryPath.last.slug!]);
        } else {
          _localFilters = _localFilters.copyWith(kategoriSlugs: []);
        }
      } else {
        _localFilters = _localFilters.copyWith(kategoriSlugs: [slug]);
        if (cat.children != null && cat.children!.isNotEmpty) {
          _categoryPath.add(cat);
        }
      }
    });
  }

  void _handleRatingToggle(int rating) {
    setState(() {
      if (_localFilters.minRating == rating.toString()) {
        _localFilters = _localFilters.clearField('minRating');
      } else {
        _localFilters = _localFilters.copyWith(minRating: rating.toString());
      }
    });
  }

  void _handleAttrToggle(String key, String val) {
    setState(() {
      final newAttrs = Map<String, String>.from(_localFilters.attrFilters);
      if (newAttrs[key] == val) {
        newAttrs.remove(key);
      } else {
        newAttrs[key] = val;
      }
      _localFilters = _localFilters.copyWith(attrFilters: newAttrs);
    });
  }

  void _clearAll() {
    setState(() {
      _localFilters = const ProductFilter();
      _minPriceController.clear();
      _maxPriceController.clear();
    });
  }

  void _applyFilters() {
    // Fiyat input'larını al
    final minP = _minPriceController.text.trim();
    final maxP = _maxPriceController.text.trim();
    _localFilters = _localFilters.copyWith(
      minFiyat: minP.isEmpty ? null : minP,
      maxFiyat: maxP.isEmpty ? null : maxP,
    );
    widget.onApply(_localFilters);
  }

  // ── Section Header ──
  Widget _buildSectionHeader(String label, String sectionKey) {
    final isOpen = _expandedSections[sectionKey] ?? false;
    return GestureDetector(
      onTap: () => _toggleSection(sectionKey),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            AnimatedRotation(
              turns: isOpen ? 0.5 : 0,
              duration: const Duration(milliseconds: 250),
              child: Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Categories Section ──
  Widget _buildCategories() {
    final currentList = _categoryPath.isEmpty 
        ? _categories 
        : _categoryPath.last.children ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Kategoriler', 'categories'),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: _categoriesLoading
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                )
              : Column(
                  children: [
                    if (_categoryPath.isNotEmpty)
                      GestureDetector(
                        onTap: _popCategory,
                        child: Semantics(
                          label: "Üst kategoriye dön",
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0, top: 6, bottom: 12),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 16,
                                  color: AppColors.primary(context),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _categoryPath.length == 1
                                        ? "Tüm Kategoriler"
                                        : _categoryPath[_categoryPath.length - 2].name,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary(context),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ...currentList.map((cat) => _buildCategoryItem(cat)).toList(),
                  ],
                ),
          crossFadeState: (_expandedSections['categories'] ?? false)
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        ),
        Divider(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3)),
      ],
    );
  }

  Widget _buildCategoryItem(Category cat) {
    final isSelected = _localFilters.kategoriSlugs.contains(cat.slug);
    final hasChildren = cat.children != null && cat.children!.isNotEmpty;

    return Semantics(
      label: "${cat.name} kategorisi, ${isSelected ? 'seçili' : 'seçili değil'}",
      button: true,
      child: GestureDetector(
        onTap: () => _handleCategorySelect(cat),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 6, bottom: 6),
          child: Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary(context)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary(context)
                        : Theme.of(context).colorScheme.outline.withOpacity(0.4),
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  cat.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected
                        ? AppColors.primary(context)
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              if (hasChildren)
                Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: Theme.of(context).colorScheme.outline,
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Price Section ──
  Widget _buildPrice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Fiyat Aralığı', 'price'),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minPriceController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Min ₺',
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                        fontWeight: FontWeight.w500,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.primary(context),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '—',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.outline,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _maxPriceController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Max ₺',
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                        fontWeight: FontWeight.w500,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.primary(context),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          crossFadeState: (_expandedSections['price'] ?? false)
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        ),
        Divider(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3)),
      ],
    );
  }

  // ── Dynamic Attribute Filters ──
  Widget _buildDynamicFilters() {
    if (widget.dynamicFilters.isEmpty) return const SizedBox.shrink();

    return Column(
      children: widget.dynamicFilters.map((group) {
        final sectionKey = group.slug;
        final isColor = group.label.toLowerCase().contains('renk');
        _expandedSections.putIfAbsent(sectionKey, () => false);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(group.label, sectionKey),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: isColor ? _buildColorGrid(group) : _buildValueList(group),
              ),
              crossFadeState: (_expandedSections[sectionKey] ?? false)
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
            ),
            Divider(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3)),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildColorGrid(FilterGroup group) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: group.values.map((val) {
        final isActive = _localFilters.attrFilters[group.slug] == val;
        final color = _colorMap[val] ?? const Color(0xFFCCCCCC);
        return GestureDetector(
          onTap: () => _handleAttrToggle(group.slug, val),
          child: Tooltip(
            message: val,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive ? AppColors.primary(context) : Colors.grey.shade300,
                  width: isActive ? 3 : 1.5,
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  border: color == const Color(0xFFFFFFFF)
                      ? Border.all(color: Colors.grey.shade300, width: 0.5)
                      : null,
                ),
                child: isActive
                    ? Icon(
                        Icons.check,
                        size: 14,
                        color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                      )
                    : null,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildValueList(FilterGroup group) {
    return Column(
      children: group.values.map((val) {
        final isActive = _localFilters.attrFilters[group.slug] == val;
        return GestureDetector(
          onTap: () => _handleAttrToggle(group.slug, val),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary(context) : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isActive
                          ? AppColors.primary(context)
                          : Theme.of(context).colorScheme.outline.withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                  child: isActive
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 10),
                Text(
                  val,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                    color: isActive
                        ? AppColors.primary(context)
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Rating Section ──
  Widget _buildRating() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Puan', 'rating'),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Column(
            children: [4, 3, 2].map((star) {
              final isActive = _localFilters.minRating == star.toString();
              return GestureDetector(
                onTap: () => _handleRatingToggle(star),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primary(context) : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isActive
                                ? AppColors.primary(context)
                                : Theme.of(context).colorScheme.outline.withOpacity(0.4),
                            width: 2,
                          ),
                        ),
                        child: isActive
                            ? const Icon(Icons.check, size: 14, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Row(
                        children: List.generate(5, (i) {
                          return Icon(
                            i < star ? Icons.star : Icons.star_border,
                            size: 18,
                            color: i < star ? Colors.amber : Colors.grey.shade300,
                          );
                        }),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        've üzeri',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          crossFadeState: (_expandedSections['rating'] ?? false)
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Handle bar
        Container(
          margin: const EdgeInsets.only(top: 12),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.outlineVariant,
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary(context).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.tune,
                      size: 20,
                      color: AppColors.primary(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Filtrele',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.close,
                    size: 22,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Filter content (scrollable)
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildCategories(),
                _buildPrice(),
                _buildDynamicFilters(),
                _buildRating(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),

        // Bottom action buttons
        Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3),
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                // Temizle butonu
                Expanded(
                  child: Semantics(
                    button: true,
                    label: "Filtreleri temizle",
                    child: GestureDetector(
                      onTap: _clearAll,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Temizle',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Sonuçları Gör butonu
                Expanded(
                  flex: 2,
                  child: Semantics(
                    button: true,
                    label: "Filtre sonuçlarını gör",
                    child: GestureDetector(
                      onTap: _applyFilters,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.primary(context),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary(context).withOpacity(0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Sonuçları Gör',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
