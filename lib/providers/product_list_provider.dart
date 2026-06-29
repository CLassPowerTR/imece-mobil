import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imecehub/models/products.dart';
import 'package:imecehub/models/product_filter.dart';
import 'package:imecehub/models/filter_group.dart';
import 'package:imecehub/services/api_service.dart';

/// Ürün listeleme sayfasının tüm state'ini tutan model.
class ProductListState {
  final List<Product> products;
  final int totalItems;
  final int currentPage;
  final bool hasMore;
  final bool isLoading;
  final bool isLoadingMore;
  final ProductFilter filters;
  final List<FilterGroup> dynamicFilters;
  final String? errorMessage;

  const ProductListState({
    this.products = const [],
    this.totalItems = 0,
    this.currentPage = 1,
    this.hasMore = false,
    this.isLoading = true,
    this.isLoadingMore = false,
    this.filters = const ProductFilter(),
    this.dynamicFilters = const [],
    this.errorMessage,
  });

  ProductListState copyWith({
    List<Product>? products,
    int? totalItems,
    int? currentPage,
    bool? hasMore,
    bool? isLoading,
    bool? isLoadingMore,
    ProductFilter? filters,
    List<FilterGroup>? dynamicFilters,
    String? errorMessage,
  }) {
    return ProductListState(
      products: products ?? this.products,
      totalItems: totalItems ?? this.totalItems,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      filters: filters ?? this.filters,
      dynamicFilters: dynamicFilters ?? this.dynamicFilters,
      errorMessage: errorMessage,
    );
  }
}

/// Ürün listesi state yöneticisi.
/// Web tarafındaki Products component'inin state logic'inin karşılığı.
class ProductListNotifier extends Notifier<ProductListState> {
  static const int _pageSize = 20;

  @override
  ProductListState build() => const ProductListState();

  /// İlk yükleme veya filtre değişikliğinde çağrılır.
  Future<void> fetchProducts({bool isRefresh = false}) async {
    if (!isRefresh) {
      state = state.copyWith(isLoading: true, errorMessage: null);
    }

    try {
      final result = await ApiService.fetchPaginatedProducts(
        page: 1,
        pageSize: _pageSize,
        search: state.filters.search,
        sort: state.filters.sort,
        minFiyat: state.filters.minFiyat,
        maxFiyat: state.filters.maxFiyat,
        minRating: state.filters.minRating,
        kategoriSlugs: state.filters.kategoriSlugs,
        attrFilters: state.filters.attrFilters,
      );

      state = state.copyWith(
        products: result.results,
        totalItems: result.count,
        currentPage: 1,
        hasMore: result.next != null,
        isLoading: false,
        isLoadingMore: false,
      );
    } catch (e) {
      debugPrint('Ürün yükleme hatası: $e');
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Infinite scroll ile sonraki sayfayı yükler.
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore || state.isLoading) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final nextPage = state.currentPage + 1;
      final result = await ApiService.fetchPaginatedProducts(
        page: nextPage,
        pageSize: _pageSize,
        search: state.filters.search,
        sort: state.filters.sort,
        minFiyat: state.filters.minFiyat,
        maxFiyat: state.filters.maxFiyat,
        minRating: state.filters.minRating,
        kategoriSlugs: state.filters.kategoriSlugs,
        attrFilters: state.filters.attrFilters,
      );

      // Duplicate kontrolü
      final existingIds = state.products.map((p) => p.urunId).toSet();
      final newItems = result.results
          .where((p) => !existingIds.contains(p.urunId))
          .toList();

      state = state.copyWith(
        products: [...state.products, ...newItems],
        totalItems: result.count,
        currentPage: nextPage,
        hasMore: result.next != null,
        isLoadingMore: false,
      );
    } catch (e) {
      debugPrint('Sayfa yükleme hatası: $e');
      state = state.copyWith(isLoadingMore: false);
    }
  }

  /// Filtreleri günceller ve listeyi sıfırdan yükler.
  Future<void> updateFilters(ProductFilter newFilters) async {
    if (state.filters == newFilters) return;
    state = state.copyWith(filters: newFilters, currentPage: 1);
    await Future.wait([
      fetchProducts(),
      fetchAvailableFilters(),
    ]);
  }

  /// Tüm filtreleri sıfırlar.
  Future<void> resetFilters() async {
    await updateFilters(const ProductFilter());
  }

  /// Sıralama günceller.
  Future<void> updateSort(String sort) async {
    if (state.filters.sort == sort) return;
    await updateFilters(state.filters.copyWith(sort: sort));
  }

  /// Arama metnini günceller.
  Future<void> updateSearch(String? search) async {
    await updateFilters(state.filters.copyWith(
      search: search,
    ));
  }

  /// Dinamik filtre seçeneklerini API'den çeker.
  Future<void> fetchAvailableFilters() async {
    try {
      final result = await ApiService.fetchAvailableFilters(
        search: state.filters.search,
        kategoriSlugs: state.filters.kategoriSlugs,
        attrFilters: state.filters.attrFilters,
      );
      final groups = result.map((json) => FilterGroup.fromJson(json)).toList();
      state = state.copyWith(dynamicFilters: groups);
    } catch (e) {
      debugPrint('Dinamik filtreler alınamadı: $e');
    }
  }

  /// Başlangıç parametreleriyle yükleme (search veya category ile sayfa açılışı).
  Future<void> initialize({String? search, String? category}) async {
    ProductFilter initialFilter = const ProductFilter();
    if (search != null && search.isNotEmpty) {
      initialFilter = initialFilter.copyWith(search: search);
    }
    if (category != null && category.isNotEmpty) {
      initialFilter = initialFilter.copyWith(kategoriSlugs: [category]);
    }
    state = state.copyWith(filters: initialFilter);
    await Future.wait([
      fetchProducts(),
      fetchAvailableFilters(),
    ]);
  }
}

final productListProvider =
    NotifierProvider<ProductListNotifier, ProductListState>(
  ProductListNotifier.new,
);
