import 'package:flutter/material.dart';
import 'package:imecehub/core/theme/design_tokens.dart';
import 'package:imecehub/core/widgets/loading_overlay.dart';
import 'package:imecehub/screens/profil/SignIn/sign_in_screen.dart'; // import to use emailAdressContainer, NextButton, SignInAppBar
import 'package:imecehub/services/api_service.dart';
import 'change_password_widget_items.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  bool isSuccess = false;
  String? errorMessage;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        errorMessage = 'Lütfen geçerli bir e-posta adresi girin.';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await ApiService.fetchForgotPassword(email);
      
      setState(() {
        isSuccess = true;
        isLoading = false;
      });

      // 2.5 saniye sonra doğrulama sayfasına yönlendir (veya emailVerification)
      Future.delayed(const Duration(milliseconds: 2500), () {
        if (mounted) {
          // Normalde burada şifre yenileme / kod girme sayfasına gitmesi gerekir.
          // Geçici olarak doğrulama sayfasına veya geri yönlendirebilirsiniz.
          Navigator.pushReplacementNamed(
            context, 
            '/profil/refreshPassword', 
            arguments: {'email': email}
          );
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
                              successView(context),
                            ] else ...[
                              forgotPasswordHeadText(context),
                              const SizedBox(height: 28),
                              
                              emailAdressContainer(
                                width,
                                context,
                                controller: emailController,
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
                                'Sıfırlama Kodu Gönder',  
                                true,
                                onPressed: _handleSubmit,
                              ),
                              const SizedBox(height: 16),
                              
                              backToLoginButton(context, () {
                                Navigator.pop(context);
                              }),
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
                child: LoadingOverlay(message: 'Kod Gönderiliyor...'),
              ),
          ],
        ),
      ),
    );
  }
}
