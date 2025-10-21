import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imecehub/services/core/deps.dart';
import 'package:imecehub/services/api_service.dart';
import 'package:imecehub/core/widgets/showTemporarySnackBar.dart';
import 'package:imecehub/EthernetController.dart';

final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) {
  return GlobalKey<NavigatorState>();
});

final apiDependenciesProvider = Provider<ApiDependencies>((ref) {
  final navigatorKey = ref.watch(navigatorKeyProvider);
  return ApiDependencies(
    notify: (msg) {
      final context = navigatorKey.currentContext;
      if (context != null) {
        showTemporarySnackBar(context, msg, type: SnackBarType.warning);
      }
    },
  );
});

final apiServiceProvider = Provider<ApiService>((ref) {
  final deps = ref.watch(apiDependenciesProvider);
  ApiService.configureDependencies(deps);
  return ApiService();
});

// Basit global error handler: NoInternetException yakalandığında EthernetController'a yönlendirir
ProviderObserver buildGlobalErrorObserver(WidgetRef ref) {
  final navigatorKey = ref.read(navigatorKeyProvider);
  return _GlobalProviderObserver((Object error, StackTrace? stack) {
    if (error.toString().contains('İnternet bağlantısı yok')) {
      final context = navigatorKey.currentContext;
      if (context != null) {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const EthernetController()));
      }
    }
  });
}

final class _GlobalProviderObserver extends ProviderObserver {
  final void Function(Object error, StackTrace? stack) onError;
  _GlobalProviderObserver(this.onError);

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    onError(error, stackTrace);
    super.providerDidFail(context, error, stackTrace);
  }
}
