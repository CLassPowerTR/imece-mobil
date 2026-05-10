import 'package:flutter/material.dart';
import 'package:imecehub/core/constants/app_colors.dart';
import 'package:imecehub/core/constants/app_radius.dart';
import 'package:imecehub/core/constants/app_textSizes.dart';
import 'package:imecehub/core/widgets/richText.dart';

SizedBox textButton(
  BuildContext context,
  String title, {
  Color? buttonColor,
  Color? titleColor,
  double? fontSize,
  double? minSizeWidth,
  double? minSizeHeight,
  FontWeight weight = FontWeight.w400,
  double? elevation,
  Color? shadowColor,
  BorderRadiusGeometry? borderRadius,
  Function()? onPressed,
  bool border = false,
  double? borderWidth,
  Color? borderColor,
  EdgeInsets? padding,
  Widget? icon,
  AlignmentGeometry? textAlignment,
}) {
  final effectiveButtonColor =
      buttonColor ?? AppColors.secondary(context);
  final effectiveTextColor =
      titleColor ?? AppColors.onSecondary(context);
  final effectiveMinSizeWidth =
      minSizeWidth ?? MediaQuery.of(context).size.width;
  final effectiveMinSizeHeight = minSizeHeight ?? 50;
  final effectiveFontSize =
      fontSize ??   AppTextSizes.bodyLarge(context);
  BorderSide? test = border == true
      ? BorderSide(
          color: borderColor ?? AppColors.outline(context),
          width: borderWidth ?? 0,
        )
      : null;
  return SizedBox(
    width: effectiveMinSizeWidth,
    height: effectiveMinSizeHeight,
    child: Material(
      elevation: elevation ?? 2, // Gölgeleme seviyesi
      shadowColor:
          shadowColor ??
          AppColors.shadow(context).withOpacity(0.5), // Gölgenin rengi ve opaklığı
      borderRadius: borderRadius ?? BorderRadius.circular(8.0),
      child: TextButton(
        onPressed: onPressed,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: richText(
            context,
            color: effectiveTextColor,
            fontSize: fontSize,
            fontWeight: weight,
            children: [
              TextSpan(text: title),
              WidgetSpan(
                //alignment: PlaceholderAlignment.,
                child: Builder(
                  builder: (context) {
                    if (icon != null) {
                      return icon;
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        style: ButtonStyle(
          alignment: textAlignment,
          side: WidgetStateProperty.all<BorderSide?>(test),
          padding: WidgetStateProperty.all<EdgeInsets>(
            padding ?? EdgeInsets.zero,
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: borderRadius ?? AppRadius.r8),
          ),
          minimumSize: WidgetStateProperty.all<Size?>(
            Size(effectiveMinSizeWidth, effectiveMinSizeHeight),
          ),
          backgroundColor: WidgetStateProperty.all<Color>(effectiveButtonColor),
        ),
      ),
    ),
  );
}
