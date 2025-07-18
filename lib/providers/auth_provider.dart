import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imecehub/models/users.dart';
import 'package:http/http.dart' as http;
import 'package:imecehub/api/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Giriş durumu her çağrıldığında otomatik kontrol edilir
final loginStateProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('accesToken') ?? '';
  return token.isNotEmpty;
});

final userProvider =
    StateNotifierProvider<UserNotifier, User?>((ref) => UserNotifier());

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  void setUser(User user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }

  Future<void> fetchUserMe() async {
    final prefs = await SharedPreferences.getInstance();
    final accesToken = prefs.getString('accesToken') ?? '';
    try {
      // API konfigürasyon bilgilerini yükle.
      final config = await ApiConfig();
      // HTTP GET isteği gönderilirken header'a API key eklenir.
      final response = await http.get(
        Uri.parse(config.userMeApiUrl),
        headers: {
          'Authorization': 'Bearer $accesToken',
          'X-API-Key': config.apiKey,
          'Content-Type': 'application/json',
          'Allow': 'Get',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        final user = User.fromJson(jsonData);
        state = user;
      } else {
        throw Exception(
            'User verisi alınamadı. Durum kodu: \\${response.statusCode}');
      }
    } catch (e, st) {
      state = null;
    }
  }

  void logout() {
    state = null;
  }
}
