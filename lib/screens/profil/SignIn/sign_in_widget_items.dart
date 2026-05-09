part of 'sign_in_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Başlık Metni — "HESABINIZA GİRİŞ YAPIN" stilinde
// ─────────────────────────────────────────────────────────────────────────────
Widget headText(BuildContext context) {
  return Column(
    children: [
      RichText(
        maxLines: 2,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: DesignTokens.textPrimary,
            letterSpacing: -0.5,
          ),
          children: [
            const TextSpan(text: 'HESABINIZA '),
            TextSpan(
              text: 'GİRİŞ YAPIN',
              style: TextStyle(
                color: DesignTokens.primary,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 6),
      Text(
        'Hoş geldiniz, maceraya devam edin',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: DesignTokens.textTertiary,
          letterSpacing: 2.0,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// E-posta Adresi Input Container
// ─────────────────────────────────────────────────────────────────────────────
Widget emailAdressContainer(
  double width,
  BuildContext context, {
  double? textFieldHeight,
  double? containerHeight,
  TextEditingController? controller,
  String? errorText,
}) {
  return SizedBox(
    width: width,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'E-POSTA ADRESİ',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: DesignTokens.textTertiary,
              letterSpacing: 2.5,
            ),
          ),
        ),
        // Input alanı
        Container(
          height: textFieldHeight ?? 56,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: errorText != null
                  ? DesignTokens.error
                  : const Color(0xFFF1F5F9),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(
              color: DesignTokens.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 16, right: 12),
                child: Icon(Icons.mail_outline_rounded,
                    color: DesignTokens.textTertiary, size: 22),
              ),
              prefixIconConstraints:
                  const BoxConstraints(minWidth: 0, minHeight: 0),
              hintText: 'name@email.com',
              hintStyle: TextStyle(
                color: DesignTokens.textTertiary.withOpacity(0.5),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        ),
        // Hata metni
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 6),
            child: Row(
              children: [
                const Icon(Icons.error_outline_rounded,
                    size: 14, color: DesignTokens.error),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    errorText,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: DesignTokens.error,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Şifre Input Container
// ─────────────────────────────────────────────────────────────────────────────
Widget passwordContainer(
  double width,
  BuildContext context, {
  String containerText = 'ŞİFRE',
  String hintText = '••••••••',
  double? textFieldHeight,
  double? containerHeight,
  TextEditingController? textFieldController,
  bool obscureText = false,
  VoidCallback? onTap,
  bool showSuffixIcon = false,
  String? errorText,
  VoidCallback? onForgotPassword,
}) {
  return SizedBox(
    width: width,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label satırı
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8, right: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                containerText.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: DesignTokens.textTertiary,
                  letterSpacing: 2.5,
                ),
              ),
              if (onForgotPassword != null)
                GestureDetector(
                  onTap: onForgotPassword,
                  child: const Text(
                    'ŞİFREMİ UNUTTUM',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: DesignTokens.primary,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
            ],
          ),
        ),
        // Input alanı
        Container(
          height: textFieldHeight ?? 56,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: errorText != null
                  ? DesignTokens.error
                  : const Color(0xFFF1F5F9),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: textFieldController,
            obscureText: obscureText,
            style: const TextStyle(
              color: DesignTokens.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 16, right: 12),
                child: Icon(Icons.lock_outline_rounded,
                    color: DesignTokens.textTertiary, size: 22),
              ),
              prefixIconConstraints:
                  const BoxConstraints(minWidth: 0, minHeight: 0),
              suffixIcon: showSuffixIcon
                  ? GestureDetector(
                      onTap: onTap,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Icon(
                          obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: DesignTokens.textTertiary,
                          size: 22,
                        ),
                      ),
                    )
                  : null,
              suffixIconConstraints:
                  const BoxConstraints(minWidth: 0, minHeight: 0),
              hintText: hintText,
              hintStyle: TextStyle(
                color: DesignTokens.textTertiary.withOpacity(0.5),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        ),
        // Hata metni
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 6),
            child: Row(
              children: [
                const Icon(Icons.error_outline_rounded,
                    size: 14, color: DesignTokens.error),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    errorText,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: DesignTokens.error,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Kullanıcı Adı Input Container (SignUp için)
// ─────────────────────────────────────────────────────────────────────────────
Widget usernameContainer(
  double width,
  BuildContext context, {
  double? textFieldHeight,
  double? containerHeight,
  TextEditingController? controller,
  String? errorText,
}) {
  return SizedBox(
    width: width,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'KULLANICI ADI',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: DesignTokens.textTertiary,
              letterSpacing: 2.5,
            ),
          ),
        ),
        // Input alanı
        Container(
          height: textFieldHeight ?? 56,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: errorText != null
                  ? DesignTokens.error
                  : const Color(0xFFF1F5F9),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.text,
            style: const TextStyle(
              color: DesignTokens.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 16, right: 12),
                child: Icon(Icons.person_outline_rounded,
                    color: DesignTokens.textTertiary, size: 22),
              ),
              prefixIconConstraints:
                  const BoxConstraints(minWidth: 0, minHeight: 0),
              hintText: 'Kullanıcı adınızı girin',
              hintStyle: TextStyle(
                color: DesignTokens.textTertiary.withOpacity(0.5),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        ),
        // Hata metni
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 6),
            child: Row(
              children: [
                const Icon(Icons.error_outline_rounded,
                    size: 14, color: DesignTokens.error),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    errorText,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: DesignTokens.error,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Sözleşme Checkbox
// ─────────────────────────────────────────────────────────────────────────────
SizedBox checkContract(
  double width,
  BuildContext context,
  bool isCheckedContract,
  ValueChanged<bool?> onChanged,
) {
  return SizedBox(
    width: width,
    child: GestureDetector(
      onTap: () => onChanged(!isCheckedContract),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Checkbox
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: isCheckedContract
                  ? DesignTokens.primary
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isCheckedContract
                    ? DesignTokens.primary
                    : DesignTokens.textTertiary.withOpacity(0.4),
                width: 2,
              ),
            ),
            child: isCheckedContract
                ? const Icon(Icons.check_rounded,
                    size: 16, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 12),
          // Metin
          Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: DesignTokens.textSecondary,
                  letterSpacing: 0.8,
                  height: 1.4,
                ),
                children: const [
                  TextSpan(text: 'Hizmet Şartlarını '),
                  TextSpan(
                    text: 've ',
                    style: TextStyle(color: DesignTokens.textTertiary),
                  ),
                  TextSpan(text: 'Gizlilik Politikasını '),
                  TextSpan(
                    text: 'okudum ve kabul ediyorum.',
                    style: TextStyle(color: DesignTokens.textTertiary),
                  ),
                ],
              ),
              maxLines: 2,
            ),
          ),
        ],
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Giriş Yap / Üye Ol Butonu
// ─────────────────────────────────────────────────────────────────────────────
SizedBox NextButton(
  BuildContext context,
  String buttonText,
  bool isCheckedContract, {
  double? minSizeHeight,
  VoidCallback? onPressed,
}) {
  final isEnabled = isCheckedContract && onPressed != null;

  return SizedBox(
    width: double.infinity,
    height: minSizeHeight ?? 56,
    child: Material(
      color: isEnabled
          ? DesignTokens.primary
          : DesignTokens.textTertiary.withOpacity(0.3),
      borderRadius: BorderRadius.circular(16),
      elevation: isEnabled ? 8 : 0,
      shadowColor: isEnabled
          ? DesignTokens.primary.withOpacity(0.25)
          : Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? onPressed : null,
        borderRadius: BorderRadius.circular(16),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                buttonText.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 2.5,
                ),
              ),
              if (isEnabled) ...[
                const SizedBox(width: 12),
                const Icon(Icons.login_rounded,
                    color: Colors.white, size: 20),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// "VEYA" Ayırıcı Çizgi
// ─────────────────────────────────────────────────────────────────────────────
SizedBox orLine(double width, BuildContext context,
    {double? containerHeight}) {
  return SizedBox(
    width: width,
    height: containerHeight ?? 32,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            height: 2,
            color: const Color(0xFFF1F5F9),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'VEYA',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: DesignTokens.textTertiary.withOpacity(0.5),
              letterSpacing: 3.0,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 2,
            color: const Color(0xFFF1F5F9),
          ),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Google ile Giriş Butonu
// ─────────────────────────────────────────────────────────────────────────────
Widget signInWithGoogle(
  BuildContext context,
  double width, {
  double? containerHeight,
}) {
  return SizedBox(
    width: width,
    height: containerHeight ?? 56,
    child: Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          showTemporarySnackBar(context, 'Bu özellik yakında eklenecek...');
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFF1F5F9),
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Google ikonu — SVG yerine basit "G" harfi kullanılır
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: SvgPicture.network(
                  'https://raw.githubusercontent.com/MuhammedIkbalAKGUNDOGDU/imece-test-website/25c552598d725eb3014df326583506b5f22215e8/imece/src/assets/vectors/google.svg',
                  width: 22,
                  height: 22,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'GOOGLE İLE DEVAM ET',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: DesignTokens.textSecondary,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// "Hesabınız yok mu? Kayıt Olun" Metni
// ─────────────────────────────────────────────────────────────────────────────
Widget signUpText(
  BuildContext context,
  VoidCallback onTap, {
  String textSecond = 'Kayıt Olun',
  String textFirst = 'Hesabınız yok mu?',
}) {
  return Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          textFirst,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: DesignTokens.textTertiary,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: DesignTokens.primary,
                  width: 2,
                ),
              ),
            ),
            child: Text(
              textSecond.toUpperCase(),
              style: const TextStyle(
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
  );
}
