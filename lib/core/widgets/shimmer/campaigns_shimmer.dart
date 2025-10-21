import 'package:flutter/material.dart';
import 'package:imecehub/core/constants/app_radius.dart';
import 'package:shimmer/shimmer.dart';

class CampaignsShimmer extends StatelessWidget {
  final double height;
  const CampaignsShimmer({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[300]!,
          borderRadius: AppRadius.r12,
        ),
      ),
    );
  }
}
