// lib/screens/splash/splash_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/auth_provider.dart';
import '../../providers/products_provider.dart';
import '../../providers/stories_campaings_provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/products.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();

    Future.microtask(() => _initializeApp());
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );

    _animationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      bool isUserLoggedIn = false;

      // 1. Auth Provider'ı kontrol et ve gerekirse online yap
      try {
        // Önce access token var mı kontrol et
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('accesToken') ?? '';
        
        if (token.isNotEmpty) {
          // Token varsa önce kullanıcıyı online yap
          await ref.read(userProvider.notifier).setUserOnline();
          debugPrint('Kullanıcı online yapıldı, şimdi veriler yüklenecek');
        }
        
        // Ardından kullanıcı verilerini kontrol et
        final user = ref.read(userProvider);
        isUserLoggedIn = user != null;
        debugPrint(
          'Auth kontrol edildi. Kullanıcı: ${isUserLoggedIn ? "Giriş yapmış" : "Giriş yapmamış"}',
        );
      } catch (e) {
        debugPrint('Auth yüklenemedi: $e');
        isUserLoggedIn = false;
      }

      // Paralel yükleme için Future listesi
      final futures = <Future>[];

      // 2. Sadece temel ürünleri her durumda yükle
      futures.add(
        ref.read(productsRepositoryProvider).fetchProducts().catchError((e) {
          debugPrint('Ürünler yüklenemedi: $e');
          return <Product>[];
        }),
      );

      // Giriş yapılmışsa ek verileri de paralel listeye ekle
      if (isUserLoggedIn) {
        futures.add(
          ref
              .read(productsRepositoryProvider)
              .fetchPopulerProducts()
              .catchError((e) {
                debugPrint('Popüler ürünler yüklenemedi: $e');
                return <Product>[];
              }),
        );

        futures.add(
          ref.read(storiesCampaignsProvider.future).catchError((e) {
            debugPrint('Hikayeler yüklenemedi: $e');
            return const StoriesCampaignsState(stories: [], campaigns: []);
          }),
        );
      }

      // Paralel işlemleri bekle
      await Future.wait(futures);

      // 3. Giriş yapılmışsa kampanyaları ve sepeti yükle
      if (isUserLoggedIn) {
        try {
          await ref.read(productsRepositoryProvider).fetchCampaigns();
        } catch (e) {
          debugPrint('Kampanyalar yüklenemedi: $e');
        }

        try {
          await ref.read(cartProvider.notifier).loadCart();
        } catch (e) {
          debugPrint('Sepet yüklenemedi: $e');
        }
      }

      // 4. Tamamlandı
      await Future.delayed(const Duration(milliseconds: 400));

      // Ana sayfaya yönlendir
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      debugPrint('Splash screen hatası: $e');
      // Hata durumunda da ana sayfaya yönlendir
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final colorScheme = Theme.of(context).colorScheme;

    // Temaya uyumlu hafif kırık beyaz (primary renginden çok hafif bir ton)
    final backgroundColor = Color.lerp(colorScheme.surface, colorScheme.primary, 0.03) ?? colorScheme.surface;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/image/website.png',
                  width: isSmallScreen ? 160 : 180,
                  height: isSmallScreen ? 160 : 180,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.shopping_bag_outlined,
                      size: isSmallScreen ? 80 : 100,
                      color: colorScheme.primary,
                    );
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'IMECEHUB',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 24 : 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
