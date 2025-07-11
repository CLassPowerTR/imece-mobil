import 'package:flutter/material.dart';

Widget buildLoadingBar(BuildContext context) {
  final secondary = Theme.of(context).colorScheme.secondary;
  final surface = Theme.of(context).colorScheme.surface;
  final outline = Theme.of(context).colorScheme.outline;

  return SizedBox(
    height: 6,
    child: TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
      onEnd: () {},
      builder: (context, value, child) {
        final gradient = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color.lerp(secondary, surface, value)!,
            Color.lerp(surface, outline, value)!,
            Color.lerp(outline, secondary, value)!,
          ],
        );
        return FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: value,
          child: Container(
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      },
    ),
  );
}
