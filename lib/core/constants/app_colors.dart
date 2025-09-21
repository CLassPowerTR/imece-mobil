import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppColors {
  AppColors._();
  static Color secondary(BuildContext context) =>
      Theme.of(context).colorScheme.secondary;
  static Color surface(BuildContext context) =>
      Theme.of(context).colorScheme.surface;
  static Color outline(BuildContext context) =>
      Theme.of(context).colorScheme.outline;
  static Color shadow(BuildContext context) =>
      Theme.of(context).colorScheme.shadow;
  static Color tertiary(BuildContext context) =>
      Theme.of(context).colorScheme.tertiary;
  static Color surfaceContainer(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainer;
  static Color onPrimary(BuildContext context) =>
      Theme.of(context).colorScheme.onPrimary;
  static Color onSecondary(BuildContext context) =>
      Theme.of(context).colorScheme.onSecondary;
  static Color onTertiary(BuildContext context) =>
      Theme.of(context).colorScheme.onTertiary;
  static Color onSurface(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;
  static Color onSurfaceVariant(BuildContext context) =>
      Theme.of(context).colorScheme.onSurfaceVariant;
  static Color onError(BuildContext context) =>
      Theme.of(context).colorScheme.onError;
  static Color onErrorContainer(BuildContext context) =>
      Theme.of(context).colorScheme.onErrorContainer;
  static Color onPrimaryContainer(BuildContext context) =>
      Theme.of(context).colorScheme.onPrimaryContainer;
  static Color onSecondaryContainer(BuildContext context) =>
      Theme.of(context).colorScheme.onSecondaryContainer;
  static Color onTertiaryContainer(BuildContext context) =>
      Theme.of(context).colorScheme.onTertiaryContainer;
}
