import 'package:imecehub/screens/profil/sellerProfil/seller_profil_screen_library.dart';

Expanded groupBuyButton(
  BuildContext context, {
  VoidCallback? onPressed,
  double size = 30,
  Color? color,
  String? tooltip,
  EdgeInsetsGeometry? padding,
  BoxConstraints? constraints,
  double? elevation,
}) {
  final width = MediaQuery.of(context).size.width;
  final isSmallScreen = width < 360;
  final theme = HomeStyle(context: context);
  return Expanded(
    child: textButton(
      context,
      'Grup Alım',
      buttonColor: Colors.orange,

      elevation: elevation ?? 4,
      onPressed: onPressed,
      weight: FontWeight.bold,
      fontSize: HomeStyle(context: context).bodySmall.fontSize,
    ),
  );
}
