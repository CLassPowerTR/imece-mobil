import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imecehub/core/variables/url.dart';
import 'package:imecehub/core/widgets/container.dart';
import 'package:imecehub/core/widgets/cards/productsCard2.dart';
import 'package:imecehub/core/widgets/cards/campaings_card.dart';
import 'package:imecehub/core/widgets/shadow.dart';
import 'package:imecehub/core/widgets/shimmer/products_shimmer.dart';
import 'package:imecehub/core/widgets/shimmer/sellers_shimmer.dart';
import 'package:imecehub/core/widgets/showTemporarySnackBar.dart';
import 'package:imecehub/core/widgets/cards/story_campaings_card.dart';
import 'package:imecehub/core/widgets/text.dart';
import 'package:imecehub/core/widgets/textField.dart';
import 'package:imecehub/models/companies.dart';
import 'package:imecehub/models/productCategories.dart';
import 'package:imecehub/models/products.dart';
import 'package:imecehub/models/campaigns.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';
import 'package:imecehub/screens/products/products_screen.dart';
import 'package:imecehub/screens/profil/profile_screen.dart';
import 'package:imecehub/screens/shoppingCart/cart_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:imecehub/core/widgets/shimmer/categories_shimmer.dart';
import 'package:imecehub/core/widgets/shimmer/campaigns_shimmer.dart';
import 'package:imecehub/providers/auth_provider.dart';

import '../../services/api_service.dart';

part 'widget/home_view_header.dart';
part 'widget/home_view_bottom.dart';
part 'widget/home_view_body.dart';

final bottomNavIndexProvider = NotifierProvider<BottomNavIndex, int>(
  BottomNavIndex.new,
);

class BottomNavIndex extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) => state = index;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Consumer(
            builder: (context, ref, _) {
              final user = ref.watch(userProvider);
              final bool isSeller = user?.rol == 'satici';

              final screens = <Widget>[
                _HomeViewBody(),
                Center(child: ProductsScreen()),
                if (!isSeller) OrderScreen(),
                ProfileScreen(),
              ];

              final selectedIndex = ref.watch(bottomNavIndexProvider);
              final safeIndex = selectedIndex < screens.length
                  ? selectedIndex
                  : screens.length - 1;

              if (safeIndex != selectedIndex) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref.read(bottomNavIndexProvider.notifier).setIndex(safeIndex);
                });
              }

              return screens[safeIndex];
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _HomeBottomNavigationBarTest(),
          ),
        ],
      ),
      //bottomNavigationBar: _HomeBottomNavigationBar(), // Bottom NavigationBar yerine body'nin en altına taşındı
    );
  }
}
