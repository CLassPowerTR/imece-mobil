import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static Color primary(BuildContext context) =>
      Theme.of(context).colorScheme.primary;
  static Color onPrimary(BuildContext context) =>
      Theme.of(context).colorScheme.onPrimary;
  static Color primaryContainer(BuildContext context) =>
      Theme.of(context).colorScheme.primaryContainer;
  static Color onPrimaryContainer(BuildContext context) =>
      Theme.of(context).colorScheme.onPrimaryContainer;

  // Secondary
  static Color secondary(BuildContext context) =>
      Theme.of(context).colorScheme.secondary;
  static Color onSecondary(BuildContext context) =>
      Theme.of(context).colorScheme.onSecondary;
  static Color secondaryContainer(BuildContext context) =>
      Theme.of(context).colorScheme.secondaryContainer;
  static Color onSecondaryContainer(BuildContext context) =>
      Theme.of(context).colorScheme.onSecondaryContainer;
  static Color secondaryFixedDim(BuildContext context) =>
      Theme.of(context).colorScheme.secondaryContainer;

  // Tertiary
  static Color tertiary(BuildContext context) =>
      Theme.of(context).colorScheme.tertiary;
  static Color onTertiary(BuildContext context) =>
      Theme.of(context).colorScheme.onTertiary;
  static Color tertiaryContainer(BuildContext context) =>
      Theme.of(context).colorScheme.tertiaryContainer;
  static Color onTertiaryContainer(BuildContext context) =>
      Theme.of(context).colorScheme.onTertiaryContainer;

  // Error
  static Color error(BuildContext context) =>
      Theme.of(context).colorScheme.error;
  static Color onError(BuildContext context) =>
      Theme.of(context).colorScheme.onError;
  static Color onErrorContainer(BuildContext context) =>
      Theme.of(context).colorScheme.onErrorContainer;
  static Color errorContainer(BuildContext context) =>
      Theme.of(context).colorScheme.errorContainer;

  // Surface
  static Color surface(BuildContext context) =>
      Theme.of(context).colorScheme.surface;
  static Color onSurface(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;
  static Color surfaceContainer(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainerHighest;
  static Color onSurfaceVariant(BuildContext context) =>
      Theme.of(context).colorScheme.onSurfaceVariant;

  // Outline
  static Color outlineVariant(BuildContext context) =>
      Theme.of(context).colorScheme.outlineVariant;
  static Color outline(BuildContext context) =>
      Theme.of(context).colorScheme.outline;

  // Shadow & Scrim
  static Color shadow(BuildContext context) =>
      Theme.of(context).colorScheme.shadow;
  static Color scrim(BuildContext context) =>
      Theme.of(context).colorScheme.scrim;

  // Inverse
  static Color inverseSurface(BuildContext context) =>
      Theme.of(context).colorScheme.inverseSurface;
  static Color onInverseSurface(BuildContext context) =>
      Theme.of(context).colorScheme.onInverseSurface;
  static Color inversePrimary(BuildContext context) =>
      Theme.of(context).colorScheme.inversePrimary;

  // Card
  static Color cardColor(BuildContext context) =>
      Theme.of(context).cardColor;

  // Scaffold
  static Color scaffoldBackgroundColor(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor;

  // Fixed Colors (context-free)
  static Color succesful(BuildContext context) => const Color(0xFF10B981);
  static Color warning(BuildContext context) => const Color(0xFFF59E0B);
  static Color info(BuildContext context) => const Color(0xFF3B82F6);

  // Named colors
  static Color blue(BuildContext context) => const Color(0xFF3B82F6);
  static Color orange(BuildContext context) => const Color(0xFFF59E0B);
  static Color iosBlue(BuildContext context) => const Color(0xFF0087FF);
  static Color purple(BuildContext context) => Colors.purple;
}
