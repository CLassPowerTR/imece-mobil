// lib/core/theme/design_tokens.dart

import 'package:flutter/material.dart';

class DesignTokens {
  // Colors
  static const Color primary = Color(0xFFFF6000);
  static const Color secondary = Color(0xFF6366F1);
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
  
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF9CA3AF);

  static const Color borderColor = Color(0xFFE2E8F0);
  
  // Spacing
  static const double spacing2xs = 4;
  static const double spacingXs = 8;
  static const double spacingSm = 12;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;
  static const double spacing2xl = 40;
  static const double spacing3xl = 48;
  
  // Border Radius
  static const double radiusXs = 4;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 20;
  static const double radius2xl = 24;
  
  // Font Sizes
  static const double fontXs = 10;
  static const double fontSm = 12;
  static const double fontMd = 14;
  static const double fontLg = 16;
  static const double fontXl = 18;
  static const double font2xl = 20;
  static const double font3xl = 24;
  static const double font4xl = 30;
  static const double font5xl = 36;
  
  // Shadows
  static List<BoxShadow> neumorphicShadow({
    Color? baseColor,
    bool isPressed = false,
  }) {
    final color = baseColor ?? backgroundLight;
    
    if (isPressed) {
      return [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          offset: const Offset(2, 2),
          blurRadius: 4,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.white.withOpacity(0.5),
          offset: const Offset(-2, -2),
          blurRadius: 4,
          spreadRadius: 0,
        ),
      ];
    }
    
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.15),
        offset: const Offset(8, 8),
        blurRadius: 15,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: Colors.white.withOpacity(0.7),
        offset: const Offset(-8, -8),
        blurRadius: 15,
        spreadRadius: 0,
      ),
    ];
  }
  
  static List<BoxShadow> cardShadow() {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        offset: const Offset(0, 4),
        blurRadius: 12,
        spreadRadius: 0,
      ),
    ];
  }
  
  static List<BoxShadow> elevatedShadow() {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.12),
        offset: const Offset(0, 6),
        blurRadius: 16,
        spreadRadius: 0,
      ),
    ];
  }
}

