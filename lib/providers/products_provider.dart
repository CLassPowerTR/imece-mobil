import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imecehub/models/products.dart';
import 'package:imecehub/models/sellerProducts.dart';
import 'package:imecehub/services/api_service.dart';

const _allProductsKey = '__all_products__';

class ProductsRepository {
  final Map<String, List<Product>> _productListCache = {};
  final Map<int, Product> _productCache = {};
  final Map<int, List<SellerProducts>> _sellerProductsCache = {};

  Future<List<Product>> fetchProducts({
    String? categoryId,
    bool forceRefresh = false,
  }) async {
    final key = categoryId ?? _allProductsKey;
    if (!forceRefresh && _productListCache.containsKey(key)) {
      return _productListCache[key]!;
    }
    final products = await ApiService.fetchProducts(id: categoryId);
    _productListCache[key] = products;
    return products;
  }

  Future<Product> fetchProduct(
    int productId, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _productCache.containsKey(productId)) {
      return _productCache[productId]!;
    }
    final product = await ApiService.fetchProduct(productId);
    _productCache[productId] = product;
    return product;
  }

  Future<List<SellerProducts>> fetchSellerProducts(
    int sellerId, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _sellerProductsCache.containsKey(sellerId)) {
      return _sellerProductsCache[sellerId]!;
    }
    final products = await ApiService.fetchSellerProducts(sellerId);
    _sellerProductsCache[sellerId] = products;
    return products;
  }

  void invalidateProducts({String? categoryId}) {
    final key = categoryId ?? _allProductsKey;
    _productListCache.remove(key);
  }

  void invalidateProduct(int productId) {
    _productCache.remove(productId);
  }

  void invalidateSellerProducts(int sellerId) {
    _sellerProductsCache.remove(sellerId);
  }

  void clear() {
    _productListCache.clear();
    _productCache.clear();
    _sellerProductsCache.clear();
  }
}

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  final repository = ProductsRepository();
  ref.onDispose(repository.clear);
  return repository;
});

final productsProvider = FutureProvider.family<List<Product>, String?>((
  ref,
  categoryId,
) async {
  final repository = ref.watch(productsRepositoryProvider);
  return repository.fetchProducts(categoryId: categoryId);
});

final productProvider = FutureProvider.family<Product, int>((
  ref,
  productId,
) async {
  final repository = ref.watch(productsRepositoryProvider);
  return repository.fetchProduct(productId);
});

final sellerProductsProvider = FutureProvider.family<List<SellerProducts>, int>(
  (ref, sellerId) async {
    final repository = ref.watch(productsRepositoryProvider);
    return repository.fetchSellerProducts(sellerId);
  },
);
