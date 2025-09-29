import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';

class AppColors {
  AppColors._();
  static Color secondary(BuildContext context) =>
      HomeStyle(context: context).secondary;
  static Color surface(BuildContext context) =>
      HomeStyle(context: context).surface;
  static Color primary(BuildContext context) =>
      HomeStyle(context: context).primary;
  static Color outline(BuildContext context) =>
      HomeStyle(context: context).outline;
  static Color shadow(BuildContext context) =>
      HomeStyle(context: context).shadow;
  static Color secondaryFixedDim(BuildContext context) =>
      HomeStyle(context: context).secondaryFixedDim;
  static Color error(BuildContext context) => HomeStyle(context: context).error;
  static Color tertiary(BuildContext context) =>
      HomeStyle(context: context).tertiary;
  static Color surfaceContainer(BuildContext context) =>
      HomeStyle(context: context).surfaceContainer;
  static Color onPrimary(BuildContext context) =>
      HomeStyle(context: context).onPrimary;
  static Color onSecondary(BuildContext context) =>
      HomeStyle(context: context).onSecondary;
  static Color cardColor(BuildContext context) => Colors.grey[100]!;
  static Color succesful(BuildContext context) => Colors.green;
  static Color orange(BuildContext context) => Colors.orange;
  static Color blue(BuildContext context) => Colors.blue;
}
