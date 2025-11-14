import 'package:flutter/material.dart';
import 'package:imecehub/core/constants/app_paddings.dart';
import 'package:imecehub/core/constants/app_radius.dart';
import 'package:shimmer/shimmer.dart';

class CampaignsStoriesShimmer extends StatelessWidget {
  final String title;
  final String subtitle;
  final double height;
  const CampaignsStoriesShimmer({
    super.key,
    this.title = 'Satıcı',
    this.subtitle = 'Kampanya',
    this.height = 160,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SizedBox(
        height: height,
        child: ListView.separated(
          padding: AppPaddings.all12,
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          separatorBuilder: (_, __) => SizedBox(width: 12),
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue.shade100, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.grey[200],
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  width: 60,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: AppRadius.r8,
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  width: 40,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: AppRadius.r8,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
