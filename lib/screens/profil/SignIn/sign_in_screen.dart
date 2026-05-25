import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:imecehub/core/constants/app_colors.dart';

import 'package:imecehub/core/widgets/showTemporarySnackBar.dart';
import 'package:imecehub/core/widgets/text.dart';
import 'package:imecehub/core/widgets/buttons/backButton.dart';
import 'package:imecehub/core/widgets/buttons/textButton.dart';
import 'package:imecehub/core/widgets/textField.dart';
import 'package:imecehub/core/widgets/loading_overlay.dart';
import 'package:imecehub/screens/profil/profile_screen.dart';
import 'package:imecehub/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imecehub/screens/home/home_screen.dart';
import 'dart:convert';

part 'sign_in_view_header.dart';
part 'sign_in_widget_items.dart';
part '../SignUp/sign_up_screen.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreen();
}

class _SignInScreen extends ConsumerState<SignInScreen> with RouteAware {
  bool isCheckedContract = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage; // Genel hata
  Map<String, dynamic>? fieldErrors; // Alan bazlı hatalar
  String? emailValidationError; // E-posta format hatası
  String? generalFieldError; // Genel giriş hatası (her iki alan için)
  bool showPassword = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    ProfileScreen(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    double width = double.infinity;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;
    final double inputHeight = isSmallScreen ? 40 : 48;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      //appBar: SignInAppBar(context),
      body: SafeArea(
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // ── Logo & Geri Butonu ──
                            Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: const CustomBackButton(),
                                  ),
                                  Image.asset(
                                    'assets/image/website.png',
                                    height: isSmallScreen ? 36 : 48,
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              ),
                            ),
                            headText(context, isSmallScreen: isSmallScreen),
                            SizedBox(height: isSmallScreen ? 14 : 28),
                            emailAdressContainer(
                              width,
                              context,
                              textFieldHeight: inputHeight,
                              controller: emailController,
                              errorText: emailValidationError ?? 
                                  generalFieldError ?? 
                                  (fieldErrors?['email'] != null
                                      ? (fieldErrors?['email'] is List
                                            ? (fieldErrors?['email'] as List).join(', ')
                                            : fieldErrors?['email'].toString())
                                      : null),
                            ),
                            SizedBox(height: isSmallScreen ? 10 : 12),
                            passwordContainer(
                              width,
                              context,
                              textFieldHeight: inputHeight,
                              textFieldController: passwordController,
                              obscureText: showPassword,
                              onTap: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                              showSuffixIcon: true,
                              errorText: generalFieldError ?? 
                                  (fieldErrors?['password'] != null
                                      ? (fieldErrors?['password'] is List
                                            ? (fieldErrors?['password'] as List).join(', ')
                                            : fieldErrors?['password'].toString())
                                      : null),
                              onForgotPassword: () {
                                Navigator.pushNamed(context, '/profil/changePassword');
                              },
                            ),
                            SizedBox(height: isSmallScreen ? 10 : 16),
                            checkContract(width, context, isCheckedContract, (value) {
                              setState(() {
                                isCheckedContract = value!;
                              });
                            }),
                            SizedBox(height: isSmallScreen ? 8 : 12),
                            // Hata banner — React tarzı
                            if (errorMessage != null)
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.error.withOpacity(0.06),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.error.withOpacity(0.15),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.cancel_rounded,
                                        size: 20, color: Theme.of(context).colorScheme.error),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        errorMessage!,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          color: Theme.of(context).colorScheme.error,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            SizedBox(height: isSmallScreen ? 4 : 6),
                            NextButton(
                              context,
                              'Giriş Yap',
                              isCheckedContract,
                              minSizeHeight: inputHeight,
                              onPressed: () async {
                                // E-posta format kontrolü
                                final email = emailController.text.trim();
                                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                
                                if (email.isEmpty) {
                                  setState(() {
                                    emailValidationError = 'E-posta adresi giriniz';
                                    generalFieldError = null;
                                  });
                                  return;
                                }
                                
                                
                                
                                if (passwordController.text.trim().isEmpty) {
                                  setState(() {
                                    emailValidationError = null;
                                    generalFieldError = 'Şifre giriniz';
                                  });
                                  return;
                                }
                                
                                setState(() {
                                  isLoading = true;
                                  errorMessage = null;
                                  fieldErrors = null;
                                  emailValidationError = null;
                                  generalFieldError = null;
                                });
                                try {
                                  await ref
                                      .read(userProvider.notifier)
                                      .login(
                                        email: emailController.text.trim(),
                                        password: passwordController.text.trim(),
                                      );
                                  setState(() {
                                    isLoading = false;
                                  });
                                  if (mounted) {
                                    // Satıcı hesabı uyarısı
                                    if (ref.read(userProvider.notifier).isSaticiHesabi) {
                                      showTemporarySnackBar(
                                        context,
                                        'Bu hesap bir satıcı hesabıdır. Mobil uygulamada alıcı olarak devam edeceksiniz.',
                                        type: SnackBarType.info,
                                        duration: 5,
                                      );
                                    } else {
                                      showTemporarySnackBar(
                                        context,
                                        'Giriş başarılı!',
                                        type: SnackBarType.success,
                                      );
                                    }

                                    ref.read(bottomNavIndexProvider.notifier).setIndex(3);
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/home',
                                      (route) => false,
                                      arguments: {'refresh': true},
                                    );

                                    //Navigator.pushReplacementNamed(context, '/home');
                                  }
                                } catch (e) {
                                  final s = e.toString();

                                  if (s.contains('not_verified') || s.contains('doğrulanmamış')) {
                                      Navigator.pushNamed(context, '/profil/verifyEmail',arguments: {'email': emailController.text.trim()});
                                      return;
                                    }

                                  if (s.contains('Invalid email or password') || 
                                      s.contains('Kullanıcı adı veya şifre hatalı')) {
                                    setState(() {
                                      isLoading = false;
                                      errorMessage = null;
                                      fieldErrors = null;
                                      // Her iki alanın altında hata göster
                                      generalFieldError = 'Kullanıcı adı veya şifre hatalı';
                                    });
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                      Map<String, dynamic>? parsed;
                                      try {
                                        final start = s.indexOf('{');
                                        final end = s.lastIndexOf('}');
                                        if (start != -1 && end != -1 && end > start) {
                                          parsed =
                                              json.decode(s.substring(start, end + 1))
                                                  as Map<String, dynamic>;
                                        }
                                      } catch (_) {
                                        parsed = null;
                                      }
                                      if (parsed != null) {
                                        fieldErrors = parsed;
                                        errorMessage = null;
                                        generalFieldError = null;
                                      } else {
                                        
                                        // Genel hata mesajını her iki alanda göster
                                        generalFieldError = s.replaceAll('Exception: ', '');
                                        errorMessage = null;
                                      }
                                    });
                                  }
                                }
                              },
                            ),
                            SizedBox(height: isSmallScreen ? 10 : 20),
                            orLine(width, context),
                            SizedBox(height: isSmallScreen ? 10 : 20),
                            signInWithGoogle(context, width, containerHeight: inputHeight, onTap: () async {
                              setState(() => isLoading = true);
                              try {
                                await ref.read(userProvider.notifier).googleLogin();
                                setState(() => isLoading = false);
                                if (mounted) {
                                  // Satıcı hesabı uyarısı
                                  if (ref.read(userProvider.notifier).isSaticiHesabi) {
                                    showTemporarySnackBar(
                                      context,
                                      'Bu hesap bir satıcı hesabıdır. Mobil uygulamada alıcı olarak devam edeceksiniz.',
                                      type: SnackBarType.info,
                                      duration: 5,
                                    );
                                  } else {
                                    showTemporarySnackBar(
                                      context,
                                      'Google ile giriş başarılı!',
                                      type: SnackBarType.success,
                                    );
                                  }
                                  ref.read(bottomNavIndexProvider.notifier).setIndex(3);
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/home',
                                    (route) => false,
                                    arguments: {'refresh': true},
                                  );
                                }
                              } catch (e) {
                                setState(() => isLoading = false);
                                final msg = e.toString().replaceAll('Exception: ', '');
                                if (msg.contains('iptal')) return; // Kullanıcı iptal etti
                                if (mounted) {
                                  showTemporarySnackBar(
                                    context,
                                    msg,
                                    type: SnackBarType.error,
                                  );
                                }
                              }
                            }),
                            SizedBox(height: 28),
                            signUpText(context, () {
                              Navigator.pushNamed(context, '/profil/signUp');
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ));
              },
            ),
            if (isLoading)
              const Positioned.fill(
                child: LoadingOverlay(message: 'Giriş yapılıyor...'),
              ),
          ],
        ),
      ),
    );
  }

  // Removed unused _changedPassword
}
