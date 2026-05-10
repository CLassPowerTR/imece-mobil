import 'package:imecehub/core/constants/app_textStyle.dart';
import 'package:imecehub/core/constants/app_radius.dart';
import 'package:imecehub/core/constants/app_paddings.dart';
import 'package:flutter/material.dart';
import 'package:imecehub/core/constants/app_colors.dart';
import 'package:imecehub/core/widgets/text.dart';
// Eğer customText ve HomeStyle başka bir dosyadaysa, ilgili importları ekleyin.
// import 'package:imece_mobil/core/widgets/customText.dart';
// import 'package:imece_mobil/core/widgets/home_style.dart';

class TurnBackTextIcon extends StatelessWidget {
  const TurnBackTextIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        minimumSize: const Size(0, kToolbarHeight),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(
        Icons.arrow_back,
        size: 20,
        color: AppColors.secondary(context),
      ),
      label: customText(
        'Geri Dön',
        context,
        weight: FontWeight.w600,
        color: AppColors.secondary(context),
        size: 14,
      ),
    );
  }
}
