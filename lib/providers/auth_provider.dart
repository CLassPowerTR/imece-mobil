import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imecehub/models/users.dart';
import 'package:imecehub/services/api_service.dart';

final loginStateProvider = StateProvider<bool>((ref) => false);

final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<User?>>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<AsyncValue<User?>> {
  UserNotifier() : super(const AsyncValue.loading());

  Future<void> fetchUser(int userId) async {
    state = const AsyncValue.loading();
    try {
      final user = await ApiService.fetchUserId(userId);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void logout() {
    state = const AsyncValue.data(null);
  }
}