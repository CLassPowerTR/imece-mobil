part of 'sign_in_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Başlık Metni — "HESABINIZA GİRİŞ YAPIN" stilinde
// ─────────────────────────────────────────────────────────────────────────────
Widget headText(BuildContext context, {bool isSmallScreen = false}) {
  return Column(
    children: [
      RichText(
        maxLines: 2,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          style: TextStyle(
            fontSize: isSmallScreen ? 18 : 24,
            fontWeight: FontWeight.w900,
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
          children: [
            TextSpan(text: 'HESABINIZA '),
            TextSpan(
              text: 'GİRİŞ YAPIN',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 6),
      Text(
        'Hoş geldiniz, maceraya devam edin',
        style: TextStyle(
          fontSize: isSmallScreen ? 9 : 11,
          fontWeight: FontWeight.w800,
          color: AppColors.onPrimaryContainer(context).withValues(alpha: 0.5),
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
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'E-POSTA ADRESİ',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: AppColors.onPrimaryContainer(context).withValues(alpha: 0.5),
              letterSpacing: 2.5,
            ),
          ),
        ),
        // Input alanı
        Container(
          height: textFieldHeight ?? 56,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: errorText != null
                  ? Theme.of(context).colorScheme.error
                  : Colors.black87,
              width: 1.5,
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
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 16, right: 12),
                child: Icon(Icons.mail_outline_rounded,
                    color: Theme.of(context).colorScheme.outline, size: 22),
              ),
              prefixIconConstraints:
                  const BoxConstraints(minWidth: 0, minHeight: 0),
              hintText: 'name@email.com',
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ),
        // Hata metni
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(left: 4, top: 6),
            child: Row(
              children: [
                Icon(Icons.error_outline_rounded,
                    size: 14, color: Theme.of(context).colorScheme.error),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    errorText,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.error,
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
          padding: EdgeInsets.only(left: 4, bottom: 8, right: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                containerText.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onPrimaryContainer(context).withValues(alpha: 0.5),
                  letterSpacing: 2.5,
                ),
              ),
              if (onForgotPassword != null)
                GestureDetector(
                  onTap: onForgotPassword,
                  child: Text(
                    'ŞİFREMİ UNUTTUM',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary(context),
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
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: errorText != null
                  ? Theme.of(context).colorScheme.error
                  : Colors.black87,
              width: 1.5,
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
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 16, right: 12),
                child: Icon(Icons.lock_outline_rounded,
                    color: Theme.of(context).colorScheme.outline, size: 22),
              ),
              prefixIconConstraints:
                  const BoxConstraints(minWidth: 0, minHeight: 0),
              suffixIcon: showSuffixIcon
                  ? GestureDetector(
                      onTap: onTap,
                      child: Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: Icon(
                          obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Theme.of(context).colorScheme.outline,
                          size: 22,
                        ),
                      ),
                    )
                  : null,
              suffixIconConstraints:
                  const BoxConstraints(minWidth: 0, minHeight: 0),
              hintText: hintText,
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ),
        // Hata metni
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(left: 4, top: 6),
            child: Row(
              children: [
                Icon(Icons.error_outline_rounded,
                    size: 14, color: Theme.of(context).colorScheme.error),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    errorText,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.error,
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
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'KULLANICI ADI',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: AppColors.onPrimaryContainer(context).withValues(alpha: 0.5),
              letterSpacing: 2.5,
            ),
          ),
        ),
        // Input alanı
        Container(
          height: textFieldHeight ?? 56,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: errorText != null
                  ? Theme.of(context).colorScheme.error
                  : Colors.black87,
              width: 1.5,
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
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 16, right: 12),
                child: Icon(Icons.person_outline_rounded,
                    color: Theme.of(context).colorScheme.outline, size: 22),
              ),
              prefixIconConstraints:
                  const BoxConstraints(minWidth: 0, minHeight: 0),
              hintText: 'Kullanıcı adınızı girin',
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ),
        // Hata metni
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(left: 4, top: 6),
            child: Row(
              children: [
                Icon(Icons.error_outline_rounded,
                    size: 14, color: Theme.of(context).colorScheme.error),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    errorText,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.error,
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
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: isCheckedContract
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isCheckedContract
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline.withOpacity(0.4),
                width: 2,
              ),
            ),
            child: isCheckedContract
                ? Icon(Icons.check_rounded,
                    size: 14, color: Colors.white)
                : null,
          ),
          SizedBox(width: 8),
          // Metin
          Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary(context),
                  letterSpacing: 0.8,
                  height: 1.4,
                ),
                children: [
                  TextSpan(text: 'Hizmet Şartlarını '),
                  TextSpan(
                    text: 've ',
                    style: TextStyle(color: AppColors.secondary(context)),
                  ),
                  TextSpan(text: 'Gizlilik Politikasını '),
                  TextSpan(
                    text: 'okudum ve kabul ediyorum.',
                    style: TextStyle(color: AppColors.secondary(context)),
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
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.3),
      borderRadius: BorderRadius.circular(16),
      elevation: isEnabled ? 8 : 0,
      shadowColor: isEnabled
          ? Theme.of(context).colorScheme.primary.withOpacity(0.25)
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
                SizedBox(width: 12),
                Icon(Icons.login_rounded,
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
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'VEYA',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: AppColors.onPrimaryContainer(context).withValues(alpha: 0.5),
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
  VoidCallback? onTap,
}) {
  return SizedBox(
    width: width,
    height: containerHeight ?? 56,
    child: Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap ?? () {
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
              // Google ikonu
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
              SizedBox(width: 12),
              Text(
                'GOOGLE İLE DEVAM ET',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
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
    padding: EdgeInsets.only(top: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          textFirst,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: AppColors.onPrimaryContainer(context).withValues(alpha: 0.5),
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(width: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
            ),
            child: Text(
              textSecond.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
