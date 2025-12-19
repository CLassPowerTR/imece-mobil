import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imecehub/providers/biometric_auth_provider.dart';
import 'package:imecehub/services/api_service.dart';

/// Kimlik doğrulama servisini yöneten sınıf
/// API ile biyometrik doğrulamayı birleştirerek çalışır
class AuthService {
  final BiometricAuthService _biometricService;

  AuthService(this._biometricService);

  /// Kullanıcı giriş yapar
  /// Eğer biyometrik doğrulama etkinse, önce biyometrik doğrulama ister
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
    required WidgetRef ref,
  }) async {
    // 1. Biyometrik doğrulama kontrolü
    final biometricEnabled = await _biometricService.isEnabled();
    final canUseBiometric = await _biometricService.canCheckBiometrics();

    if (biometricEnabled && canUseBiometric) {
      // Biyometrik doğrulama iste
      final authenticated = await _biometricService.authenticate(
        localizedReason: 'Giriş yapmak için kimlik doğrulama yapın',
        useErrorDialogs: true,
        stickyAuth: true,
      );

      if (!authenticated) {
        return {'success': false, 'message': 'Biyometrik doğrulama başarısız'};
      }
    }

    // 2. API ile giriş yap
    try {
      // Projede mevcut login metodu: token'ları SharedPreferences'a kaydeder.
      await ApiService.fetchUserLogin(email, password);
      return {'success': true, 'message': 'Giriş başarılı'};
    } catch (e) {
      return {'success': false, 'message': 'Bir hata oluştu: $e'};
    }
  }

  /// Kullanıcı çıkış yapar
  /// Biyometrik doğrulama etkinse, çıkış için doğrulama ister
  Future<Map<String, dynamic>> signOut({
    required WidgetRef ref,
    bool requireBiometric = false,
  }) async {
    // 1. İsteğe bağlı biyometrik doğrulama
    if (requireBiometric) {
      final biometricEnabled = await _biometricService.isEnabled();
      final canUseBiometric = await _biometricService.canCheckBiometrics();

      if (biometricEnabled && canUseBiometric) {
        final authenticated = await _biometricService.authenticate(
          localizedReason: 'Çıkış yapmak için kimlik doğrulama yapın',
          useErrorDialogs: true,
          stickyAuth: true,
        );

        if (!authenticated) {
          return {
            'success': false,
            'message': 'Biyometrik doğrulama başarısız',
          };
        }
      }
    }

    // 2. API ile çıkış yap (token temizliği ApiService içinde yapılıyor)
    try {
      await ApiService.fetchUserLogout();
      return {'success': true, 'message': 'Çıkış başarılı'};
    } catch (e) {
      return {'success': false, 'message': 'Çıkış sırasında hata: $e'};
    }
  }

  /// İlk giriş sonrası biyometrik doğrulamayı etkinleştirme önerir
  Future<void> promptEnableBiometric() async {
    final canCheck = await _biometricService.canCheckBiometrics();
    final isEnabled = await _biometricService.isEnabled();

    if (canCheck && !isEnabled) {
      // Kullanıcıya dialog göster ve etkinleştirmesini öner
      // Bu kısım UI'da implement edilecek
    }
  }
}

/// AuthService provider'ı
final authServiceProvider = Provider<AuthService>((ref) {
  final biometricService = ref.watch(biometricAuthServiceProvider);
  return AuthService(biometricService);
});
