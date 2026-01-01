// lib/screens/splash/splash_screen.dart

import 'dart:async';
import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
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

      // 1. Auth Provider'ı kontrol et ve gerekirse online yap
      await _updateProgress(0.15, 'Oturum kontrol ediliyor...');
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
      await _updateProgress(0.30, 'Ürünler yükleniyor...');
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
        await _updateProgress(0.65, 'Kampanyalar hazırlanıyor...');
        try {
          await ref.read(productsRepositoryProvider).fetchCampaigns();
        } catch (e) {
          debugPrint('Kampanyalar yüklenemedi: $e');
        }

        await _updateProgress(0.85, 'Sepet güncelleniyor...');
        try {
          await ref.read(cartProvider.notifier).loadCart();
        } catch (e) {
          debugPrint('Sepet yüklenemedi: $e');
        }
      } else {
        // Giriş yapılmamışsa doğrudan son aşamaya geç
        await _updateProgress(0.85, 'Mağaza hazırlanıyor...');
      }

      // 4. Tamamlandı
      await _updateProgress(1.0, 'Uygulama hazır!');
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
      body: Stack(
        children: [
          // Ethereal nebulous cloudscape background
          _buildNebulousBackground(context),

          // Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(isSmallScreen ? 24 : 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Logo ve İsim - Floating Artifact Style
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        children: [
                          // Ethereal Floating Logo Container
                          _buildFloatingLogoContainer(
                            isSmallScreen: isSmallScreen,
                          ),
                          SizedBox(height: isSmallScreen ? 24 : 32),

                          // Stardust App Name
                          Text(
                            'IMECEHUB',
                            style: GoogleFonts.poppins(
                              fontSize: isSmallScreen ? 36 : 42,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF6B6B7F),
                              letterSpacing: 2,
                              shadows: [
                                Shadow(
                                  color: Color(0x40FFFFFF),
                                  blurRadius: 10,
                                ),
                                Shadow(
                                  color: Color(0x20E8D7FF),
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 8 : 12),
                          Text(
                            'Mobil',
                            style: GoogleFonts.poppins(
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFB8B8C8),
                              letterSpacing: 4,
                              shadows: [
                                Shadow(color: Color(0x20FFFFFF), blurRadius: 4),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(flex: 3),

                  // Ethereal Progress Indicator
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        // Crystallized Progress Bar
                        _buildEtherealProgressBar(isSmallScreen),

                        SizedBox(height: isSmallScreen ? 16 : 24),

                        // Loading Message with Stardust Style
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _loadingMessage.isNotEmpty
                                    ? _loadingMessage
                                    : 'Sistem yükleniyor...',
                                style: GoogleFonts.poppins(
                                  fontSize: isSmallScreen ? 12 : 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFB8B8C8),
                                  shadows: [
                                    Shadow(
                                      color: Color(0x20FFFFFF),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              '${(_progress * 100).toInt()}%',
                              style: GoogleFonts.poppins(
                                fontSize: isSmallScreen ? 16 : 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF9B8FD9),
                                shadows: [
                                  Shadow(
                                    color: Color(0x40E8D7FF),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Version Text with Ethereal Styling
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      _version.isNotEmpty
                          ? 'Versiyon $_version${_buildNumber.isNotEmpty ? '+$_buildNumber' : ''}'
                          : '',
                      style: GoogleFonts.poppins(
                        fontSize: isSmallScreen ? 11 : 12,
                        color: Color(0xFFB8B8C8),
                        shadows: [
                          Shadow(color: Color(0x15FFFFFF), blurRadius: 3),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 16 : 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============= ETHEREAL DESIGN METHODS =============

  /// Creates the nebulous cloudscape background with volumetric depth
  Widget _buildNebulousBackground(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE8D7FF), // Pastel amethyst
            Color(0xFFD7E8FF), // Soft sapphire
            Color(0xFFF5F5FF), // Moonstone white
            Color(0xFFFFE8F0), // Dawn pink
            Color(0xFFE0E8FF), // Light ethereal blue
          ],
          stops: [0.0, 0.25, 0.5, 0.75, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Cloud layer 1 - far background
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0x30E8D7FF), Color(0x00E8D7FF)],
                ),
              ),
            ),
          ),
          // Cloud layer 2 - mid background
          Positioned(
            top: 200,
            left: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0x25D7E8FF), Color(0x00D7E8FF)],
                ),
              ),
            ),
          ),
          // Cloud layer 3 - lower background
          Positioned(
            bottom: 100,
            right: 50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0x20FFE8F0), Color(0x00FFE8F0)],
                ),
              ),
            ),
          ),
          // Stardust particle overlay
          Positioned.fill(child: CustomPaint(painter: _StardustPainter())),
        ],
      ),
    );
  }

  /// Creates floating logo container with crystallized cloud material
  Widget _buildFloatingLogoContainer({required bool isSmallScreen}) {
    return Transform.rotate(
      angle: 0.01, // Subtle antigravity tilt
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // Aurora light halo effect
          boxShadow: [
            BoxShadow(
              color: Color(0x20E8D7FF), // Amethyst glow
              blurRadius: 25,
              spreadRadius: 5,
              offset: Offset(-6, -6),
            ),
            BoxShadow(
              color: Color(0x20D7E8FF), // Sapphire glow
              blurRadius: 25,
              spreadRadius: 5,
              offset: Offset(6, 6),
            ),
            BoxShadow(
              color: Color(0x15FFE8F0), // Dawn pink ambient
              blurRadius: 35,
              spreadRadius: 8,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0x50FFFFFF), Color(0x30FFFFFF)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0x50FFFFFF), width: 1.5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/image/website.png',
                  width: isSmallScreen ? 160 : 180,
                  height: isSmallScreen ? 160 : 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      padding: EdgeInsets.all(isSmallScreen ? 40 : 50),
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [Color(0x40E8D7FF), Color(0x10E8D7FF)],
                        ),
                      ),
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        size: isSmallScreen ? 80 : 100,
                        color: Color(0xFF9B8FD9),
                        shadows: [
                          Shadow(color: Color(0x40E8D7FF), blurRadius: 10),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Creates ethereal crystallized progress bar
  Widget _buildEtherealProgressBar(bool isSmallScreen) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x40FFFFFF), Color(0x20FFFFFF)],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0x40FFFFFF), width: 1),
            boxShadow: [
              BoxShadow(
                color: Color(0x10E8D7FF),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  // Track with subtle glow
                  Container(
                    height: isSmallScreen ? 12 : 16,
                    decoration: BoxDecoration(
                      color: Color(0x15FFFFFF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // Animated ethereal progress
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutCubic,
                    tween: Tween<double>(begin: 0, end: _progress),
                    builder: (context, value, child) {
                      return Container(
                        height: isSmallScreen ? 12 : 16,
                        width: constraints.maxWidth * value,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF9B8FD9), // Amethyst purple
                              Color(0xFFB8A8E8), // Light lavender
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x40E8D7FF),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                            BoxShadow(
                              color: Color(0x30D7E8FF),
                              blurRadius: 20,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: value > 0.1
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Stack(
                                  children: [
                                    // Shimmer/sparkle effect
                                    Positioned.fill(
                                      child: AnimatedBuilder(
                                        animation: _animationController,
                                        builder: (context, child) {
                                          return Transform.translate(
                                            offset: Offset(
                                              (constraints.maxWidth * value) *
                                                  (_animationController.value *
                                                          2 -
                                                      1),
                                              0,
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Colors.white.withOpacity(0),
                                                    Colors.white.withOpacity(
                                                      0.3,
                                                    ),
                                                    Colors.white.withOpacity(0),
                                                  ],
                                                  stops: const [0.3, 0.5, 0.7],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : null,
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Custom painter for creating subtle stardust particle overlay
class _StardustPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0x08FFFFFF)
      ..style = PaintingStyle.fill;

    // Create subtle stardust particles
    final random = Random(42); // Fixed seed for consistent particles
    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 1.5 + 0.5;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
