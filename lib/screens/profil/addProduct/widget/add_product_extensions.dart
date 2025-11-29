part of '../add_product_screen.dart';

extension AddProductExtensions on BuildContext {
  Widget addProductBody(User user, {Product? product}) {
    return AddProductViewBody(profileName: user, product: product);
  }
}

extension _AddProductCategoryResolve on _AddProductViewBodyState {
  int _resolveSelectedCategoryId() {
    if (selectedCategoryName == null) return 0;
    final match = _AddProductViewBodyState.kategoriler.firstWhere(
      (e) => e['ad'] == selectedCategoryName,
      orElse: () => const {'ad': '', 'kategori': 0},
    );
    final dynamic id = match['kategori'];
    if (id is int) return id;
    return int.tryParse('$id') ?? 0;
  }
}
