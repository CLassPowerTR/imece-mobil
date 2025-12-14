// lib/core/providers/connectivity_provider.dart

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/app_logger.dart';

final connectivityProvider = StreamProvider<bool>((ref) {
  return Connectivity()
      .onConnectivityChanged
      .map((List<ConnectivityResult> results) {
    final isOnline = results.isNotEmpty && 
        !results.every((result) => result == ConnectivityResult.none);
    
    AppLogger.i('Connectivity changed: ${isOnline ? "Online" : "Offline"}');
    return isOnline;
  });
});

final isOnlineProvider = Provider<bool>((ref) {
  final connectivityAsync = ref.watch(connectivityProvider);
  return connectivityAsync.when(
    data: (isOnline) => isOnline,
    loading: () => true, // Assume online while checking
    error: (_, __) => true, // Assume online on error
  );
});

