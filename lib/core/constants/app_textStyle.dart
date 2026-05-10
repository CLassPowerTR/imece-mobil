import 'package:flutter/material.dart';
import 'package:imecehub/core/constants/app_colors.dart';

class AppTextStyle {
  AppTextStyle._();

  // Headers
  static TextStyle headerPrimary(BuildContext context, {Color? color}) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
      fontWeight: FontWeight.w700,
      color: color ?? AppColors.primary(context),
    );
  }

  static TextStyle headerSecondary(BuildContext context, {Color? color}) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
      fontWeight: FontWeight.w700,
      color: color ?? AppColors.secondary(context),
    );
  }

  // Titles
  static TextStyle titlePrimary(BuildContext context, {Color? color}) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(
      fontWeight: FontWeight.w700,
      color: color ?? AppColors.primary(context),
    );
  }

  static TextStyle titleSecondary(BuildContext context, {Color? color}) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(
      fontWeight: FontWeight.w700,
      color: color ?? AppColors.secondary(context),
    );
  }

  // Subtitles
  static TextStyle subtitle(BuildContext context, {Color? color}) {
    return Theme.of(context).textTheme.titleSmall!.copyWith(
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.outline(context),
    );
  }

  static TextStyle subtitleMuted(BuildContext context, {Color? color}) {
    return Theme.of(context).textTheme.titleSmall!.copyWith(
      fontWeight: FontWeight.w500,
      color: color ?? AppColors.outline(context),
    );
  }

  // Body
  static TextStyle bodyMedium(BuildContext context, {Color? color}) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: color ?? AppColors.primary(context),
    );
  }

  static TextStyle bodyMediumBold(BuildContext context, {Color? color}) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      fontWeight: FontWeight.w700,
      color: color ?? AppColors.primary(context),
    );
  }

  static TextStyle bodyMediumMuted(BuildContext context, {Color? color}) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: color ?? AppColors.outline(context),
      fontWeight: FontWeight.w400,
    );
  }

  // Body Small
  static TextStyle bodySmall(BuildContext context, {Color? color}) {
    return Theme.of(context).textTheme.bodySmall!.copyWith(
      color: color ?? AppColors.primary(context),
    );
  }

  static TextStyle bodySmallBold(BuildContext context, {Color? color}) {
    return Theme.of(context).textTheme.bodySmall!.copyWith(
      fontWeight: FontWeight.w700,
      color: color ?? AppColors.primary(context),
    );
  }

  static TextStyle bodySmallMuted(BuildContext context, {Color? color}) {
    return Theme.of(context).textTheme.bodySmall!.copyWith(
      color: color ?? AppColors.outline(context),
      fontWeight: FontWeight.w400,
    );
  }

  // Body Large
  static TextStyle bodyLarge(BuildContext context, {Color? color}) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
      color: color ?? AppColors.primary(context),
    );
  }

  static TextStyle bodyLargeBold(BuildContext context, {Color? color}) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
      fontWeight: FontWeight.w700,
      color: color ?? AppColors.primary(context),
    );
  }

  static TextStyle bodyLargeMuted(BuildContext context, {Color? color}) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
      color: color ?? AppColors.outline(context),
      fontWeight: FontWeight.w400,
    );
  }
}
