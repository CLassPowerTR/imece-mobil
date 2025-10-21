import 'package:flutter/material.dart';
import 'package:imecehub/core/constants/app_radius.dart';
import 'package:shimmer/shimmer.dart';

class SellersShimmer extends StatelessWidget {
  const SellersShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.14,
        decoration: BoxDecoration(
          color: Colors.grey[300]!,
          borderRadius: AppRadius.r12,
        ),
      ),
    );
  }
}
