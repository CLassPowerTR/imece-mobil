import 'package:flutter/material.dart';

class AppTextSizes {
  AppTextSizes._();
  
  static double? bodyLarge(BuildContext context) => Theme.of(context).textTheme.bodyLarge?.fontSize;
  static double? bodyMedium(BuildContext context) => Theme.of(context).textTheme.bodyMedium?.fontSize;
  static double? bodySmall(BuildContext context) => Theme.of(context).textTheme.bodySmall?.fontSize;
  
  static double? headlineLarge(BuildContext context) => Theme.of(context).textTheme.headlineLarge?.fontSize;
  static double? headlineMedium(BuildContext context) => Theme.of(context).textTheme.headlineMedium?.fontSize;
  static double? headlineSmall(BuildContext context) => Theme.of(context).textTheme.headlineSmall?.fontSize;
  
  static double? displayLarge(BuildContext context) => Theme.of(context).textTheme.displayLarge?.fontSize;
  static double? displayMedium(BuildContext context) => Theme.of(context).textTheme.displayMedium?.fontSize;
  static double? displaySmall(BuildContext context) => Theme.of(context).textTheme.displaySmall?.fontSize;
  
  static double? labelLarge(BuildContext context) => Theme.of(context).textTheme.labelLarge?.fontSize;
  static double? labelMedium(BuildContext context) => Theme.of(context).textTheme.labelMedium?.fontSize;
  static double? labelSmall(BuildContext context) => Theme.of(context).textTheme.labelSmall?.fontSize;
  
  static double? titleLarge(BuildContext context) => Theme.of(context).textTheme.titleLarge?.fontSize;
  static double? titleMedium(BuildContext context) => Theme.of(context).textTheme.titleMedium?.fontSize;
  static double? titleSmall(BuildContext context) => Theme.of(context).textTheme.titleSmall?.fontSize;
}
