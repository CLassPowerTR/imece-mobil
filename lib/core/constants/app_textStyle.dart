import 'package:flutter/widgets.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';

class AppTextStyle {
  AppTextStyle._();

  // Headers
  static TextStyle headerPrimary(BuildContext context) {
    final style = HomeStyle(context: context);
    return style.headlineSmall.copyWith(
      fontWeight: FontWeight.w700,
      color: style.primary,
    );
  }

  static TextStyle headerSecondary(BuildContext context) {
    final style = HomeStyle(context: context);
    return style.headlineSmall.copyWith(
      fontWeight: FontWeight.w700,
      color: style.secondary,
    );
  }

  // Titles
  static TextStyle titlePrimary(BuildContext context) {
    final style = HomeStyle(context: context);
    return style.titleMedium.copyWith(
      fontWeight: FontWeight.w700,
      color: style.primary,
    );
  }

  static TextStyle titleSecondary(BuildContext context) {
    final style = HomeStyle(context: context);
    return style.titleMedium.copyWith(
      fontWeight: FontWeight.w700,
      color: style.secondary,
    );
  }

  // Subtitles
  static TextStyle subtitle(BuildContext context) {
    final style = HomeStyle(context: context);
    return style.titleSmall.copyWith(
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle subtitleMuted(BuildContext context) {
    final style = HomeStyle(context: context);
    return style.titleSmall.copyWith(
      fontWeight: FontWeight.w500,
      color: style.outline,
    );
  }

  // Body
  static TextStyle bodyMedium(BuildContext context) {
    final style = HomeStyle(context: context);
    return style.bodyMedium;
  }

  static TextStyle bodyMediumBold(BuildContext context) {
    final style = HomeStyle(context: context);
    return style.bodyMedium.copyWith(
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle bodyMediumMuted(BuildContext context) {
    final style = HomeStyle(context: context);
    return style.bodyMedium.copyWith(
      color: style.outline,
      fontWeight: FontWeight.w400,
    );
  }

  // Body
  static TextStyle bodySmall(BuildContext context) {
    final style = HomeStyle(context: context);
    return style.bodySmall;
  }

  static TextStyle bodySmallBold(BuildContext context) {
    final style = HomeStyle(context: context);
    return style.bodySmall.copyWith(
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle bodySmallMuted(BuildContext context) {
    final style = HomeStyle(context: context);
    return style.bodySmall.copyWith(
      color: style.outline,
      fontWeight: FontWeight.w400,
    );
  }

  // Body
  static TextStyle bodyLarge(BuildContext context) {
    final style = HomeStyle(context: context);
    return style.bodyLarge;
  }

  static TextStyle bodyLargeBold(BuildContext context) {
    final style = HomeStyle(context: context);
    return style.bodyLarge.copyWith(
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle bodyLargeMuted(BuildContext context) {
    final style = HomeStyle(context: context);
    return style.bodyLarge.copyWith(
      color: style.outline,
      fontWeight: FontWeight.w400,
    );
  }
}
