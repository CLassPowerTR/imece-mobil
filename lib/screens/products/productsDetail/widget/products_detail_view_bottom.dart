part of '../products_detail_screen.dart';

class ProductsDetailViewBottom extends ConsumerStatefulWidget {
  final Product product;
  final List<int> sepetUrunIdList;
  final Future<void> Function()? sepeteEkle;

  const ProductsDetailViewBottom({
    super.key,
    required this.product,
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
    final themeData = HomeStyle(context: context);
    final currentUser = ref.watch(userProvider);
    final isSeller = currentUser?.rol == 'satici';
    return container(
      context,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      color: themeData.surfaceContainer,
      width: double.infinity,
      height: 70,
      child: Row(
        spacing: 10,
        children: [
          _fiyatStokText(themeData),
          if (!isSeller) ...[
            _sepeteEkleButton(context),
            _grupAlimButton(context),
          ],
        ],
      ),
    );
  }

  Expanded _grupAlimButton(BuildContext context) {
    return Expanded(
      child: textButton(
        context,
        'Grup alım',
        buttonColor: Colors.orange,
        elevation: 4,
      ),
    );
  }

  Builder _sepeteEkleButton(BuildContext context) {
    final isInSepet = widget.sepetUrunIdList.contains(widget.product.urunId);

    return Builder(
      builder: (context) {
        if (widget.product.stokDurumu! <= 0) {
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
                size: HomeStyle(context: context).bodyMedium.fontSize,
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
            ),
          );
        }
      },
    );
  }

  Expanded _fiyatStokText(HomeStyle themeData) {
    return Expanded(
      child: RichText(
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          style: TextStyle(
            fontSize: themeData.bodyLarge.fontSize,
            color: themeData.primary,
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(text: 'KG:'),
            TextSpan(
              text: ' ${widget.product.urunParakendeFiyat} TL',
              style: TextStyle(color: themeData.secondary),
            ),
            TextSpan(text: '\nKalan:'),
            TextSpan(
              text: ' ${widget.product.stokDurumu} KG',
              style: TextStyle(
                color: getStokRengi(widget.product.stokDurumu ?? 0),
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
