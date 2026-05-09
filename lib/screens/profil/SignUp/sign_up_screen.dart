part of '../SignIn/sign_in_screen.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  bool isCheckedContract = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isLoading = false;
  Map<String, dynamic>? errorMessage;
  String? emailValidationError;
  bool showPassword = true;
  bool showConfirmPassword = true;

  // Şifre kuralları
  bool get _minLength => passwordController.text.length >= 8;
  bool get _hasUpperCase =>
      RegExp(r'[A-Z]').hasMatch(passwordController.text);
  bool get _hasNumber => RegExp(r'[0-9]').hasMatch(passwordController.text);
  bool get _hasSpecialChar =>
      RegExp(r'[!@#$%^&*(),.?":{}|<>_\-]').hasMatch(passwordController.text);
  bool get _isPasswordValid =>
      _minLength && _hasUpperCase && _hasNumber && _hasSpecialChar;
  bool get _passwordsMatch =>
      passwordController.text.isNotEmpty &&
      confirmPasswordController.text.isNotEmpty &&
      passwordController.text == confirmPasswordController.text;

  @override
  void initState() {
    super.initState();
    passwordController.addListener(() => setState(() {}));
    confirmPasswordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = double.infinity;

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                            // ── Logo ──
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Image.asset(
                                'assets/image/website.png',
                                height: 36,
                                fit: BoxFit.contain,
                              ),
                            ),

                            // ── Başlık ──
                            _buildHeader(),
                            const SizedBox(height: 24),

                            // ── Kullanıcı Adı ──
                            usernameContainer(
                              width,
                              context,
                              controller: usernameController,
                              errorText: errorMessage?['username'] != null
                                  ? (errorMessage?['username'] is List
                                      ? (errorMessage?['username'] as List).join(', ')
                                      : errorMessage?['username'].toString())
                                  : null,
                            ),
                            const SizedBox(height: 14),

                            // ── E-posta ──
                            emailAdressContainer(
                              width,
                              context,
                              controller: emailController,
                              errorText: emailValidationError ??
                                  (errorMessage?['email'] != null
                                      ? (errorMessage?['email'] is List
                                          ? (errorMessage?['email'] as List).join(', ')
                                          : errorMessage?['email'].toString())
                                      : null),
                            ),
                            const SizedBox(height: 14),

                            // ── Şifre & Tekrar (yan yana) ──
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Şifre
                                Expanded(
                                  child: _buildCompactPasswordField(
                                    label: 'ŞİFRE',
                                    controller: passwordController,
                                    obscure: showPassword,
                                    onToggle: () =>
                                        setState(() => showPassword = !showPassword),
                                    errorText: errorMessage?['password'] != null
                                        ? (errorMessage?['password'] is List
                                            ? (errorMessage?['password'] as List)
                                                .join(', ')
                                            : errorMessage?['password'].toString())
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Tekrar
                                Expanded(
                                  child: _buildCompactPasswordField(
                                    label: 'TEKRAR',
                                    controller: confirmPasswordController,
                                    obscure: showConfirmPassword,
                                    onToggle: () => setState(
                                        () => showConfirmPassword = !showConfirmPassword),
                                    errorText: null,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // ── Şifre Kuralları ──
                            if (passwordController.text.isNotEmpty)
                              _buildPasswordRules(),
                            const SizedBox(height: 12),

                            // ── Sözleşme ──
                            checkContract(width, context, isCheckedContract, (value) {
                              setState(() {
                                isCheckedContract = value!;
                              });
                            }),
                            const SizedBox(height: 10),

                            // ── Hata Banner ──
                            if (errorMessage != null &&
                                errorMessage!.values.any((v) => v != null))
                              _buildErrorBanner(
                                errorMessage!.values
                                    .where((v) => v != null)
                                    .map((v) =>
                                        v is List ? v.join(', ') : v.toString())
                                    .join('\n'),
                              ),
                            const SizedBox(height: 8),

                            // ── Kayıt Ol Butonu ──
                            _buildRegisterButton(context),
                            const SizedBox(height: 16),

                            // ── Veya ──
                            orLine(width, context, containerHeight: 24),
                            const SizedBox(height: 16),

                            // ── Google ile Kayıt ──
                            signInWithGoogle(context, width, containerHeight: 50),
                            const SizedBox(height: 24),

                            // ── Alt bağlantılar ──
                            signUpText(
                              context,
                              () => Navigator.pushNamed(context, '/profil/signIn'),
                              textFirst: 'Zaten bir hesabınız var mı?',
                              textSecond: 'Giriş Yapın',
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // ── Loading Overlay ──
            if (isLoading)
              const Positioned.fill(
                child: LoadingOverlay(message: 'Kayıt yapılıyor...'),
              ),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────
  // Başlık Widget'ı
  // ───────────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Column(
      children: [
        RichText(
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          text: const TextSpan(
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: DesignTokens.textPrimary,
              letterSpacing: -0.3,
            ),
            children: [
              TextSpan(
                text: 'İMECEHUB\'YE ',
                style: TextStyle(color: DesignTokens.primary),
              ),
              TextSpan(text: 'HOŞ GELDİN'),
            ],
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Hemen ücretsiz hesabınızı oluşturun',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: DesignTokens.textTertiary,
            letterSpacing: 2.0,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ───────────────────────────────────────────────────────────────────────
  // Kompakt Şifre Alanı (yan yana kullanım için)
  // ───────────────────────────────────────────────────────────────────────
  Widget _buildCompactPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              color: DesignTokens.textTertiary,
              letterSpacing: 2.0,
            ),
          ),
        ),
        // Input
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: errorText != null
                  ? DesignTokens.error
                  : const Color(0xFFF1F5F9),
              width: 2,
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            style: const TextStyle(
              color: DesignTokens.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
            decoration: InputDecoration(
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 12, right: 8),
                child: Icon(Icons.lock_outline_rounded,
                    color: DesignTokens.textTertiary, size: 18),
              ),
              prefixIconConstraints:
                  const BoxConstraints(minWidth: 0, minHeight: 0),
              suffixIcon: GestureDetector(
                onTap: onToggle,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(
                    obscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: DesignTokens.textTertiary,
                    size: 18,
                  ),
                ),
              ),
              suffixIconConstraints:
                  const BoxConstraints(minWidth: 0, minHeight: 0),
              hintText: '••••••••',
              hintStyle: TextStyle(
                color: DesignTokens.textTertiary.withOpacity(0.5),
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ),
        // Hata
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 4),
            child: Text(
              errorText,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: DesignTokens.error,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }

  // ───────────────────────────────────────────────────────────────────────
  // Şifre Kuralları Gösterimi
  // ───────────────────────────────────────────────────────────────────────
  Widget _buildPasswordRules() {
    final rules = [
      _PasswordRule(label: '8 Karakter', met: _minLength),
      _PasswordRule(label: 'Büyük Harf', met: _hasUpperCase),
      _PasswordRule(label: 'Rakam', met: _hasNumber),
      _PasswordRule(label: 'Özel Karakter', met: _hasSpecialChar),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        children: rules.map((rule) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                rule.met ? Icons.check_rounded : Icons.close_rounded,
                size: 14,
                color: rule.met
                    ? DesignTokens.success
                    : DesignTokens.textTertiary.withOpacity(0.4),
              ),
              const SizedBox(width: 4),
              Text(
                rule.label.toUpperCase(),
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  color: rule.met
                      ? DesignTokens.success
                      : DesignTokens.textTertiary,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────
  // Hata Banner
  // ───────────────────────────────────────────────────────────────────────
  Widget _buildErrorBanner(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: DesignTokens.error.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DesignTokens.error.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          const Icon(Icons.cancel_rounded,
              size: 16, color: DesignTokens.error),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: DesignTokens.error,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────
  // Kayıt Ol Butonu
  // ───────────────────────────────────────────────────────────────────────
  Widget _buildRegisterButton(BuildContext context) {
    final isFormValid = isCheckedContract &&
        usernameController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        _isPasswordValid &&
        _passwordsMatch;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Material(
        color: isFormValid
            ? DesignTokens.textPrimary
            : DesignTokens.textTertiary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(14),
        elevation: isFormValid ? 6 : 0,
        shadowColor: isFormValid
            ? DesignTokens.textPrimary.withOpacity(0.25)
            : Colors.transparent,
        child: InkWell(
          onTap: isFormValid ? _handleRegister : null,
          borderRadius: BorderRadius.circular(14),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isLoading
                      ? 'İŞLEMİNİZ YAPILIYOR...'
                      : 'KAYIT OL VE İLERLE',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 2.0,
                  ),
                ),
                if (!isLoading) ...[
                  const SizedBox(width: 10),
                  const Icon(Icons.person_add_alt_1_rounded,
                      color: Colors.white, size: 16),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────
  // Kayıt İşlemi
  // ───────────────────────────────────────────────────────────────────────
  Future<void> _handleRegister() async {
    // E-posta format kontrolü
    final email = emailController.text.trim();
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (email.isEmpty) {
      setState(() => emailValidationError = 'E-posta adresi giriniz');
      return;
    }
    if (!emailRegex.hasMatch(email)) {
      setState(
          () => emailValidationError = 'Geçerli bir e-posta adresi giriniz');
      return;
    }
    if (usernameController.text.trim().isEmpty) {
      setState(() {
        emailValidationError = null;
        errorMessage = {'username': 'Kullanıcı adı giriniz'};
      });
      return;
    }
    if (passwordController.text.trim().isEmpty) {
      setState(() {
        emailValidationError = null;
        errorMessage = {'password': 'Şifre giriniz'};
      });
      return;
    }
    if (!_passwordsMatch) {
      setState(() {
        emailValidationError = null;
        errorMessage = {'password': 'Şifreler eşleşmiyor'};
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
      emailValidationError = null;
    });

    try {
      await ref.read(userProvider.notifier).register(
            email: emailController.text.trim(),
            username: usernameController.text.trim(),
            password: passwordController.text.trim(),
          );
      setState(() => isLoading = false);

      HapticFeedback.mediumImpact();

      if (mounted) {
        // Kayıt başarılı — e-posta doğrulama sayfasına yönlendir
        Navigator.pushReplacementNamed(
          context,
          '/profil/verifyEmail',
          arguments: {'email': emailController.text.trim()},
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        Map<String, dynamic>? parsed;
        try {
          final s = e.toString();
          final start = s.indexOf('{');
          final end = s.lastIndexOf('}');
          if (start != -1 && end != -1 && end > start) {
            parsed = json.decode(s.substring(start, end + 1))
                as Map<String, dynamic>;
          }
        } catch (_) {
          parsed = null;
        }
        if (parsed != null) {
          if (parsed['errors'] is Map<String, dynamic>) {
            errorMessage = Map<String, dynamic>.from(parsed['errors']);
          } else {
            errorMessage = parsed;
          }
        } else {
          final message = e.toString();
          errorMessage = {
            'email': message.contains('email') ? message : null,
            'username': message.contains('username') ? message : null,
            'password': message.contains('password') ? message : null,
          };
        }
      });

      HapticFeedback.heavyImpact();
    }
  }
}

// ─── Helper class ────────────────────────────────────────────────────────────
class _PasswordRule {
  final String label;
  final bool met;
  const _PasswordRule({required this.label, required this.met});
}
