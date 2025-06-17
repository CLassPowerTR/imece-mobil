import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imecehub/models/users.dart';
import 'package:imecehub/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:imecehub/api/api_config.dart';

final loginStateProvider = StateProvider<bool>((ref) => false);

final userProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<User?>>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<AsyncValue<User?>> {
  UserNotifier() : super(const AsyncValue.loading());

  Future<void> fetchUserLogin(String accesToken) async {
    state = const AsyncValue.loading();
    try {
      // API konfigürasyon bilgilerini yükle.
      final config = await ApiConfig.loadFromAsset();

      // HTTP GET isteği gönderilirken header'a API key eklenir.
      final response = await http.get(
        Uri.parse('${config.userRqLoginApiUrl}'),
        headers: {
          'X-API-Key': config.apiKey,
          'Accept': 'application/json',
          'Authorization': 'Bearer ${accesToken}',
          'Content-Type': 'application/json; charset=utf-8',
          'Allow': 'Get',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        final user = User.fromJson(jsonData);
        state = AsyncValue.data(user);
      } else {
        throw Exception(
            'User verisi alınamadı. Durum kodu: \\${response.statusCode}');
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void logout() {
    state = const AsyncValue.data(null);
  }
}
