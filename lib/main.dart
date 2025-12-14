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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
