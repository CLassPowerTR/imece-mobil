import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/widgets.dart';
import 'package:imecehub/models/users.dart';
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
              await ApiService.postUserUpdate({'is_online': true});
            } catch (_) {}
          }
        },
        onPausedOrInactive: () async {
          if (state != null) {
            try {
              await ApiService.postUserUpdate({'is_online': false});
            } catch (_) {}
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
    if (token.isEmpty) {
      clearUser();
      return;
    }
    await fetchUserMe();
    if (state != null) {
      try {
        await ApiService.postUserUpdate({'is_online': true});
      } catch (_) {}
    }
  }

  Future<void> login({required String email, required String password}) async {
    await ApiService.fetchUserLogin(email, password);
    await ApiService.postUserUpdate({'is_online': true});
    await fetchUserMe();
  }

  Future<void> register({
    required String email,
    required String username,
    required String password,
  }) async {
    await ApiService.fetchUserRegister(email, username, password);
    await ApiService.postUserUpdate({'is_online': true});
    await fetchUserMe();
  }

  Future<void> updateUser(Map<String, dynamic> payload) async {
    await ApiService.postUserUpdate(payload);
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
      await ApiService.postUserUpdate({'is_online': false});
      final result = await ApiService.fetchUserLogout();
      if (result.isNotEmpty) {
        message = result;
      }
    } catch (e) {
      await _clearStoredTokens();
      state = null;
      rethrow;
    }
    await _clearStoredTokens();
    state = null;
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
