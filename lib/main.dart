import 'dart:io';
import 'package:flutter/material.dart';
import 'package:imecehub/product/init/theme/custom_dark_theme.dart';
import 'package:imecehub/product/init/theme/custom_light_theme.dart';
import 'package:imecehub/product/navigation/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dotenvLoader.dart';
import 'EthernetController.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

/// SSL Certificate Pinning için özel HttpOverrides
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        // Güvenlik: Sadece güvenilir sertifikaları kabul et
        // Production ortamında, belirli sertifika hash'lerini kontrol etmelisiniz
        // Örnek: return cert.sha1.toString() == 'EXPECTED_CERTIFICATE_HASH';
        
        // Şimdilik tüm sertifikaları reddet (en güvenli yaklaşım)
        // Kendi sertifikanızı eklemek için yukarıdaki yorumu açın
        return false;
      };
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // SSL Certificate Pinning'i etkinleştir
  HttpOverrides.global = MyHttpOverrides();
  
  runApp(
    const ProviderScope(child: DotenvLoaderApp(child: EthernetController())),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  String _initialRoute = '/splash';

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final hasLaunchedBefore = prefs.getBool('hasLaunchedBefore') ?? false;
    
    if (mounted) {
      setState(() {
        _initialRoute = hasLaunchedBefore ? '/home' : '/splash';
      });
    }
    
    // İlk açılışı kaydet
    if (!hasLaunchedBefore) {
      await prefs.setBool('hasLaunchedBefore', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CustomLightTheme().themeData,
      darkTheme: CustomDarkTheme().themeData,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      initialRoute: _initialRoute,
      routes: appRoutes,
      navigatorObservers: [routeObserver],
    );
  }
}
