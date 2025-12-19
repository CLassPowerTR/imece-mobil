import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Biyometrik kimlik doğrulama durumu
enum BiometricAuthState {
  /// Cihaz biyometrik kimlik doğrulamayı desteklemiyor
  notAvailable,

  /// Kullanıcı biyometrik kimlik doğrulamayı etkinleştirmedi
  disabled,

  /// Biyometrik kimlik doğrulama etkin
  enabled,

  /// Kimlik doğrulama başarılı
  authenticated,

  /// Kimlik doğrulama başarısız
  failed,
}

/// Biyometrik kimlik doğrulama servisini yöneten sınıf
class BiometricAuthService {
  static const String _enabledKey = 'biometric_auth_enabled';
  final LocalAuthentication _auth = LocalAuthentication();

  /// Cihazın biyometrik kimlik doğrulamayı destekleyip desteklemediğini kontrol eder
  Future<bool> canCheckBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  /// Cihazda kullanılabilir biyometrik yöntemleri getirir
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  /// Biyometrik kimlik doğrulama yapar
  Future<bool> authenticate({
    required String localizedReason,
    bool useErrorDialogs = true,
    bool stickyAuth = true,
  }) async {
    try {
      return await _auth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  /// Biyometrik kimlik doğrulamanın etkin olup olmadığını kontrol eder
  Future<bool> isEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_enabledKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Biyometrik kimlik doğrulamayı etkinleştirir/devre dışı bırakır
  Future<void> setEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_enabledKey, enabled);
    } catch (e) {
      // Hata durumunda sessizce devam et
    }
  }
}

/// Biyometrik kimlik doğrulama durumunu yöneten StateNotifier
class BiometricAuthNotifier extends StateNotifier<BiometricAuthState> {
  final BiometricAuthService _service;

  BiometricAuthNotifier(this._service)
    : super(BiometricAuthState.notAvailable) {
    _init();
  }

  /// Başlangıç durumunu ayarlar
  Future<void> _init() async {
    final canCheck = await _service.canCheckBiometrics();
    if (!canCheck) {
      state = BiometricAuthState.notAvailable;
      return;
    }

    final isEnabled = await _service.isEnabled();
    state = isEnabled
        ? BiometricAuthState.enabled
        : BiometricAuthState.disabled;
  }

  /// Biyometrik kimlik doğrulamayı etkinleştirir
  Future<void> enable() async {
    final canCheck = await _service.canCheckBiometrics();
    if (!canCheck) {
      state = BiometricAuthState.notAvailable;
      return;
    }

    await _service.setEnabled(true);
    state = BiometricAuthState.enabled;
  }

  /// Biyometrik kimlik doğrulamayı devre dışı bırakır
  Future<void> disable() async {
    await _service.setEnabled(false);
    state = BiometricAuthState.disabled;
  }

  /// Kimlik doğrulama yapar
  Future<bool> authenticate(String reason) async {
    final success = await _service.authenticate(localizedReason: reason);
    state = success
        ? BiometricAuthState.authenticated
        : BiometricAuthState.failed;
    return success;
  }

  /// Kullanılabilir biyometrik yöntemleri döner
  Future<List<BiometricType>> getAvailableBiometrics() async {
    return await _service.getAvailableBiometrics();
  }
}

/// Biyometrik kimlik doğrulama servisini sağlayan Provider
final biometricAuthServiceProvider = Provider<BiometricAuthService>((ref) {
  return BiometricAuthService();
});

/// Biyometrik kimlik doğrulama durumunu sağlayan Provider
final biometricAuthProvider =
    StateNotifierProvider<BiometricAuthNotifier, BiometricAuthState>((ref) {
      final service = ref.watch(biometricAuthServiceProvider);
      return BiometricAuthNotifier(service);
    });

/// Biyometrik kimlik doğrulamanın kullanılabilir olup olmadığını döner
final canUseBiometricsProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(biometricAuthServiceProvider);
  return await service.canCheckBiometrics();
});
