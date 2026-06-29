import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import 'package:imecehub/core/constants/app_colors.dart';
import 'package:imecehub/core/widgets/cards/productsCard3.dart';
import 'package:imecehub/core/widgets/showTemporarySnackBar.dart';
import 'package:imecehub/models/products.dart';
import 'package:imecehub/models/product_filter.dart';
import 'package:imecehub/models/filter_group.dart';
import 'package:imecehub/models/productCategories.dart';
import 'package:imecehub/providers/auth_provider.dart';
import 'package:imecehub/providers/product_list_provider.dart';
import 'package:imecehub/providers/cart_provider.dart';
import 'package:imecehub/services/api_service.dart';
import 'package:imecehub/screens/home/home_screen.dart';
import 'package:imecehub/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'widget/products_view_body.dart';
part 'widget/products_sort_bar.dart';
part 'widget/products_active_filters.dart';
part 'widget/products_filter_sheet.dart';
part 'widget/products_skeleton_card.dart';

class ProductsScreen extends StatefulWidget {
  final String? initialSearch;
  final String? initialCategory;

  const ProductsScreen({
    super.key,
    this.initialSearch,
    this.initialCategory,
  });

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeHeaderAppBar(),
      body: ProductsScreenBodyView(
        initialSearch: widget.initialSearch,
        initialCategory: widget.initialCategory,
      ),
      drawer: const HomeDrawer(),
    );
  }
}
