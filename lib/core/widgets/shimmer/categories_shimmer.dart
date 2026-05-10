import 'package:flutter/material.dart';
import 'package:imecehub/core/constants/app_colors.dart';
import 'package:imecehub/core/constants/app_textSizes.dart';
import 'package:imecehub/core/widgets/text.dart';
import 'package:shimmer/shimmer.dart';

class CategoriesShimmer extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final int crossAxisCount;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final int itemCount;

  const CategoriesShimmer({
    super.key,
    required this.padding,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
    this.crossAxisSpacing = 12,
    this.mainAxisSpacing = 12,
    this.itemCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _categoriesText(context),
          GridView.builder(
            scrollDirection: Axis.vertical,
            padding: padding,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              crossAxisSpacing: crossAxisSpacing,
              mainAxisSpacing: mainAxisSpacing,
            ),
            itemCount: itemCount,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300]!,
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

Padding _categoriesText(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: customText(
      'Kategoriler',
      context,
      size: AppTextSizes.bodyLarge(context),
      weight: FontWeight.bold,
      color: AppColors.primary(context),
    ),
  );
}
