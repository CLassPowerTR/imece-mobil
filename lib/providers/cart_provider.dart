// lib/providers/cart_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imecehub/models/products.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Cart Provider
final cartProvider = NotifierProvider<CartNotifier, CartState>(
  CartNotifier.new,
);

// Cart State
class CartState {
  final List<CartItem> items;
  final bool isLoading;
  final String? error;
  final double totalPrice;
  final int itemCount;

  CartState({
    this.items = const [],
    this.isLoading = false,
    this.error,
    this.totalPrice = 0.0,
    this.itemCount = 0,
  });

  CartState copyWith({
    List<CartItem>? items,
    bool? isLoading,
    String? error,
    double? totalPrice,
    int? itemCount,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      totalPrice: totalPrice ?? this.totalPrice,
      itemCount: itemCount ?? this.itemCount,
    );
  }
}

// Cart Item Model
class CartItem {
  final Product product;
  final int quantity;
  final double price;

  CartItem({
    required this.product,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': product.urunId,
      'quantity': quantity,
      'price': price,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json, Product product) {
    return CartItem(
      product: product,
      quantity: json['quantity'] ?? 1,
      price: json['price']?.toDouble() ?? 0.0,
    );
  }
}

// Cart Notifier
class CartNotifier extends Notifier<CartState> {
  static const String _cartKey = 'shopping_cart';

  @override
  CartState build() {
    // Başlangıçta sepeti yükle
    Future.microtask(() => loadCart());
    return CartState();
  }

  /// Sepeti SharedPreferences'tan yükle
  Future<void> loadCart() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final prefs = await SharedPreferences.getInstance();
      final cartData = prefs.getString(_cartKey);

      if (cartData == null || cartData.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          items: [],
          totalPrice: 0.0,
          itemCount: 0,
        );
        return;
      }

      final List<dynamic> cartJson = json.decode(cartData);
      final List<CartItem> items = [];
      double total = 0.0;
      int count = 0;

      for (var item in cartJson) {
        // Burada gerçek ürün bilgisini API'den çekmek gerekebilir
        // Şimdilik mock data kullanıyoruz
        // TODO: ApiService.fetchProduct(item['product_id']) ile gerçek ürünü çek
        count += (item['quantity'] as int? ?? 1);
        total += (item['price']?.toDouble() ?? 0.0) * (item['quantity'] ?? 1);
      }

      state = state.copyWith(
        isLoading: false,
        items: items,
        totalPrice: total,
        itemCount: count,
      );

      debugPrint('CartProvider: Sepet yüklendi - ${items.length} ürün');
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      debugPrint('CartProvider: Sepet yüklenirken hata: $e');
    }
  }

  /// Sepete ürün ekle
  Future<void> addToCart(Product product, {int quantity = 1}) async {
    try {
      final existingItemIndex = state.items.indexWhere(
        (item) => item.product.urunId == product.urunId,
      );

      List<CartItem> updatedItems;

      if (existingItemIndex >= 0) {
        // Ürün zaten sepette, miktarı artır
        updatedItems = List.from(state.items);
        final existingItem = updatedItems[existingItemIndex];
        updatedItems[existingItemIndex] = CartItem(
          product: existingItem.product,
          quantity: existingItem.quantity + quantity,
          price: existingItem.price,
        );
      } else {
        // Yeni ürün ekle
        updatedItems = [
          ...state.items,
          CartItem(
            product: product,
            quantity: quantity,
            price: double.tryParse(product.urunParakendeFiyat ?? '0') ?? 0.0,
          ),
        ];
      }

      await _saveCart(updatedItems);
      _updateState(updatedItems);

      debugPrint('CartProvider: Ürün sepete eklendi - ${product.urunAdi}');
    } catch (e) {
      state = state.copyWith(error: e.toString());
      debugPrint('CartProvider: Ürün eklenirken hata: $e');
      rethrow;
    }
  }

  /// Sepetten ürün çıkar
  Future<void> removeFromCart(int productId) async {
    try {
      final updatedItems = state.items
          .where((item) => item.product.urunId != productId)
          .toList();

      await _saveCart(updatedItems);
      _updateState(updatedItems);

      debugPrint('CartProvider: Ürün sepetten çıkarıldı - ID: $productId');
    } catch (e) {
      state = state.copyWith(error: e.toString());
      debugPrint('CartProvider: Ürün çıkarılırken hata: $e');
      rethrow;
    }
  }

  /// Ürün miktarını güncelle
  Future<void> updateQuantity(int productId, int newQuantity) async {
    try {
      if (newQuantity <= 0) {
        await removeFromCart(productId);
        return;
      }

      final updatedItems = state.items.map((item) {
        if (item.product.urunId == productId) {
          return CartItem(
            product: item.product,
            quantity: newQuantity,
            price: item.price,
          );
        }
        return item;
      }).toList();

      await _saveCart(updatedItems);
      _updateState(updatedItems);

      debugPrint('CartProvider: Ürün miktarı güncellendi - ID: $productId, Miktar: $newQuantity');
    } catch (e) {
      state = state.copyWith(error: e.toString());
      debugPrint('CartProvider: Miktar güncellenirken hata: $e');
      rethrow;
    }
  }

  /// Sepeti temizle
  Future<void> clearCart() async {
    try {
      await _saveCart([]);
      _updateState([]);

      debugPrint('CartProvider: Sepet temizlendi');
    } catch (e) {
      state = state.copyWith(error: e.toString());
      debugPrint('CartProvider: Sepet temizlenirken hata: $e');
      rethrow;
    }
  }

  /// Sepeti SharedPreferences'a kaydet
  Future<void> _saveCart(List<CartItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = items.map((item) => item.toJson()).toList();
    await prefs.setString(_cartKey, json.encode(cartJson));
  }

  /// State'i güncelle
  void _updateState(List<CartItem> items) {
    double total = 0.0;
    int count = 0;

    for (var item in items) {
      count += item.quantity;
      total += item.price * item.quantity;
    }

    state = state.copyWith(
      items: items,
      totalPrice: total,
      itemCount: count,
      error: null,
    );
  }

  /// Sepette ürün var mı kontrol et
  bool hasProduct(int productId) {
    return state.items.any((item) => item.product.urunId == productId);
  }

  /// Belirli bir ürünün miktarını getir
  int getQuantity(int productId) {
    final item = state.items.firstWhere(
      (item) => item.product.urunId == productId,
      orElse: () => CartItem(
        product: Product(
          urunId: 0,
          urunAdi: '',
          urunParakendeFiyat: '0',
          urunMinFiyat: '0',
          degerlendirmePuani: 0,
          satici: 0,
        ),
        quantity: 0,
        price: 0.0,
      ),
    );
    return item.quantity;
  }
}

