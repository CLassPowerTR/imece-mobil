import 'package:imecehub/core/constants/app_textStyle.dart';
import 'package:imecehub/core/constants/app_radius.dart';
import 'package:imecehub/core/constants/app_paddings.dart';
import 'package:imecehub/core/constants/app_colors.dart';
import 'package:flutter/material.dart';


BoxShadow boxShadow(
  BuildContext context, {
  Color? color,
  Offset? offset,
  double? blurRadius,
  double? withOpacity,
}) {
  return BoxShadow(
    color: color ??
        AppColors.shadow(context)
            .withOpacity(withOpacity ?? 0.3), // Gölgenin rengi ve opaklığı
    offset: offset ?? Offset(0, 2), // Yalnızca alt yönde 4 piksel kaydırma
    blurRadius: blurRadius ?? 6, // Bulanıklık değeri
  );
}
