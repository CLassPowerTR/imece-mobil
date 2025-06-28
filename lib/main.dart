import 'package:flutter/material.dart';
import 'package:imecehub/product/init/theme/custom_dark_theme.dart';
import 'package:imecehub/product/init/theme/custom_light_theme.dart';
import 'package:imecehub/product/navigation/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:imecehub/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: DotenvLoaderApp()));
}

class DotenvLoaderApp extends StatelessWidget {
  const DotenvLoaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: dotenv.load(fileName: ".env"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const MyApp();
        }
        return const MaterialApp(
          home: Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
  }

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
