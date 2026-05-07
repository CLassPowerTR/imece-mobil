import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imecehub/core/theme/design_tokens.dart';
import 'package:imecehub/core/widgets/loading_overlay.dart';
import 'package:imecehub/core/widgets/showTemporarySnackBar.dart';
import 'package:imecehub/providers/auth_provider.dart';
import 'package:imecehub/screens/home/home_screen.dart';
import 'package:imecehub/services/api_service.dart';

class EmailVerificationScreen extends ConsumerStatefulWidget {
  final String email;

  const EmailVerificationScreen({super.key, required this.email});

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> {
  final TextEditingController _codeController = TextEditingController();
  bool isLoading = false;
  bool isSuccess = false;
  bool isButtonEnabled = false;
  String? errorMessage;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();

    _codeController.addListener(() {

      // Her karakter değiştiğinde çalışır
      setState(() {

        isButtonEnabled = _codeController.text.length == 6;

      });

    });
  }

  // ─── Doğrulama İşlemi ──────────────────────────────────────────────────
  Future<void> _handleVerify() async {
    final code = _codeController.text.trim();
    if (code.length != 6) {
      setState(() => errorMessage = 'Lütfen 6 haneli kodu eksiksiz girin.');
      HapticFeedback.heavyImpact();
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await ApiService.verifyEmail(widget.email, code);

      setState(() {
        isSuccess = true;
        isLoading = false;
      });

      HapticFeedback.mediumImpact();

      // Token kaydedildi, kullanıcı bilgisini çek
      await ref.read(userProvider.notifier).fetchUserMe();

      if (mounted) {
        showTemporarySnackBar(
          context,
          'Doğrulama başarılı!',
          type: SnackBarType.success,
        );

        // 1.5 saniye sonra ana sayfaya yönlendir
        await Future.delayed(const Duration(milliseconds: 1500));

        if (mounted) {
          ref.read(bottomNavIndexProvider.notifier).setIndex(3);
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (route) => false,
            arguments: {'refresh': true},
          );
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString().replaceAll('Exception: ', '');
      });
      HapticFeedback.heavyImpact();
    }
  }

  // ─── Kodu Tekrar Gönder ─────────────────────────────────────────────────
  Future<void> _handleResend() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await ApiService.resendVerificationCode(widget.email);
      setState(() => isLoading = false);

      HapticFeedback.lightImpact();

      if (mounted) {
        showTemporarySnackBar(
          context,
          'Yeni kod e-posta adresinize gönderildi.',
          type: SnackBarType.success,
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString().replaceAll('Exception: ', '');
      });
      HapticFeedback.heavyImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: DesignTokens.textSecondary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ── Logo ──
                  Padding(
                    padding: const EdgeInsets.only(bottom: 28),
                    child: Image.asset(
                      'assets/image/website.png',
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                  ),

                  // ── Kalkan İkonu ──
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: DesignTokens.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: const Icon(
                      Icons.verified_user_rounded,
                      size: 40,
                      color: DesignTokens.primary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Başlık ──
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: DesignTokens.textPrimary,
                        letterSpacing: -0.3,
                      ),
                      children: [
                        TextSpan(text: 'E-POSTA '),
                        TextSpan(
                          text: 'DOĞRULAMA',
                          style: TextStyle(color: DesignTokens.primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── Açıklama ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      widget.email.isNotEmpty
                          ? '${widget.email} adresine gönderilen 6 haneli kodu girin.'
                          : 'Lütfen e-postanıza gönderilen 6 haneli kodu girin.',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: DesignTokens.textTertiary,
                        letterSpacing: 1.5,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── Kod Girişi ──
                  Container(
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: errorMessage != null
                            ? DesignTokens.error
                            : isSuccess
                                ? DesignTokens.success
                                : const Color(0xFFF1F5F9),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _codeController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      textAlign: TextAlign.center,
                      enabled: !isSuccess,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: DesignTokens.textPrimary,
                        letterSpacing: 16,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: '000000',
                        hintStyle: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: DesignTokens.textTertiary.withOpacity(0.2),
                          letterSpacing: 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Hata Banner ──
                  if (errorMessage != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: DesignTokens.error.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: DesignTokens.error.withOpacity(0.15),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // ── Başarı Banner ──
                  if (isSuccess)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: DesignTokens.success.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: DesignTokens.success.withOpacity(0.15),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_rounded,
                              size: 20, color: DesignTokens.success),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'DOĞRULAMA BAŞARILI! YÖNLENDİRİLİYORSUNUZ...',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: DesignTokens.success,
                                letterSpacing: 0.8,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),

                  // ── Doğrula Butonu ──
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: Material(
                      color: (!isSuccess && _codeController.text.length == 6)
                          ? DesignTokens.textPrimary
                          : DesignTokens.textTertiary.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                      elevation: (!isSuccess &&
                              _codeController.text.length == 6)
                          ? 8
                          : 0,
                      shadowColor:
                          DesignTokens.textPrimary.withOpacity(0.25),
                      child: InkWell(
                        onTap: (isLoading ||
                                isSuccess ||
                                _codeController.text.length != 6)
                            ? null
                            : _handleVerify,
                        borderRadius: BorderRadius.circular(16),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                isLoading
                                    ? 'KONTROL EDİLİYOR...'
                                    : 'HESABI DOĞRULA',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 2.0,
                                ),
                              ),
                              if (!isLoading && !isSuccess && isButtonEnabled) ...[
                                const SizedBox(width: 12),
                                const Icon(Icons.arrow_forward_rounded,
                                    color: Colors.white, size: 20),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Kodu Tekrar Gönder ──
                  GestureDetector(
                    onTap: isLoading ? null : _handleResend,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.refresh_rounded,
                          size: 14,
                          color: isLoading
                              ? DesignTokens.textTertiary.withOpacity(0.5)
                              : DesignTokens.textTertiary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'KODU TEKRAR GÖNDER',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: isLoading
                                ? DesignTokens.textTertiary.withOpacity(0.5)
                                : DesignTokens.textTertiary,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),

                  // ── Alt bağlantı ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Farklı bir hesapla mı giriş yapacaksınız?',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: DesignTokens.textTertiary,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/profil/signIn',
                            (route) => false,
                          );
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: DesignTokens.primary,
                                width: 2,
                              ),
                            ),
                          ),
                          child: const Text(
                            'GERİ DÖN',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: DesignTokens.primary,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            // ── Loading Overlay ──
            if (isLoading)
              const Positioned.fill(
                child: LoadingOverlay(message: 'Doğrulanıyor...'),
              ),
          ],
        ),
      ),
    );
  }
}
