import 'package:flutter/material.dart';

final class HomeStyle {
  HomeStyle({required BuildContext context}) : _context = context;
  final BuildContext _context;

  Color get primary => Theme.of(_context).colorScheme.primary;
  Color get secondary => Theme.of(_context).colorScheme.secondary;
  Color get onPrimary => Theme.of(_context).colorScheme.onPrimary;
  Color get onSecondary => Theme.of(_context).colorScheme.onSecondary;
  Color get outline => Theme.of(_context).colorScheme.outline;
  Color get surface => Theme.of(_context).colorScheme.surface;
  Color get secondaryFixedDim =>
      Theme.of(_context).colorScheme.secondaryFixedDim;
  Color get shadow => Theme.of(_context).colorScheme.shadow;
  Color get tertiary => Theme.of(_context).colorScheme.tertiary;
  Color get surfaceContainer => Theme.of(_context).colorScheme.surfaceContainer;
  Color get error => Theme.of(_context).colorScheme.error;
  Color get cardColor => Theme.of(_context).cardColor;

  TextStyle get appBarTextStyle => Theme.of(_context).textTheme.headlineMedium!;
  TextStyle get headlineSmall => Theme.of(_context).textTheme.headlineSmall!;
  TextStyle get headlineMedium => Theme.of(_context).textTheme.headlineMedium!;
  TextStyle get headlineLarge => Theme.of(_context).textTheme.headlineLarge!;
  TextStyle get bodyLarge => Theme.of(_context).textTheme.bodyLarge!;
  TextStyle get bodyMedium => Theme.of(_context).textTheme.bodyMedium!;
  TextStyle get bodySmall => Theme.of(_context).textTheme.bodySmall!;
  TextStyle get titleLarge => Theme.of(_context).textTheme.titleLarge!;
  TextStyle get titleMedium => Theme.of(_context).textTheme.titleMedium!;
  TextStyle get titleSmall => Theme.of(_context).textTheme.titleSmall!;
  TextStyle get displayLarge => Theme.of(_context).textTheme.displayLarge!;
  TextStyle get displayMedium => Theme.of(_context).textTheme.displayMedium!;
  TextStyle get displaySmall => Theme.of(_context).textTheme.displaySmall!;
  TextStyle get labelLarge => Theme.of(_context).textTheme.labelLarge!;
  TextStyle get labelMedium => Theme.of(_context).textTheme.labelMedium!;
  TextStyle get labelSmall => Theme.of(_context).textTheme.labelSmall!;

  EdgeInsets get appBarPadding => const EdgeInsets.symmetric(horizontal: 20);
  EdgeInsets get bottomNavigationBarPadding =>
      const EdgeInsets.symmetric(horizontal: 10, vertical: 10);
  EdgeInsets get bodyPadding => const EdgeInsets.symmetric(horizontal: 10);

  BorderRadius get bottomNavigationBarBorderRadius =>
      BorderRadius.circular(16.0);

  BorderRadius get appBarTextFieldBorderRadius => BorderRadius.circular(26.0);
  BorderRadius get bodyCategoryContainerBorderRadius =>
      BorderRadius.circular(8.0);
}
