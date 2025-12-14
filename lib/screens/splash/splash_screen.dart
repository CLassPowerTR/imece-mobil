// lib/screens/splash/splash_screen.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
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

  String _loadingMessage = '';
  double _progress = 0.0;
  String _version = '';
  String _buildNumber = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
    _initializeAnimations();

    Future.microtask(() => _initializeApp());
  }

  Future<void> _loadVersion() async {
    // package_info_plus bazı durumlarda (özellikle hot-reload / tam restart olmadan)
    // MissingPluginException fırlatabilir veya kanal hiç cevap vermezse bekletebilir.
    // Splash'ın takılmaması için timeout + güvenli fallback uyguluyoruz.
    const fallbackVersion = 'Debug'; // pubspec.yaml: version: 0.0.1

    try {
      final info = await PackageInfo.fromPlatform().timeout(
        const Duration(milliseconds: 800),
      );
      if (!mounted) return;
      setState(() {
        _version = info.version;
        _buildNumber = info.buildNumber;
      });
      debugPrint('Uygulama Versiyonu: ${info.version}+${info.buildNumber}');
    } on MissingPluginException catch (e) {
      debugPrint('Versiyon bilgisi alınamadı (plugin yok): $e');
      if (!mounted) return;
      setState(() {
        _version = fallbackVersion;
        _buildNumber = '';
      });
    } on TimeoutException catch (e) {
      debugPrint('Versiyon bilgisi alınamadı (timeout): $e');
      if (!mounted) return;
      setState(() {
        _version = fallbackVersion;
        _buildNumber = '';
      });
    } catch (e) {
      debugPrint('Versiyon bilgisi alınamadı: $e');
      if (!mounted) return;
      setState(() {
        _version = fallbackVersion;
        _buildNumber = '';
      });
    }
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

      // 1. Auth Provider'ı kontrol et (İlk öncelik)
      await _updateProgress(0.15, '');
      try {
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

      // 2-4. Temel verileri paralel yükle (Her durumda)
      await _updateProgress(0.30, '');

      futures.add(
        ref.read(productsRepositoryProvider).fetchProducts().catchError((e) {
          debugPrint('Ürünler yüklenemedi: $e');
          return <Product>[];
        }),
      );

      futures.add(
        ref.read(productsRepositoryProvider).fetchPopulerProducts().catchError((
          e,
        ) {
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

      // Paralel işlemleri bekle
      await Future.wait(futures);
      await _updateProgress(0.65, '');

      // 5. Kampanyaları yükle
      try {
        await ref.read(productsRepositoryProvider).fetchCampaigns();
      } catch (e) {
        debugPrint('Kampanyalar yüklenemedi: $e');
      }

      await _updateProgress(0.85, '');

      // 6. Sepeti yükle (Sadece giriş yapmış kullanıcılar için)
      if (isUserLoggedIn) {
        try {
          await ref.read(cartProvider.notifier).loadCart();
          debugPrint('Sepet yüklendi');
        } catch (e) {
          debugPrint('Sepet yüklenemedi: $e');
        }
      }

      // 7. Tamamlandı - Hoş geldiniz!
      await _updateProgress(1.0, 'Hoş geldiniz!');
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

  Future<void> _updateProgress(double progress, String message) async {
    if (mounted) {
      setState(() {
        _progress = progress;
        _loadingMessage = message;
      });
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

    return Scaffold(
      backgroundColor: const Color(0xFFE0E5EC),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 24 : 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Logo ve İsim
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    children: [
                      // Neumorphic Logo Container
                      _buildNeumorphicContainer(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/image/website.png',
                            width: isSmallScreen ? 160 : 180,
                            height: isSmallScreen ? 160 : 180,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Hata durumunda fallback icon göster
                              return Container(
                                padding: EdgeInsets.all(
                                  isSmallScreen ? 40 : 50,
                                ),
                                child: Icon(
                                  Icons.shopping_bag_outlined,
                                  size: isSmallScreen ? 80 : 100,
                                  color: const Color(0xFF4ECDC4),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 24 : 32),

                      // App İsmi
                      Text(
                        'IMECE',
                        style: GoogleFonts.poppins(
                          fontSize: isSmallScreen ? 36 : 42,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2D3142),
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 8 : 12),
                      Text(
                        'Mobil',
                        style: GoogleFonts.poppins(
                          fontSize: isSmallScreen ? 16 : 18,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6B7280),
                          letterSpacing: 4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 3),

              // Yükleme Göstergesi
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    // Progress Bar with Animation
                    _buildNeumorphicContainer(
                      isPressed: true,
                      padding: const EdgeInsets.all(8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          tween: Tween<double>(begin: 0, end: _progress),
                          builder: (context, value, child) {
                            return LinearProgressIndicator(
                              value: value,
                              minHeight: isSmallScreen ? 8 : 10,
                              backgroundColor: Colors.transparent,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF4ECDC4),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 16 : 20),

                    // Yükleme Mesajı (Sadece %100'de göster)
                    if (_loadingMessage.isNotEmpty)
                      Text(
                        _loadingMessage,
                        style: GoogleFonts.poppins(
                          fontSize: isSmallScreen ? 13 : 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF6B7280),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    if (_loadingMessage.isNotEmpty)
                      SizedBox(height: isSmallScreen ? 8 : 12),

                    // Yüzde Göstergesi
                    Text(
                      '${(_progress * 100).toInt()}%',
                      style: GoogleFonts.poppins(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF4ECDC4),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Alt Bilgi
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  _version.isNotEmpty
                      ? 'Versiyon $_version${_buildNumber.isNotEmpty ? '+$_buildNumber' : ''}'
                      : '',
                  style: GoogleFonts.poppins(
                    fontSize: isSmallScreen ? 11 : 12,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ),
              SizedBox(height: isSmallScreen ? 16 : 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNeumorphicContainer({
    required Widget child,
    bool isPressed = false,
    EdgeInsets? padding,
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFFE0E5EC),
        borderRadius: BorderRadius.circular(20),
        boxShadow: isPressed
            ? [
                const BoxShadow(
                  color: Color(0xFFA3B1C6),
                  offset: Offset(2, 2),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
                const BoxShadow(
                  color: Colors.white,
                  offset: Offset(-2, -2),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ]
            : [
                const BoxShadow(
                  color: Color(0xFFA3B1C6),
                  offset: Offset(8, 8),
                  blurRadius: 15,
                  spreadRadius: 0,
                ),
                const BoxShadow(
                  color: Colors.white,
                  offset: Offset(-8, -8),
                  blurRadius: 15,
                  spreadRadius: 0,
                ),
              ],
      ),
      child: child,
    );
  }
}
