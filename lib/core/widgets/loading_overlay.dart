import 'package:flutter/material.dart';
import 'package:imecehub/core/theme/design_tokens.dart';

/// Ana loading overlay widget'ı.
///
/// Ekranın üstüne yarı saydam bir katman koyarak kullanıcıya
/// yükleme durumunu gösterir. Ortasında website.png logosu ve
/// etrafında dönen circular progress indicator bulunur.
///
/// [message] — logo altında gösterilecek durum mesajı (headlineSmall).
/// Altında "LÜTFEN BEKLEYİNİZ" sabit metni (bodyMedium, tertiary renk) yer alır.
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    required this.message,
  });

  /// Logo altında gösterilecek durum mesajı.
  final String message;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: Colors.black.withOpacity(0.45),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo + CircularProgressIndicator
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Dönen halka — DesignTokens.primary rengi
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      strokeWidth: 3.5,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        DesignTokens.primary,
                      ),
                    ),
                  ),
                  // Logo görseli
                  ClipOval(
                    child: Image.asset(
                      'assets/image/website.png',
                      width: 64,
                      height: 64,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Durum mesajı — headlineSmall
            Text(
              message,
              style: textTheme.headlineSmall?.copyWith(
                color: DesignTokens.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Sabit "LÜTFEN BEKLEYİNİZ" — bodyMedium, tertiary renk
            Text(
              'LÜTFEN BEKLEYİNİZ',
              style: textTheme.bodyMedium?.copyWith(
                color: DesignTokens.textTertiary,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
