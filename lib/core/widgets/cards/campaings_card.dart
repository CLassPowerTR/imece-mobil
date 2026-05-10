import 'package:flutter/material.dart';
import 'package:imecehub/api/api_config.dart';
import 'package:imecehub/core/constants/app_colors.dart';
import 'package:imecehub/core/constants/app_paddings.dart';
import 'package:imecehub/core/constants/app_radius.dart';
import 'package:imecehub/core/constants/app_textSizes.dart';
import 'package:imecehub/core/variables/url.dart';
import 'package:imecehub/core/widgets/showTemporarySnackBar.dart';
import 'package:imecehub/core/widgets/text.dart';
import 'package:imecehub/models/campaigns.dart';

class CampaingsCard extends StatelessWidget {
  final Campaign item;
  final double width;
  final double height;
  const CampaingsCard({
    super.key,
    required this.item,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final double containerWidth = width * 0.95;
    final String title = item.title;
    final String banner = '${ApiConfig().baseUrl}${item.banner}';

    return Container(
      width: containerWidth,
      padding: AppPaddings.all16,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            item.banner.isEmpty ? NotFound.defaultBannerImageUrl : banner,
          ),

          fit: BoxFit.cover,
        ),
        borderRadius: AppRadius.r12,
      ),  
      child: SingleChildScrollView(
        child: Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: AppPaddings.all8,
              decoration: BoxDecoration(
                borderRadius: AppRadius.r24,
                color: AppColors.primary(context).withOpacity(0.3),
                border: BoxBorder.all(
                  color: AppColors.onPrimary(context).withOpacity(0.3),
                ),
              ),
              child: customText(
                "Kampanya",
                context,
                color: AppColors.onPrimary(context),
                weight: FontWeight.bold,
                size: AppTextSizes.bodySmall(context),
              ),
            ),
            customText(
              title,
              context,
              color: AppColors.secondary(context),
              weight: FontWeight.bold,
              size: AppTextSizes.headlineSmall(context),
              maxLines: 1,
            ),
            customText(
              item.subtitle,
              context,
              color: AppColors.onPrimary(context),
              weight: FontWeight.bold,
              size: AppTextSizes.bodyMedium(context),
              maxLines: 1,
            ),
            customText(
              item.description,
              context,
              color: Colors.grey[400],
              weight: FontWeight.bold,
              size: AppTextSizes.bodySmall(context),
              maxLines: 1,
            ),
            Container(
              padding: AppPaddings.all8,
              decoration: BoxDecoration(
                borderRadius: AppRadius.r12,
                color: AppColors.primary(context).withOpacity(0.7),
                border: BoxBorder.all(
                  color: AppColors.onPrimary(context).withOpacity(0.7),
                ),
              ),
              child: customText(
                item.campaignType,
                context,
                color: AppColors.onPrimary(context),
                size: AppTextSizes.labelSmall(context),
                maxLines: 1,
              ),
            ),
            TextButton.icon(
              iconAlignment: IconAlignment.end,
              style: ButtonStyle(
                padding: WidgetStateProperty.all<EdgeInsets>(AppPaddings.all8),
                backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(borderRadius: AppRadius.r18),
                ),
              ),
              icon: Icon(
                Icons.arrow_forward,
                color: AppColors.onPrimary(context),
              ),
              onPressed: () {
                showTemporarySnackBar(
                  context,
                  "${item.id} Kampanya detayına git",
                  type: SnackBarType.info,
                );
              },
              label: customText(
                "Detayları Gör",
                context,
                color: AppColors.onPrimary(context),
                size: AppTextSizes.labelSmall(context),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
