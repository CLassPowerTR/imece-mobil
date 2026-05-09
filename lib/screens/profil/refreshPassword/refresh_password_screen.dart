import 'package:flutter/material.dart';
import 'dart:async';
import 'package:imecehub/core/theme/design_tokens.dart';
import 'package:imecehub/core/widgets/loading_overlay.dart';
import 'package:imecehub/screens/profil/SignIn/sign_in_screen.dart'; // import NextButton, SignInAppBar, vb.
import 'package:imecehub/services/api_service.dart';
import 'refresh_password_widget_items.dart';

class RefreshPasswordScreen extends StatefulWidget {
  final String? initialEmail;
  const RefreshPasswordScreen({super.key, this.initialEmail});

  @override
  State<RefreshPasswordScreen> createState() => _RefreshPasswordScreenState();
}

class _RefreshPasswordScreenState extends State<RefreshPasswordScreen> {
  late TextEditingController emailController;
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  String code = "";
  bool showPassword = false;
  bool showConfirmPassword = false;
  
  bool isLoading = false;
  bool isSuccess = false;
  String? errorMessage;
  
  int resendTimer = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.initialEmail ?? '');
    _startTimer();
  }

  void _startTimer() {
    setState(() => resendTimer = 60);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer > 0) {
        setState(() => resendTimer--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    emailController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleResendCode() async {
    if (resendTimer > 0) return;
    final email = emailController.text.trim();
    if (email.isEmpty) {
      setState(() => errorMessage = "Lütfen e-posta adresinizi girin.");
      return;
    }
    
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await ApiService.fetchForgotPassword(email);
      setState(() {
        isLoading = false;
      });
      _startTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kod tekrar gönderildi!')),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  void _handleSubmit() async {
    final email = emailController.text.trim();
    final pwd = newPasswordController.text;
    final confirmPwd = confirmPasswordController.text;

    if (email.isEmpty || code.length < 6 || pwd.isEmpty || confirmPwd.isEmpty) {
      setState(() => errorMessage = 'Lütfen tüm alanları doldurun.');
      return;
    }

    if (pwd != confirmPwd) {
      setState(() => errorMessage = 'Şifreler eşleşmiyor.');
      return;
    }

    if (pwd.length < 8) {
      setState(() => errorMessage = 'Şifre en az 8 karakter olmalıdır.');
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await ApiService.fetchResetPassword(
        email: email,
        code: code,
        password: pwd,
      );
      
      setState(() {
        isSuccess = true;
        isLoading = false;
      });

      Future.delayed(const Duration(milliseconds: 3000), () {
        if (mounted) {
          // Giriş sayfasına dön ve yığındaki diğer sayfaları temizle
          Navigator.pushNamedAndRemoveUntil(context, '/profil/signIn', (route) => false);
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = double.infinity;
    return Scaffold(
      appBar: SignInAppBar(context),
      body: SafeArea(
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 40,
                    ),
                    child: Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: double.infinity,
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              DesignTokens.primary.withOpacity(0.05),
                              DesignTokens.surfaceLight,
                              DesignTokens.surfaceLight,
                              DesignTokens.surfaceLight,
                              DesignTokens.surfaceLight,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 24,
                              offset: const Offset(0, 40),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Logo
                            Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: Image.asset(
                                'assets/image/website.png',
                                height: 40,
                                fit: BoxFit.contain,
                              ),
                            ),
                            
                            if (isSuccess) ...[
                              animatedSuccessView(context),
                            ] else ...[
                              refreshPasswordHeadText(context),
                              const SizedBox(height: 28),
                              
                              // Sadece E-Posta Gösterimi veya Girişi
                              emailAdressContainer(
                                width,
                                context,
                                controller: emailController,
                              ),
                              const SizedBox(height: 16),
                              
                              // OTP Giriş Alanı
                              otpInputBoxes(
                                code: code,
                                context: context,
                                onChanged: (val) {
                                  setState(() {
                                    code = val.replaceAll(RegExp(r'\D'), '');
                                  });
                                },
                              ),
                              const SizedBox(height: 16),

                              // Yeni Şifre
                              passwordContainer(
                                width,
                                context,
                                containerText: 'YENİ ŞİFRE',
                                hintText: '••••••••',
                                textFieldController: newPasswordController,
                                obscureText: !showPassword,
                                showSuffixIcon: true,
                                onTap: () {
                                  setState(() {
                                    showPassword = !showPassword;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),

                              // Yeni Şifre Tekrar
                              passwordContainer(
                                width,
                                context,
                                containerText: 'YENİ ŞİFRE (TEKRAR)',
                                hintText: '••••••••',
                                textFieldController: confirmPasswordController,
                                obscureText: !showConfirmPassword,
                                showSuffixIcon: true,
                                onTap: () {
                                  setState(() {
                                    showConfirmPassword = !showConfirmPassword;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              
                              // Hata banner
                              if (errorMessage != null)
                                Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: DesignTokens.error.withOpacity(0.06),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: DesignTokens.error.withOpacity(0.15),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.cancel_rounded,
                                          size: 20, color: DesignTokens.error),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          errorMessage!,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w800,
                                            color: DesignTokens.error,
                                            letterSpacing: 0.8,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              
                              NextButton(
                                context,
                                'ŞİFREYİ GÜNCELLE',
                                true,
                                onPressed: _handleSubmit,
                              ),
                              const SizedBox(height: 24),
                              
                              // Hızlı Destek Butonu / Tekrar Gönder
                              Column(
                                children: [
                             
                                  GestureDetector(
                                    onTap: () {
                                      // Kod talebini yenile diyerek bir önceki sayfaya dönebilir
                                      Navigator.pop(context);
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.arrow_back_rounded, size: 16, color: DesignTokens.textTertiary),
                                        const SizedBox(width: 6),
                                        Text(
                                          'KOD TALEBİNİ YENİLE',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w900,
                                            color: DesignTokens.textTertiary,
                                            letterSpacing: 2.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, '/profil/support');
                                    },
                                    child: Text(
                                      'DESTEK HATTINA BAĞLAN',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                        color: DesignTokens.textTertiary,
                                        letterSpacing: 2.0,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            if (isLoading)
              const Positioned.fill(
                child: LoadingOverlay(message: 'İşlem Sürüyor...'),
              ),
          ],
        ),
      ),
    );
  }
}
