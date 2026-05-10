part of '../profile_screen.dart';

AppBar _SignUpAppBar(BuildContext context) {
  return AppBar(
    leadingWidth: 30,
    title: customText('Geri', context,
        color: AppColors.secondary(context),
        size: 20,
        weight: FontWeight.bold),
    iconTheme: IconThemeData(
      applyTextScaling: true,
      size: 30,
      color: AppColors.secondary(context), // Geri butonunun rengi kırmız
    ),
    backgroundColor: Colors.transparent,
  );
}
