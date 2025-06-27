import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imecehub/core/widgets/container.dart';
import 'package:imecehub/core/widgets/productsCard2.dart';
import 'package:imecehub/core/widgets/shadow.dart';
import 'package:imecehub/core/widgets/showTemporarySnackBar.dart';
import 'package:imecehub/core/widgets/text.dart';
import 'package:imecehub/core/widgets/textField.dart';
import 'package:imecehub/models/companies.dart';
import 'package:imecehub/models/productCategories.dart';
import 'package:imecehub/models/products.dart';
import 'package:imecehub/screens/home/home_screen_mixin.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';
import 'package:imecehub/screens/products/products_screen.dart';
import 'package:imecehub/screens/profil/profile_screen.dart';
import 'package:imecehub/screens/shoppingCart/cart_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/api_service.dart';

part 'widget/home_view_header.dart';
part 'widget/home_view_bottom.dart';
part 'widget/home_view_body.dart';

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with HomeScreenMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Consumer(
          builder: (context, ref, _) {
            final selectedIndex = ref.watch(bottomNavIndexProvider);
            Widget body;
            switch (selectedIndex) {
              case 0:
                body = _HomeViewBody();
                break;
              case 1:
                body = Center(child: ProductsScreen());
                break;
              case 2:
                body = OrderScreen();
                break;
              default:
                body = ProfileScreen();
            }
            return body;
          },
        ),
        _HomeBottomNavigationBarTest(),
      ]),
      //bottomNavigationBar: _HomeBottomNavigationBar(), // Bottom NavigationBar yerine body'nin en altına taşındı
    );
  }
}

extension _HomeStyleExtension on BuildContext {
  HomeStyle get homeStyle => HomeStyle(context: this);
}
