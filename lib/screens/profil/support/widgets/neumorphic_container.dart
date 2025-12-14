// lib/screens/profil/support/widgets/neumorphic_container.dart

import 'package:flutter/material.dart';

class NeumorphicContainer extends StatelessWidget {
  final Widget child;
  final bool isPressed;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;

  const NeumorphicContainer({
    Key? key,
    required this.child,
    this.isPressed = false,
    this.borderRadius = 20.0,
    this.padding,
    this.margin,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? const Color(0xFFE0E5EC);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: isPressed
            ? [
                // Intruded/Pressed style (inner shadow effect)
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(3, 3),
                  blurRadius: 6,
                  spreadRadius: -2,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.7),
                  offset: const Offset(-3, -3),
                  blurRadius: 6,
                  spreadRadius: -2,
                ),
              ]
            : [
                // Extruded style (raised/embossed)
                BoxShadow(
                  color: Colors.white.withOpacity(0.9),
                  offset: const Offset(-6, -6),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  offset: const Offset(6, 6),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ],
      ),
      padding: padding,
      child: child,
    );
  }
}

class NeumorphicButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Gradient? gradient;

  const NeumorphicButton({
    Key? key,
    required this.child,
    this.onPressed,
    this.borderRadius = 20.0,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.gradient,
  }) : super(key: key);

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: widget.margin,
        padding:
            widget.padding ??
            const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: widget.gradient == null
              ? (widget.backgroundColor ?? const Color(0xFFE0E5EC))
              : null,
          gradient: widget.gradient,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: _isPressed
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.9),
                    offset: const Offset(-4, -4),
                    blurRadius: 8,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    offset: const Offset(4, 4),
                    blurRadius: 8,
                  ),
                ],
        ),
        child: widget.child,
      ),
    );
  }
}
