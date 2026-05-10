import 'package:flutter/material.dart';
import 'package:imecehub/core/constants/app_colors.dart';


// ─────────────────────────────────────────────────────────────────────────────
// Başlık Metni — "ŞİFREMİ UNUTTUM" stilinde
// ─────────────────────────────────────────────────────────────────────────────
Widget forgotPasswordHeadText(BuildContext context) {
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
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
          children: [
            TextSpan(text: 'ŞİFREMİ '),
            TextSpan(
              text: 'UNUTTUM',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 6),
      Text(
        'E-posta adresinizi girin, size bir kod gönderelim',
        style: TextStyle(
          fontSize: 11,
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
// Giriş Sayfasına Dön Butonu
// ─────────────────────────────────────────────────────────────────────────────
Widget backToLoginButton(BuildContext context, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.arrow_back_rounded, size: 16, color: Theme.of(context).colorScheme.outline),
          SizedBox(width: 6),
          Text(
            'GİRİŞ SAYFASINA DÖN',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: AppColors.onPrimaryContainer(context).withValues(alpha: 0.5),
              letterSpacing: 2.0,
            ),
          ),
        ],
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Başarılı Gönderim Görünümü
// ─────────────────────────────────────────────────────────────────────────────
Widget successView(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Icon(Icons.check_circle_outline_rounded, color: Colors.green, size: 48),
        ),
      ),
      SizedBox(height: 24),
      Text(
        'KOD GÖNDERİLDİ!',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w900,
          color: Theme.of(context).colorScheme.onSurface,
          letterSpacing: 1.0,
          fontStyle: FontStyle.italic,
        ),
      ),
      SizedBox(height: 8),
      Text(
        'Lütfen e-posta kutunuzu kontrol edin. Kod giriş sayfasına yönlendiriliyorsunuz...',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: AppColors.onPrimaryContainer(context).withValues(alpha: 0.5),
          letterSpacing: 1.5,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}
