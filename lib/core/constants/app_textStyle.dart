import 'package:flutter/widgets.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';

class AppTextStyle {
  AppTextStyle._();

  // Headers
  static TextStyle headerPrimary(BuildContext context, {Color? color}) {
    final style = HomeStyle(context: context);
    return style.headlineSmall.copyWith(
      fontWeight: FontWeight.w700,
      color: color ?? style.primary,
    );
  }

  static TextStyle headerSecondary(BuildContext context, {Color? color}) {
    final style = HomeStyle(context: context);
    return style.headlineSmall.copyWith(
      fontWeight: FontWeight.w700,
      color: color ?? style.secondary,
    );
  }

  // Titles
  static TextStyle titlePrimary(BuildContext context, {Color? color}) {
    final style = HomeStyle(context: context);
    return style.titleMedium.copyWith(
      fontWeight: FontWeight.w700,
      color: color ?? style.primary,
    );
  }

  static TextStyle titleSecondary(BuildContext context, {Color? color}) {
    final style = HomeStyle(context: context);
    return style.titleMedium.copyWith(
      fontWeight: FontWeight.w700,
      color: color ?? style.secondary,
    );
  }

  // Subtitles
  static TextStyle subtitle(BuildContext context, {Color? color}) {
    final style = HomeStyle(context: context);
    return style.titleSmall.copyWith(
      fontWeight: FontWeight.w600,
      color: color ?? style.outline,
    );
  }

  static TextStyle subtitleMuted(BuildContext context, {Color? color}) {
    final style = HomeStyle(context: context);
    return style.titleSmall.copyWith(
      fontWeight: FontWeight.w500,
      color: color ?? style.outline,
    );
  }

  // Body
  static TextStyle bodyMedium(BuildContext context, {Color? color}) {
    final style = HomeStyle(context: context);
    return style.bodyMedium.copyWith(
      color: color ?? style.primary,
    );
  }

  static TextStyle bodyMediumBold(BuildContext context, {Color? color}) {
    final style = HomeStyle(context: context);
    return style.bodyMedium.copyWith(
      fontWeight: FontWeight.w700,
      color: color ?? style.primary,
    );
  }

  static TextStyle bodyMediumMuted(BuildContext context, {Color? color}) {
    final style = HomeStyle(context: context);
    return style.bodyMedium.copyWith(
      color: color ?? style.outline,
      fontWeight: FontWeight.w400,
    );
  }

  // Body
  static TextStyle bodySmall(BuildContext context, {Color? color}) {
    final style = HomeStyle(context: context);
    return style.bodySmall.copyWith(
      color: color ?? style.primary,
    );
  }

  static TextStyle bodySmallBold(BuildContext context, {Color? color}) {
    final style = HomeStyle(context: context);
    return style.bodySmall.copyWith(
      fontWeight: FontWeight.w700,
      color: color ?? style.primary,
    );
  }

  static TextStyle bodySmallMuted(BuildContext context, {Color? color}) {
    final style = HomeStyle(context: context);
    return style.bodySmall.copyWith(
      color: color ?? style.outline,
      fontWeight: FontWeight.w400,
    );
  }

  // Body
  static TextStyle bodyLarge(BuildContext context, {Color? color}) {
    final style = HomeStyle(context: context);
    return style.bodyLarge.copyWith(
      color: color ?? style.primary,
    );
  }

  static TextStyle bodyLargeBold(BuildContext context, {Color? color}) {
    final style = HomeStyle(context: context);
    return style.bodyLarge.copyWith(
      fontWeight: FontWeight.w700,
      color: color ?? style.primary,
    );
  }

  static TextStyle bodyLargeMuted(BuildContext context, {Color? color}) {
    final style = HomeStyle(context: context);
    return style.bodyLarge.copyWith(
      color: color ?? style.outline,
      fontWeight: FontWeight.w400,
    );
  }
}
