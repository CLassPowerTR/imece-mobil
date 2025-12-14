part of '../products_detail_screen.dart';

AppBar _productsDetailAppBar(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  final isSmallScreen = width < 360;
  
  return AppBar(
    toolbarHeight: isSmallScreen ? 60 : 80,
    title: Padding(
      padding: EdgeInsets.only(top: isSmallScreen ? 5 : 10),
      child: SizedBox(
        height: isSmallScreen ? 38 : 42,
        child: homeTextFieldBar(context),
      ),
    ),
    actions: [
      Padding(
        padding: EdgeInsets.only(top: isSmallScreen ? 5 : 10, right: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            shopIconButton(context),
            SizedBox(width: isSmallScreen ? 2 : 4),
            settingsIconButton(context),
          ],
        ),
      ),
    ],
  );
}
