import 'package:flutter/material.dart';
import 'package:imecehub/core/constants/app_paddings.dart';
import 'package:imecehub/core/constants/app_radius.dart';
import 'package:imecehub/core/widgets/container.dart';
import 'package:imecehub/core/widgets/raitingStars.dart';
import 'package:imecehub/core/widgets/text.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';

Container yorumContainer(BuildContext context, HomeStyle themeData,
    double width, Map<dynamic, dynamic> yorum) {
  double containerWidth = width * 0.7;
  return container(
    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
    context,
    borderRadius: BorderRadius.circular(8),
    color: themeData.surfaceContainer,
    width: containerWidth,
    padding: EdgeInsets.all(10),
    child: Column(
      spacing: 10,
      children: [
        Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 2,
              child: Row(
                spacing: 5,
                children: [
                  //CircleAvatar(),
                  Expanded(
                    child: customText(yorum['yorumName'] ?? 'User', context,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        weight: FontWeight.w400,
                        size: themeData.bodyMedium.fontSize),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: container(
                context,
                padding: AppPaddings.all6,
                isBoxShadow: true,
                borderRadius: AppRadius.r8,
                color: themeData.surfaceContainer,
                child:
                    Row(spacing: 5, mainAxisSize: MainAxisSize.min, children: [
                  customText(yorum['rating'].toString(), context),
                  buildRatingStars(yorum['rating'])
                ]),
              ),
            )
          ],
        ),
        Flexible(
            child: customText('${yorum['yorum']}', context,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                size: themeData.bodySmall.fontSize,
                color: themeData.primary.withOpacity(0.6))),
        Builder(builder: (context) {
          final List<dynamic> imagesDyn = (yorum['resimler'] as List?) ?? [];
          final List<String> images = imagesDyn
              .where((e) => e != null)
              .map((e) => e.toString())
              .where((e) => e.isNotEmpty)
              .toList();
          if (images.isEmpty) return SizedBox.shrink();
          final double thumb = 56;
          return SizedBox(
            height: thumb,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(top: 4),
              itemBuilder: (context, index) {
                final url = images[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    url,
                    width: thumb,
                    height: thumb,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: thumb,
                      height: thumb,
                      color: themeData.outline.withOpacity(0.1),
                      alignment: Alignment.center,
                      child: Icon(Icons.broken_image,
                          size: 20, color: themeData.outline),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => SizedBox(width: 8),
              itemCount: images.length,
            ),
          );
        })
      ],
    ),
  );
}
