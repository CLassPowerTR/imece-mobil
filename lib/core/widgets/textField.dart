import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';
import 'package:imecehub/core/theme/design_tokens.dart';

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
      color: HomeStyle(context: context).primary,
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
              HomeStyle(context: context).outline.withOpacity(0.5)),
      labelText: labelText,
      contentPadding: contentPadding, // Dikey dolgu
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: HomeStyle(context: context).secondary,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: HomeStyle(context: context).secondary,
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
              HomeStyle(context: context).outline.withOpacity(0.5)),
      hintText: hintText, // Hint metni
      border: OutlineInputBorder(
        borderRadius:
            borderRadius ?? BorderRadius.circular(8.0), // Kenar yumuşaklığı
        borderSide: BorderSide(
          color: borderColor ??
              HomeStyle(context: context).secondary, // Kenar çizgisinin rengi
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
      hintStyle: TextStyle(color: HomeStyle(context: context).outline),
      prefixIcon: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SvgPicture.asset(
          'assets/vectors/search.svg',
          // İkonun rengini de tercihinize göre belirleyebilirsiniz:
          color: HomeStyle(context: context).secondary,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: HomeStyle(context: context).secondary,
        ),
        borderRadius: HomeStyle(context: context).appBarTextFieldBorderRadius,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: HomeStyle(context: context).secondary,
        ),
        borderRadius: HomeStyle(context: context).appBarTextFieldBorderRadius,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
  );
}

Widget homeTextFieldBar(BuildContext context) {
  return SizedBox(
    height: 45,
    child: TextField(
      style: const TextStyle(color: DesignTokens.textSecondary),
      decoration: InputDecoration(
        filled: true,
        fillColor: DesignTokens.textSecondary.withOpacity(0.08),
        hintText: 'Ürün, Kategori veya marka ara...',
        hintStyle: const TextStyle(
          color: DesignTokens.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(14.0),
          child: SvgPicture.asset(
            'assets/vectors/search.svg',
            width: 16,
            height: 16,
            color: HomeStyle(context: context).primary,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: HomeStyle(context: context).appBarTextFieldBorderRadius,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: HomeStyle(context: context).primary,
            width: 1.0,
          ),
          borderRadius: HomeStyle(context: context).appBarTextFieldBorderRadius,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      ),
    ),
  );
}
