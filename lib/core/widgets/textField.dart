import 'package:imecehub/core/constants/app_textStyle.dart';
import 'package:imecehub/core/constants/app_radius.dart';
import 'package:imecehub/core/constants/app_paddings.dart';
import 'package:imecehub/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';



TextField textField(
  BuildContext context, {
  String? hintText,
  Color? hintTextColor,
  BorderRadius? borderRadius,
  Color? borderColor,
  String? errorText,
  Color? errorColor,
  TextInputType? keyboardType,
  TextEditingController? controller,
  bool obscureText = false,
  bool showSuffixIcon = false,
  VoidCallback? onTap,
  int? minLines,
  int? maxLines,
  EdgeInsetsGeometry? contentPadding,
  String? labelText,
  Color? labelTextColor,
  bool readOnly = false,
  bool expands = false, // Yeni parametre ekledik.
  TextAlignVertical? textAlignVertical,
  List<TextInputFormatter>? inputFormatters,
  FocusNode? focusNode,
  TextInputAction? textInputAction,
  void Function(String)? onFieldSubmitted,
}) {
  // Eğer şifre alanı ise, minLines ve maxLines 1 olmalı
  final effectiveMinLines = obscureText ? 1 : (expands ? null : minLines);
  final effectiveMaxLines = obscureText ? 1 : (expands ? null : maxLines);

  return TextField(
    readOnly: readOnly,
    controller: controller,
    obscureText: obscureText,
    inputFormatters: inputFormatters,
    minLines: effectiveMinLines,
    maxLines: effectiveMaxLines,
    expands: expands, // Bu alanı doldurmasını sağlar.
    textAlignVertical: TextAlignVertical.top, // Metin üstte hizalanır
    style: TextStyle(
      color: AppColors.primary(context),
    ),
    keyboardType:
        keyboardType ?? TextInputType.emailAddress, // Klavye tipi e-posta için
    focusNode: focusNode,
    textInputAction: textInputAction,
    onSubmitted: onFieldSubmitted,
    decoration: InputDecoration(
      alignLabelWithHint: true,
      isDense: true,
      errorText: errorText,
      labelStyle: TextStyle(
          color: labelTextColor ??
              AppColors.outline(context).withOpacity(0.5)),
      labelText: labelText,
      contentPadding: contentPadding, // Dikey dolgu
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.secondary(context),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.secondary(context),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: errorColor ?? Colors.red,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: errorColor ?? Colors.red,
        ),
      ),
      suffixIcon: showSuffixIcon
          ? IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: onTap,
            )
          : null,
      hintStyle: TextStyle(
          color: hintTextColor ??
              AppColors.outline(context).withOpacity(0.5)),
      hintText: hintText, // Hint metni
      border: OutlineInputBorder(
        borderRadius:
            borderRadius ?? BorderRadius.circular(8.0), // Kenar yumuşaklığı
        borderSide: BorderSide(
          color: borderColor ??
              AppColors.secondary(context), // Kenar çizgisinin rengi
        ),
      ),
    ),
  );
}

TextField profilTextField(
  BuildContext context, {
  String? hintText,
  TextEditingController? controller,
}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: AppColors.outline(context)),
      prefixIcon: Padding(
        padding: EdgeInsets.all(12.0),
        child: SvgPicture.asset(
          'assets/vectors/search.svg',
          // İkonun rengini de tercihinize göre belirleyebilirsiniz:
          color: AppColors.secondary(context),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.secondary(context),
        ),
        borderRadius: AppRadius.r26,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.secondary(context),
        ),
        borderRadius: AppRadius.r26,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
  );
}

Widget homeTextFieldBar(BuildContext context) {
  return SizedBox(
    height: 45,
    child: TextField(
      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.08),
        hintText: 'Ürün, Kategori veya marka ara...',
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.all(14.0),
          child: SvgPicture.asset(
            'assets/vectors/search.svg',
            width: 16,
            height: 16,
            color: AppColors.primary(context),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: AppRadius.r26,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primary(context),
            width: 1.0,
          ),
          borderRadius: AppRadius.r26,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      ),
    ),
  );
}
