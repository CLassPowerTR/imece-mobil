import 'package:flutter/material.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';

IconButton AppCloseButton(
  BuildContext context, {
  VoidCallback? onPressed,
  double size = 30,
  Color? color,
  String? tooltip,
  EdgeInsetsGeometry? padding,
  BoxConstraints? constraints,
}) {
  final theme = HomeStyle(context: context);
  return IconButton(
    onPressed: onPressed ?? () => Navigator.maybePop(context),
    tooltip: tooltip ?? 'Kapat',
    padding: padding ?? EdgeInsets.zero,
    constraints:
        constraints ?? const BoxConstraints.tightFor(width: 36, height: 36),
    splashRadius: 18,
    icon: Icon(
      Icons.close_outlined,
      size: size,
      color: color ?? theme.primary,
    ),
  );
}
