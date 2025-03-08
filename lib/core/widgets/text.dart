import 'package:flutter/material.dart';

Text customText(
  String text,
  BuildContext context, {
  Color? color,
  double? size, // Sadece width değeri kullanıldığı için height'a gerek yok
  FontWeight weight = FontWeight.normal,
}) {
  final effectiveColor = color ?? Theme.of(context).colorScheme.primary;
  return Text(
    text,
    style: TextStyle(
      color: effectiveColor,
      fontSize: size ?? Theme.of(context).textTheme.bodyMedium!.fontSize,
      fontWeight: weight,
    ),
  );
}
