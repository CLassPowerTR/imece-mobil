import 'package:imecehub/core/constants/app_textStyle.dart';
import 'package:imecehub/core/constants/app_radius.dart';
import 'package:imecehub/core/constants/app_paddings.dart';
import 'package:imecehub/core/constants/app_colors.dart';
import 'package:flutter/widgets.dart';


RichText richText(BuildContext context,
    {List<InlineSpan>? children,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    int? maxLines,
    TextOverflow overflow = TextOverflow.ellipsis,
    TextAlign textAlign = TextAlign.center}) {
  return RichText(
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
      
      text: TextSpan(
          style: TextStyle(
              color: color ?? AppColors.primary(context),
              fontSize:
                  fontSize ?? AppTextStyle.bodyLarge(context).fontSize,
              fontWeight: fontWeight),
          children: children));
}
