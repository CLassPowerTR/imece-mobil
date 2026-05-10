import 'package:flutter/material.dart';
import 'package:imecehub/core/constants/app_colors.dart';
import 'package:imecehub/core/constants/app_textSizes.dart';
import 'package:imecehub/core/widgets/container.dart';
import 'package:imecehub/core/widgets/text.dart';

Container gonderiContainer(
  BuildContext context,
  String gonderiBaslik,
  String gonderiAciklama,
  List gonderiImages,
  String profilImage,
  String profilName,
) {
  return container(context,
      border: Border.all(
          color: AppColors.outline(context).withOpacity(0.2)),
      isBoxShadow: false,
      borderRadius: BorderRadius.circular(8),
      padding: EdgeInsets.all(5),
      color: AppColors.surfaceContainer(context),
      margin: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          _profilResimveAdi(context, profilImage, profilName),
          _gonderiResmi(gonderiImages),
          customText(gonderiBaslik, context,
              size: AppTextSizes.bodyMedium(context), weight: FontWeight.w700),
          customText(gonderiAciklama, context)
        ],
      ));
}

Row _profilResimveAdi(BuildContext context,
    String profilImage, String profilName) {
  return Row(
    spacing: 10,
    children: [
      CircleAvatar(
        backgroundImage: NetworkImage(profilImage),
      ),
      customText('${profilName}', context,
          weight: FontWeight.w400, size:  AppTextSizes.bodyMedium(context))
    ],
  );
}

SizedBox _gonderiResmi(List gonderiImages) {
  return SizedBox(
    height: 225,
    child: Expanded(
      child: PageView.builder(
        itemCount: gonderiImages.length,
        itemBuilder: (context, imgIndex) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    onError: (exception, stackTrace) {
                      Placeholder();
                    },
                    image: NetworkImage(gonderiImages[imgIndex]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Görselin alt sağ köşesinde kaçıncı görsel olduğunu gösteren etiket
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  alignment: Alignment.center,
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: AppColors.outline(context),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${imgIndex + 1}/${gonderiImages.length}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}
