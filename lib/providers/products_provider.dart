import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imecehub/models/products.dart';
import 'package:imecehub/models/sellerProducts.dart';
import 'package:imecehub/models/campaigns.dart';
import 'package:imecehub/services/api_service.dart';

const _allProductsKey = '__all_products__';

class ProductsRepository {
  final Map<String, List<Product>> _productListCache = {};
  final Map<int, Product> _productCache = {};
  final Map<int, List<SellerProducts>> _sellerProductsCache = {};
  List<Product>? _populerProductsCache;
  Campaigns? _campaignsCache;

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

  Future<List<Product>> fetchPopulerProducts({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _populerProductsCache != null) {
      return _populerProductsCache!;
    }
    final products = await ApiService.fetchPopulerProducts();
    _populerProductsCache = products;
    return products;
  }

  Future<Campaigns> fetchCampaigns({bool forceRefresh = false}) async {
    if (!forceRefresh && _campaignsCache != null) {
      return _campaignsCache!;
    }
    final campaigns = await ApiService.fetchProductsCampaings();
    _campaignsCache = campaigns;
    return campaigns;
  }

  Future<Map<String, dynamic>> updateProduct(
    int productId,
    Map<String, dynamic> productPayload,
  ) async {
    // Zorunlu alanları kontrol et
    final requiredFields = [
      'urun_adi',
      'aciklama',
      'urun_perakende_fiyati',
      'urun_min_fiyati',
      'degerlendirme_puani',
      'satici',
    ];

    for (final field in requiredFields) {
      if (!productPayload.containsKey(field) || productPayload[field] == null) {
        throw Exception('$field alanı zorunludur.');
      }
    }

    // API'ye update isteği gönder
    final result = await ApiService.putSellerUpdateProduct(
      productId,
      productPayload,
    );

    // Başarılı olduktan sonra cache'i temizle ve yeniden yükle
    invalidateProduct(productId);

    // Ürünü yeniden yükle
    await fetchProduct(productId, forceRefresh: true);

    // Eğer satici bilgisi varsa, seller products cache'ini de temizle ve yeniden yükle
    int? sellerId;
    if (productPayload.containsKey('satici') &&
        productPayload['satici'] != null) {
      sellerId = productPayload['satici'] is int
          ? productPayload['satici'] as int
          : int.tryParse(productPayload['satici'].toString());
      if (sellerId != null) {
        invalidateSellerProducts(sellerId);
        // Seller products'ı da yeniden yükle
        await fetchSellerProducts(sellerId, forceRefresh: true);
      }
    }

    return result;
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

  void invalidatePopulerProducts() {
    _populerProductsCache = null;
  }

  void invalidateCampaigns() {
    _campaignsCache = null;
  }

  void clear() {
    _productListCache.clear();
    _productCache.clear();
    _sellerProductsCache.clear();
    _populerProductsCache = null;
    _campaignsCache = null;
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
    return ApiService.fetchSellerProducts(sellerId);
  },
);

final populerProductsProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productsRepositoryProvider);
  return repository.fetchPopulerProducts();
});

final campaignsProvider = FutureProvider<Campaigns>((ref) async {
  final repository = ref.watch(productsRepositoryProvider);
  return repository.fetchCampaigns();
});
