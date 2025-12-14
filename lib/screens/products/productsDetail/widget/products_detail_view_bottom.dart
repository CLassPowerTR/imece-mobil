part of '../products_detail_screen.dart';

class ProductsDetailViewBottom extends ConsumerStatefulWidget {
  final int productId;
  final List<int> sepetUrunIdList;
  final Future<void> Function()? sepeteEkle;

  const ProductsDetailViewBottom({
    super.key,
    required this.productId,
    required this.sepetUrunIdList,
    required this.sepeteEkle,
  });

  @override
  ConsumerState<ProductsDetailViewBottom> createState() =>
      _ProductsDetailViewBottomState();
}

class _ProductsDetailViewBottomState
    extends ConsumerState<ProductsDetailViewBottom> {
  bool isLoggedIn = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productProvider(widget.productId));
    final width = MediaQuery.of(context).size.width;
    final isSmallScreen = width < 360;

    return productAsync.when(
      loading: () => container(
        context,
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 8 : 10,
          vertical: isSmallScreen ? 6 : 8,
        ),
        color: HomeStyle(context: context).surfaceContainer,
        width: double.infinity,
        height: isSmallScreen ? 60 : 70,
        child: Center(child: buildLoadingBar(context)),
      ),
      error: (error, stackTrace) => container(
        context,
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 8 : 10,
          vertical: isSmallScreen ? 6 : 8,
        ),
        color: HomeStyle(context: context).surfaceContainer,
        width: double.infinity,
        height: isSmallScreen ? 60 : 70,
        child: Center(
          child: Text(
            'Ürün yüklenemedi',
            style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
          ),
        ),
      ),
      data: (product) {
        final themeData = HomeStyle(context: context);
        final currentUser = ref.watch(userProvider);
        final isSeller = currentUser?.rol == 'satici';
        return container(
          context,
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 8 : 10,
            vertical: isSmallScreen ? 6 : 8,
          ),
          color: themeData.surfaceContainer,
          width: double.infinity,
          height: isSmallScreen ? 60 : 70,
          child: Row(
            children: [
              _fiyatStokText(themeData, product, isSmallScreen),
              SizedBox(width: isSmallScreen ? 6 : 10),
              if (!isSeller) ...[
                _sepeteEkleButton(context, product, isSmallScreen),
                SizedBox(width: isSmallScreen ? 6 : 10),
                _grupAlimButton(context, isSmallScreen),
              ],
            ],
          ),
        );
      },
    );
  }

  Expanded _grupAlimButton(BuildContext context, bool isSmallScreen) {
    return Expanded(
      child: textButton(
        context,
        'Grup alım',
        buttonColor: Colors.orange,
        elevation: 4,
        fontSize: isSmallScreen ? 11 : null,
      ),
    );
  }

  Builder _sepeteEkleButton(
    BuildContext context,
    Product product,
    bool isSmallScreen,
  ) {
    final isInSepet = widget.sepetUrunIdList.contains(product.urunId);

    return Builder(
      builder: (context) {
        if (product.stokDurumu! <= 0) {
          return Expanded(
            child: container(
              context,
              color: Colors.red,
              borderRadius: AppRadius.r8,
              boxShadowColor: Colors.red,
              alignment: Alignment.center,
              child: customText(
                'Stokta Yok',
                context,
                color: AppColors.onPrimary(context),
                size: isSmallScreen ? 11 : HomeStyle(context: context).bodySmall.fontSize,
              ),
            ),
          );
        } else {
          return Expanded(
            child: textButton(
              context,
              isInSepet ? 'Sepete Git' : 'Sepete ekle',
              elevation: 4,
              buttonColor: isInSepet ? Colors.orangeAccent : null,
              onPressed: widget.sepeteEkle,
              fontSize: isSmallScreen ? 11 : null,
            ),
          );
        }
      },
    );
  }

  Expanded _fiyatStokText(
    HomeStyle themeData,
    Product product,
    bool isSmallScreen,
  ) {
    return Expanded(
      child: RichText(
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          style: TextStyle(
            fontSize: isSmallScreen ? 11 : themeData.bodyMedium.fontSize,
            color: themeData.primary,
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(text: 'KG:'),
            TextSpan(
              text: ' ${product.urunParakendeFiyat} TL',
              style: TextStyle(color: themeData.secondary),
            ),
            TextSpan(text: '\nKalan:'),
            TextSpan(
              text: ' ${product.stokDurumu} KG',
              style: TextStyle(
                color: getStokRengi(product.stokDurumu ?? 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Stok durumuna göre renk belirleme fonksiyonu
Color getStokRengi(int stok) {
  if (stok > 200) {
    return Colors.green;
  } else if (stok >= 100 && stok <= 200) {
    return Colors.yellow.shade800;
  } else {
    return Colors.red;
  }
}
