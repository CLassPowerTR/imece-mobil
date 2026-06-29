import 'package:flutter/material.dart';
import 'package:imecehub/core/constants/app_colors.dart';
import 'package:imecehub/core/widgets/textField.dart';

import 'package:imecehub/screens/products/products_screen.dart';

part 'widget/categories_view_body.dart';
part 'widget/categories_view_header.dart';

class CategoriesScreen extends StatelessWidget {
  final int categoryId;

  const CategoriesScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CategoriesViewHeader(),
      body: ProductsScreenBodyView(
        initialCategory: categoryId.toString(),
      ),
    );
  }
}

