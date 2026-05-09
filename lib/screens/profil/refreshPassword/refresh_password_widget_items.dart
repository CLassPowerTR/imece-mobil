import 'package:flutter/material.dart';
import 'package:imecehub/core/theme/design_tokens.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Başlık Metni — "ŞİFRE YENİLEME" stilinde
// ─────────────────────────────────────────────────────────────────────────────
Widget refreshPasswordHeadText(BuildContext context) {
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
            const TextSpan(text: 'ŞİFRE '),
            TextSpan(
              text: 'YENİLEME',
              style: TextStyle(
                color: DesignTokens.primary,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 6),
      Text(
        'E-posta kodunu ve yeni şifrenizi girin',
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
// Animasyonlu Başarılı Gönderim Görünümü
// ─────────────────────────────────────────────────────────────────────────────
Widget animatedSuccessView(BuildContext context) {
  return TweenAnimationBuilder<double>(
    tween: Tween<double>(begin: 0.0, end: 1.0),
    duration: const Duration(milliseconds: 600),
    curve: Curves.easeOutBack,
    builder: (context, value, child) {
      return Transform.scale(
        scale: value,
        child: Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Column(
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
                'ŞİFRE DEĞİŞTİRİLDİ!',
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
                'Şifreniz başarıyla güncellendi. Giriş sayfasına yönlendiriliyorsunuz...',
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
          ),
        ),
      );
    },
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// OTP Giriş Kutucukları (6 Haneli)
// ─────────────────────────────────────────────────────────────────────────────
Widget otpInputBoxes({
  required String code,
  required Function(String) onChanged,
  required BuildContext context,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(
          '6 HANELİ KOD',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: DesignTokens.textTertiary,
            letterSpacing: 2.5,
          ),
        ),
      ),
      Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              bool isFilled = index < code.length;
              bool isActive = index == code.length;
              return Container(
                width: 45,
                height: 56,
                decoration: BoxDecoration(
                  color: isFilled ? Colors.white : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isActive
                        ? DesignTokens.primary
                        : (isFilled ? DesignTokens.primary.withOpacity(0.5) : const Color(0xFFF1F5F9)),
                    width: 2,
                  ),
                  boxShadow: isFilled || isActive
                      ? [
                          BoxShadow(
                            color: DesignTokens.primary.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  isFilled ? code[index] : '',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: DesignTokens.textPrimary,
                  ),
                ),
              );
            }),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0.0,
              child: TextField(
                autofocus: true,
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged: onChanged,
                style: const TextStyle(fontSize: 24),
                decoration: const InputDecoration(
                  counterText: "",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
