import 'package:flutter/widgets.dart';

class AppPaddings {
  AppPaddings._();

  static const EdgeInsets all8 = EdgeInsets.all(8);
  static const EdgeInsets all10 = EdgeInsets.all(10);
  static const EdgeInsets all12 = EdgeInsets.all(12);
  static const EdgeInsets all16 = EdgeInsets.all(16);
  static const EdgeInsets all20 = EdgeInsets.all(20);
  static const EdgeInsets all24 = EdgeInsets.all(24);
  static const EdgeInsets all32 = EdgeInsets.all(32);

  static const EdgeInsets h10 = EdgeInsets.symmetric(horizontal: 10);
  static const EdgeInsets h12 = EdgeInsets.symmetric(horizontal: 12);
  static const EdgeInsets h16 = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets h20 = EdgeInsets.symmetric(horizontal: 20);

  static const EdgeInsets v4 = EdgeInsets.symmetric(vertical: 4);
  static const EdgeInsets v12 = EdgeInsets.symmetric(vertical: 12);
  static const EdgeInsets v16 = EdgeInsets.symmetric(vertical: 16);
  static const EdgeInsets v20 = EdgeInsets.symmetric(vertical: 20);

  static const EdgeInsets t5 = EdgeInsets.only(top: 5);
  static const EdgeInsets t10 = EdgeInsets.only(top: 10);

  static const EdgeInsets l10 = EdgeInsets.only(left: 10);

  static const EdgeInsets textFormFieldPadding = EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 16,
  );
  static const EdgeInsets navBarItemPadding = EdgeInsets.symmetric(
    vertical: 12,
    horizontal: 16,
  );
}
