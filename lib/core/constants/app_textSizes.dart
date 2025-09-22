import 'package:flutter/widgets.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';

class AppTextSizes {
  AppTextSizes._();
  static double? bodyLarge(BuildContext context) =>
      HomeStyle(context: context).bodyLarge.fontSize;
  static double? bodyMedium(BuildContext context) =>
      HomeStyle(context: context).bodyMedium.fontSize;
  static double? bodySmall(BuildContext context) =>
      HomeStyle(context: context).bodySmall.fontSize;
  static double? headlineLarge(BuildContext context) =>
      HomeStyle(context: context).headlineLarge.fontSize;
  static double? headlineMedium(BuildContext context) =>
      HomeStyle(context: context).headlineMedium.fontSize;
  static double? headlineSmall(BuildContext context) =>
      HomeStyle(context: context).headlineSmall.fontSize;
  static double? displayLarge(BuildContext context) =>
      HomeStyle(context: context).displayLarge.fontSize;
  static double? displayMedium(BuildContext context) =>
      HomeStyle(context: context).displayMedium.fontSize;
  static double? displaySmall(BuildContext context) =>
      HomeStyle(context: context).displaySmall.fontSize;
  static double? labelLarge(BuildContext context) =>
      HomeStyle(context: context).labelLarge.fontSize;
  static double? labelMedium(BuildContext context) =>
      HomeStyle(context: context).labelMedium.fontSize;
  static double? labelSmall(BuildContext context) =>
      HomeStyle(context: context).labelSmall.fontSize;
}
