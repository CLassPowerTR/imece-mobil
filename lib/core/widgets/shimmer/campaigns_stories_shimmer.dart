import 'package:flutter/material.dart';
import 'package:imecehub/core/constants/app_colors.dart';
import 'package:imecehub/core/constants/app_paddings.dart';
import 'package:imecehub/core/constants/app_radius.dart';
import 'package:imecehub/core/widgets/text.dart';
import 'package:shimmer/shimmer.dart';

class CampaignsStoriesShimmer extends StatelessWidget {
  String? title;
  String? subtitle;
  CampaignsStoriesShimmer({super.key, this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.separated(
        padding: AppPaddings.all12,
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        separatorBuilder: (_, __) => SizedBox(width: 12),
        itemBuilder: (context, index) {
          return SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue, width: 2),
                  ),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://www.imecehub.com/images/story/20250920002140.jpg',
                    ),
                    radius: 36,
                  ),
                ),

                SizedBox(height: 8),
                customText(
                  title ?? 'Satıcı',
                  context,
                  color: AppColors.primary(context),
                  weight: FontWeight.bold,
                  maxLines: 1,
                ),
                customText(
                  subtitle ?? 'Kampanya',
                  context,
                  color: AppColors.outline(context),
                  maxLines: 1,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
