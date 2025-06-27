import 'package:flutter/material.dart';
import 'package:imecehub/product/init/theme/custom_dark_theme.dart';
import 'package:imecehub/product/init/theme/custom_light_theme.dart';
import 'package:imecehub/product/navigation/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CustomLightTheme().themeData,
      darkTheme: CustomDarkTheme().themeData,
      themeMode: ThemeMode.light,
      initialRoute: '/home',
      routes: appRoutes,
      navigatorObservers: [routeObserver],
    );
  }
}
