import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductsGridShimmer extends StatelessWidget {
  final double? childAspectRatio;
  final EdgeInsetsGeometry? padding;
  final int itemCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  const ProductsGridShimmer({
    super.key,
    this.childAspectRatio = 0.68,
    this.padding = const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    this.itemCount = 10,
    this.crossAxisSpacing = 12,
    this.mainAxisSpacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        padding: padding!,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: childAspectRatio!,
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
    );
  }
}
