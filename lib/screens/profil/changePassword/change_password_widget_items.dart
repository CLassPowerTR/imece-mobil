import 'package:flutter/material.dart';
import 'package:imecehub/core/theme/design_tokens.dart';

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
            color: DesignTokens.textPrimary,
            letterSpacing: -0.5,
          ),
          children: [
            const TextSpan(text: 'ŞİFREMİ '),
            TextSpan(
              text: 'UNUTTUM',
              style: TextStyle(
                color: DesignTokens.primary,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 6),
      Text(
        'E-posta adresinizi girin, size bir kod gönderelim',
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
// Giriş Sayfasına Dön Butonu
// ─────────────────────────────────────────────────────────────────────────────
Widget backToLoginButton(BuildContext context, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.arrow_back_rounded, size: 16, color: DesignTokens.textTertiary),
          const SizedBox(width: 6),
          Text(
            'GİRİŞ SAYFASINA DÖN',
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
      const SizedBox(height: 24),
      Text(
        'KOD GÖNDERİLDİ!',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w900,
          color: DesignTokens.textPrimary,
          letterSpacing: 1.0,
          fontStyle: FontStyle.italic,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        'Lütfen e-posta kutunuzu kontrol edin. Kod giriş sayfasına yönlendiriliyorsunuz...',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: DesignTokens.textTertiary,
          letterSpacing: 1.5,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}
