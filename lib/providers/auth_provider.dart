import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imecehub/models/users.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:imecehub/services/api_service.dart';

// Giriş durumu her çağrıldığında otomatik kontrol edilir
final loginStateProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('accesToken') ?? '';
  return token.isNotEmpty;
});

final userProvider = NotifierProvider<UserNotifier, User?>(UserNotifier.new);

class UserNotifier extends Notifier<User?> {
  @override
  User? build() => null;

  void setUser(User user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }

  Future<void> fetchUserMe() async {
    try {
      final user = await ApiService.fetchUserMe();
      state = user;
    } catch (_) {
      state = null;
    }
  }

  void logout() {
    state = null;
  }
}
