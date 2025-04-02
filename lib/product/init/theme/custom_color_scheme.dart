import 'package:flutter/material.dart';

final class CustomColorScheme {
  CustomColorScheme._();

  // Light color scheme
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff191d17),
    surfaceTint: Color(0xff3f6836),
    onPrimary: Color(0xffffffff),
    primaryContainer: Color(0xffc0efb0),
    onPrimaryContainer: Color(0xff285021),
    secondary: Color(0xFF22FF22),
    onSecondary: Color(0xffffffff),
    secondaryContainer: Color(0xffd7e8cd),
    onSecondaryContainer: Color(0xff3c4b37),
    tertiary: Color.fromRGBO(61, 209, 61, 1),
    onTertiary: Color(0xffffffff),
    tertiaryContainer: Color(0xffbcebee),
    onTertiaryContainer: Color(0xff1e4d51),
    error: Color(0xffba1a1a),
    onError: Color(0xffffffff),
    errorContainer: Color(0xffffdad6),
    onErrorContainer: Color(0xff93000a),
    surface: Color(0xffffffff),
    onSurface: Color(0xff191d17),
    onSurfaceVariant: Color(0xff43483f),
    outline: Color(0xff73796e),
    outlineVariant: Color(0xffc3c8bc),
    shadow: Color.fromARGB(255, 86, 36, 36),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xff2e322b),
    inversePrimary: Color(0xffa5d396),
    primaryFixed: Color(0xffc0efb0),
    onPrimaryFixed: Color(0xff002200),
    primaryFixedDim: Color(0xffa5d396),
    onPrimaryFixedVariant: Color(0xff285021),
    secondaryFixed: Color(0xffd7e8cd),
    onSecondaryFixed: Color(0xff121f0e),
    secondaryFixedDim: Color.fromRGBO(238, 238, 238, 1),
    onSecondaryFixedVariant: Color(0xff3c4b37),
    tertiaryFixed: Color(0xffbcebee),
    onTertiaryFixed: Color(0xff002022),
    tertiaryFixedDim: Color(0xffa0cfd2),
    onTertiaryFixedVariant: Color(0xff1e4d51),
    surfaceDim: Color.fromARGB(255, 98, 98, 97),
    surfaceBright: Color(0xfff8fbf1),
    surfaceContainerLowest: Color(0xffffffff),
    surfaceContainerLow: Color(0xfff2f5eb),
    surfaceContainer: Color(0xffffffff),
    surfaceContainerHigh: Color(0xffe6e9e0),
    surfaceContainerHighest: Color(0xffe1e4da),
  );

  // Dark color scheme
  static const darkColorScheme = const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xffe1e4da),
    surfaceTint: Color(0xffa5d396),
    onPrimary: Color(0xff11380c),
    primaryContainer: Color(0xff285021),
    onPrimaryContainer: Color(0xffc0efb0),
    secondary: Color(0xFF22FF22),
    onSecondary: Color(0xff263422),
    secondaryContainer: Color(0xff3c4b37),
    onSecondaryContainer: Color(0xffd7e8cd),
    tertiary: Color(0xffa0cfd2),
    onTertiary: Color(0xff00373a),
    tertiaryContainer: Color(0xff1e4d51),
    onTertiaryContainer: Color(0xffbcebee),
    error: Color(0xffffb4ab),
    onError: Color(0xff690005),
    errorContainer: Color(0xff93000a),
    onErrorContainer: Color(0xffffdad6),
    surface: Color(0xff11140f),
    onSurface: Color(0xffe1e4da),
    onSurfaceVariant: Color(0xffc3c8bc),
    outline: Color(0xff8d9387),
    outlineVariant: Color(0xff43483f),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xffe1e4da),
    inversePrimary: Color(0xff3f6836),
    primaryFixed: Color(0xffc0efb0),
    onPrimaryFixed: Color(0xff002200),
    primaryFixedDim: Color(0xffa5d396),
    onPrimaryFixedVariant: Color(0xff285021),
    secondaryFixed: Color(0xffd7e8cd),
    onSecondaryFixed: Color(0xff121f0e),
    secondaryFixedDim: Color(0xffbbcbb2),
    onSecondaryFixedVariant: Color(0xff3c4b37),
    tertiaryFixed: Color(0xffbcebee),
    onTertiaryFixed: Color(0xff002022),
    tertiaryFixedDim: Color(0xffa0cfd2),
    onTertiaryFixedVariant: Color(0xff1e4d51),
    surfaceDim: Color(0xff11140f),
    surfaceBright: Color(0xff363a34),
    surfaceContainerLowest: Color(0xff0b0f0a),
    surfaceContainerLow: Color(0xff191d17),
    surfaceContainer: Color(0xff1d211b),
    surfaceContainerHigh: Color(0xff272b25),
    surfaceContainerHighest: Color(0xff32362f),
  );
}
