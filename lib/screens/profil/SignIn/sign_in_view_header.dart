part of 'sign_in_screen.dart';

AppBar SignInAppBar(BuildContext context) {
  return AppBar(
    leadingWidth: 30,
    title: customText('Geri', context,
        color: AppColors.primary(context),
        size: 20,
        weight: FontWeight.bold),
    iconTheme: IconThemeData(
        applyTextScaling: true,
        size: 30,
        color: AppColors.primary(context)), // Geri butonunun rengi kırmız
    backgroundColor: Colors.transparent,
  );
}
