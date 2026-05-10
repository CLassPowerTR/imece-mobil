import 'package:flutter/material.dart';

final class CustomColorScheme {
  CustomColorScheme._();

  // Light color scheme
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    
    primary: Color(0xFFFF6000), // --primary-color
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFFF8533), // --primary-light
    onPrimaryContainer: Color(0xFF1E293B),
    
    secondary: Color(0xFF6366F1), // --secondary-color
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFF4F46E5), // --secondary-dark
    onSecondaryContainer: Color(0xFFFFFFFF),
    
    tertiary: Color(0xFFF59E0B), // --accent-color
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFDE68A),
    onTertiaryContainer: Color(0xFFB45309),
    
    error: Color(0xFFEF4444), // --error-color
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFEE2E2),
    onErrorContainer: Color(0xFF991B1B),
    
    surface: Color(0xFFFFFFFF), // --bg-main
    onSurface: Color(0xFF1E293B), // --text-main
    surfaceContainerHighest: Color(0xFFF8FAFC), // --bg-soft
    onSurfaceVariant: Color(0xFF64748B), // --text-soft
    
    outline: Color(0xFFE2E8F0), // --border-color
    outlineVariant: Color(0xFFCBD5E1),
    
    shadow: Color(0x1A000000),
    scrim: Color(0xFF000000),
    
    inverseSurface: Color(0xFF0F172A), // --bg-dark
    onInverseSurface: Color(0xFFF8FAFC), // --text-on-dark
    inversePrimary: Color(0xFFFF8533), // --primary-light
  );

  // Dark color scheme
  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    
    primary: Color(0xFFFF6000), // --primary-color
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFE65600), // --primary-dark
    onPrimaryContainer: Color(0xFFF8FAFC),
    
    secondary: Color(0xFF6366F1), // --secondary-color
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFF4F46E5), // --secondary-dark
    onSecondaryContainer: Color(0xFFFFFFFF),
    
    tertiary: Color(0xFFF59E0B), // --accent-color
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFF92400E),
    onTertiaryContainer: Color(0xFFFEF3C7),
    
    error: Color(0xFFF87171), // Lighter error for dark mode
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFF991B1B),
    onErrorContainer: Color(0xFFFEE2E2),
    
    surface: Color(0xFF0F172A), // --bg-dark
    onSurface: Color(0xFFF8FAFC), // --text-on-dark
    surfaceContainerHighest: Color(0xFF1E293B), // Darker soft background
    onSurfaceVariant: Color(0xFF94A3B8), // --text-soft in dark mode
    
    outline: Color(0xFF334155), // Dark border
    outlineVariant: Color(0xFF475569),
    
    shadow: Color(0x33000000),
    scrim: Color(0xFF000000),
    
    inverseSurface: Color(0xFFFFFFFF), // --bg-main
    onInverseSurface: Color(0xFF1E293B), // --text-main
    inversePrimary: Color(0xFFE65600), // --primary-dark
  );
}
