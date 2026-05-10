import 'package:flutter/material.dart';
import 'package:imecehub/core/constants/app_colors.dart';
import 'package:imecehub/core/constants/app_textSizes.dart';
import 'package:imecehub/core/widgets/text.dart';
import 'package:imecehub/core/widgets/buttons/textButton.dart';
import 'package:imecehub/models/users.dart';

Widget FollowsCard(
    BuildContext context, User user, int saticiId, VoidCallback onTapProfile) {
  return Card(
    color: AppColors.surface(context),
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 5,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: (user.saticiProfili != null &&
                    user.saticiProfili!.profilBanner != null)
                ? NetworkImage(user.saticiProfili!.profilBanner!)
                : const AssetImage('assets/icon/ic_profilDuzenle.png')
                    as ImageProvider,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              customText(
                (user.saticiProfili?.magazaAdi?.isNotEmpty ?? false)
                    ? user.saticiProfili?.magazaAdi ?? ''
                    : user.username ?? '',
                context,
                weight: FontWeight.bold,
              ),
              Builder(builder: (context) {
                if (user.saticiProfili!.degerlendirmePuani != null) {
                  return Container(
                    padding: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: (double.tryParse(user
                                      .saticiProfili!.degerlendirmePuani!) ??
                                  0.0) >=
                              8.0
                          ? Colors.green
                          : Colors.red,
                    ),
                    child: customText(
                        user.saticiProfili!.degerlendirmePuani.toString(),
                        context,
                        color: AppColors.onSecondary(context)),
                  );
                } else {
                  return SizedBox();
                }
              }),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 5,
            children: [
              Expanded(
                child: textButton(context, 'Profil',
                    onPressed: onTapProfile, elevation: 0),
              ),
              Expanded(
                child: textButton(context, 'Takipten Çık',
                    elevation: 0, buttonColor: Colors.orangeAccent),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
