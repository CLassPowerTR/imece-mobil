import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/widgets.dart';
import 'package:imecehub/models/users.dart';
import 'package:imecehub/providers/cart_provider.dart';
import 'package:imecehub/providers/products_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:imecehub/services/api_service.dart';

final loginStateProvider = Provider<bool>((ref) {
  return ref.watch(userProvider) != null;
});

final userProvider = NotifierProvider<UserNotifier, User?>(UserNotifier.new);

class UserNotifier extends Notifier<User?> {
  bool _initialized = false;
  late final WidgetsBindingObserver _lifecycleObserver;

  @override
  User? build() {
    if (!_initialized) {
      _initialized = true;
      _lifecycleObserver = _AuthLifecycleObserver(
        onResumed: () async {
          if (state != null) {
            try {
              await ApiService.putUserUpdate({'is_online': true});
              debugPrint('Auth: App resumed - Kullanıcı online yapıldı');
            } catch (e) {
              debugPrint(
                'Auth: App resumed - Online durumu güncellenemedi: $e',
              );
            }
          }
        },
        onPausedOrInactive: () async {
          if (state != null) {
            try {
              await ApiService.putUserUpdate({'is_online': false});
              debugPrint(
                'Auth: App paused/inactive - Kullanıcı offline yapıldı',
              );
            } catch (e) {
              debugPrint(
                'Auth: App paused - Offline durumu güncellenemedi: $e',
              );
            }
          }
        },
      );
      WidgetsBinding.instance.addObserver(_lifecycleObserver);
      ref.onDispose(() {
        WidgetsBinding.instance.removeObserver(_lifecycleObserver);
      });
      Future.microtask(initialize);
    }
    return null;
  }

  void setUser(User user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accesToken') ?? '';
    debugPrint('token: $token');
    if (token.isEmpty) {
      clearUser();
      return;
    }

    // Kullanıcı verilerini çek
    await fetchUserMe();

    // Kullanıcı başarıyla yüklendiyse online yap
    if (state != null) {
      try {
        await ApiService.putUserUpdate({'is_online': true});
        debugPrint('Auth: Kullanıcı online durumu güncellendi');
      } catch (e) {
        debugPrint('Auth: Online durumu güncellenemedi: $e');
      }
    }
  }

  Future<void> login({required String email, required String password}) async {
    await ApiService.fetchUserLogin(email, password);
    await fetchUserMe();

    // Login sonrası online yap
    if (state != null) {
      try {
        await ApiService.putUserUpdate({'is_online': true});
        debugPrint('Auth: Login sonrası kullanıcı online yapıldı');
      } catch (e) {
        debugPrint('Auth: Login sonrası online durumu güncellenemedi: $e');
      }
    }
  }

  Future<void> register({
    required String email,
    required String username,
    required String password,
  }) async {
    await ApiService.fetchUserRegister(email, username, password);
    await fetchUserMe();

    // Register sonrası online yap
    if (state != null) {
      try {
        await ApiService.putUserUpdate({'is_online': true});
        debugPrint('Auth: Register sonrası kullanıcı online yapıldı');
      } catch (e) {
        debugPrint('Auth: Register sonrası online durumu güncellenemedi: $e');
      }
    }
  }

  Future<void> updateUser(
    Map<String, dynamic> payload, {
    bool? isSeller,
  }) async {
    await ApiService.putUserUpdate(payload, isSeller: isSeller);
    // Kullanıcı bilgilerini güncelle (is_online güncellemesi yapmadan)
    await fetchUserMe();
  }

  Future<void> fetchUserMe() async {
    try {
      final user = await ApiService.fetchUserMe();
      state = user;
    } catch (_) {
      state = null;
    }
  }

  Future<String> logout() async {
    String message = 'Başarıyla çıkış yapıldı.';
    try {
      // Logout öncesi offline yap
      await ApiService.putUserUpdate({'is_online': false});
      debugPrint('Auth: Logout - Kullanıcı offline yapıldı');

      //final result = await ApiService.fetchUserLogout();
      //if (result.isNotEmpty) {
      //  message = result;
      //}
    } catch (e) {
      debugPrint('Auth: Logout hatası: $e');
      await _clearStoredTokens();
      state = null;
      rethrow;
    }
    await _clearStoredTokens();
    state = null;

    // Logout sonrası: uygulama içi cache/state temizliği
    // - Products repository cache temizliği (ürün listeleri vs.)
    // - Sepet state temizliği (lokal cart provider)
    // Not: UI tarafında ayrıca statik sepet listeleri (sepetUrunIdList) userProvider listener ile temizleniyor.
    ref.invalidate(productsRepositoryProvider);
    ref.invalidate(populerProductsProvider);
    ref.invalidate(campaignsProvider);
    try {
      await ref.read(cartProvider.notifier).clearCart();
    } catch (_) {
      // Sepet temizliği başarısız olsa bile logout engellenmesin
    }

    return message;
  }

  Future<void> _clearStoredTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accesToken');
    await prefs.remove('refreshToken');
  }
}

class _AuthLifecycleObserver extends WidgetsBindingObserver {
  final Future<void> Function() onResumed;
  final Future<void> Function() onPausedOrInactive;

  _AuthLifecycleObserver({
    required this.onResumed,
    required this.onPausedOrInactive,
  });

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResumed();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        onPausedOrInactive();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }
}
