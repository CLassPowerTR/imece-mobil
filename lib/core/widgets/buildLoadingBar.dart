import 'package:flutter/material.dart';
import 'package:imecehub/core/constants/app_radius.dart';

Widget buildLoadingBar(BuildContext context) {
  return const _CenteredPulseLoadingBar();
}

class _CenteredPulseLoadingBar extends StatefulWidget {
  const _CenteredPulseLoadingBar({super.key});

  @override
  State<_CenteredPulseLoadingBar> createState() =>
      _CenteredPulseLoadingBarState();
}

class _CenteredPulseLoadingBarState extends State<_CenteredPulseLoadingBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).colorScheme.secondary;
    final surface = Theme.of(context).colorScheme.surface;
    final outline = Theme.of(context).colorScheme.outline;

    return SizedBox(
      height: 6,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          final double t = _animation.value; // 0 -> 1 -> 0 (loop)
          final gradient = LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color.lerp(secondary, surface, t)!,
              Color.lerp(surface, outline, t)!,
              Color.lerp(outline, secondary, t)!,
            ],
          );
          return Align(
            alignment: Alignment.center,
            child: FractionallySizedBox(
              widthFactor: t,
              child: Container(
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: AppRadius.r3,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
