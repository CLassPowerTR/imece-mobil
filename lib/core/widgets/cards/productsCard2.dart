import 'package:flutter/material.dart';
import 'package:imecehub/core/variables/url.dart';
import 'package:imecehub/core/widgets/raitingStars.dart';
import 'package:imecehub/core/widgets/richText.dart';
import 'package:imecehub/core/widgets/buttons/textButton.dart';
import 'package:imecehub/models/products.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';

class productsCard2 extends StatefulWidget {
  final Product product;
  final double width;
  final BuildContext context;
  final double height;
  final bool? myProducts;
  const productsCard2({
    super.key,
    required this.product,
    required this.width,
    required this.context,
    required this.height,
    this.myProducts = false,
  });

  @override
  State<productsCard2> createState() => _productsCardState();
}

class _productsCardState extends State<productsCard2> {
  bool favoriteProduct = false;
  bool cokluGorsel = false;
  bool _isDeleting = false;

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.warning_rounded,
                color: Colors.red,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Ürünü Sil',
                style: TextStyle(
                  fontSize: HomeStyle(context: ctx).titleLarge.fontSize,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(ctx).colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bu ürünü silmek istediğinize emin misiniz?',
              style: TextStyle(
                fontSize: HomeStyle(context: ctx).bodyLarge.fontSize,
                color: Theme.of(ctx).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(ctx).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 18,
                    color: HomeStyle(context: ctx).primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.product.urunAdi ?? 'Ürün',
                      style: TextStyle(
                        fontSize: HomeStyle(context: ctx).bodyMedium.fontSize,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(ctx).colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Bu işlem geri alınamaz.',
              style: TextStyle(
                fontSize: HomeStyle(context: ctx).bodySmall.fontSize,
                color: Colors.red.withOpacity(0.8),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              'İptal',
              style: TextStyle(
                color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Sil',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await _deleteProduct(context);
    }
  }

  Future<void> _deleteProduct(BuildContext context) async {
    setState(() {
      _isDeleting = true;
    });

    try {
      final productId = widget.product.urunId;
      if (productId == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ürün bilgisi bulunamadı.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // TODO: API servisine silme metodu eklendikten sonra buraya eklenecek
      // await ApiService.deleteSellerProduct(productId);

      // Şimdilik placeholder
      await Future.delayed(const Duration(seconds: 1));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Ürün başarıyla silindi.'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('Ürün silinirken bir hata oluştu: $e')),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: HomeStyle(context: context).surfaceContainer,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          spacing: 3,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Builder(
              builder: (context) {
                if (widget.product.kapakGorseli != '') {
                  return Expanded(
                    child: cokluGorsel == true
                        ? PageView.builder(
                            itemCount: widget.product.kapakGorseli!.length,
                            itemBuilder: (context, imgIndex) {
                              return Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: AssetImage(
                                          widget
                                                      .product
                                                      .kapakGorseli![imgIndex] ==
                                                  ''
                                              ? NotFound.defaultBannerImageUrl
                                              : widget
                                                    .product
                                                    .kapakGorseli![imgIndex],
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  // Görselin alt sağ köşesinde kaçıncı görsel olduğunu gösteren etiket
                                  Positioned(
                                    bottom: 4,
                                    right: 4,
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        color: HomeStyle(
                                          context: context,
                                        ).outline,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        "${imgIndex + 1}/${widget.product.kapakGorseli!.length}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          )
                        : Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      widget.product.kapakGorseli ??
                                          NotFound.defaultBannerImageUrl,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ), // Görselin alt sağ köşesinde kaçıncı görsel olduğunu gösteren etiket
                              Positioned(
                                bottom: 4,
                                right: 4,
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 25,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    color: HomeStyle(context: context).outline,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "1/1",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  );
                } else {
                  return Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(NotFound.defaultBannerImageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 4),
            richText(
              color: HomeStyle(context: context).secondary,
              fontSize: HomeStyle(context: context).bodyLarge.fontSize,
              textAlign: TextAlign.start,
              context,
              maxLines: 10,
              children: [
                TextSpan(
                  text: widget.product.urunAdi ?? '',
                  style: TextStyle(color: HomeStyle(context: context).primary),
                ),
                TextSpan(text: '\n', style: TextStyle(fontSize: 11)),
                WidgetSpan(
                  child: buildRatingStars(widget.product.degerlendirmePuani),
                ),
                TextSpan(text: '\n\n', style: TextStyle(fontSize: 10)),
                TextSpan(
                  text: 'Birim: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: '${widget.product.urunParakendeFiyat} TL\n'),
                if (widget.product.satis_turu == 2) ...[
                  TextSpan(
                    children: [
                      TextSpan(text: 'Grup Alım ile '),
                      TextSpan(
                        text: '(${widget.product.urunMinFiyat} TL)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' kadar indirim\n'),
                    ],
                  ),
                ],
                TextSpan(
                  text: 'Stok: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: widget.product.stokDurumu.toString()),
              ],
            ),
            SizedBox(height: 4),
            widget.myProducts == true
                ? Row(
                    children: [
                      Expanded(
                        child: textButton(
                          context,
                          'Ürünü Düzenle',
                          minSizeHeight: 38,
                          elevation: 0,
                          weight: FontWeight.bold,
                          fontSize: HomeStyle(
                            context: context,
                          ).bodyLarge.fontSize,
                          buttonColor: HomeStyle(
                            context: context,
                          ).surfaceContainer,
                          titleColor: HomeStyle(context: context).secondary,
                          border: true,
                          borderWidth: 1,
                          onPressed: _isDeleting
                              ? null
                              : () {
                                  Navigator.pushNamed(
                                    context,
                                    '/profil/addProduct',
                                    arguments: {
                                      'product': widget.product,
                                      'user': null, // User boş gelebilir
                                    },
                                  );
                                },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: _isDeleting
                              ? Colors.grey.withOpacity(0.2)
                              : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _isDeleting
                                ? Colors.grey.withOpacity(0.3)
                                : Colors.red.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: _isDeleting
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.red,
                                    ),
                                  ),
                                ),
                              )
                            : IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                onPressed: () =>
                                    _showDeleteConfirmationDialog(context),
                              ),
                      ),
                    ],
                  )
                : textButton(
                    context,
                    'Ürün Detay',
                    minSizeHeight: 38,
                    elevation: 0,
                    weight: FontWeight.bold,
                    fontSize: HomeStyle(context: context).bodyLarge.fontSize,
                    buttonColor: HomeStyle(context: context).surfaceContainer,
                    titleColor: HomeStyle(context: context).secondary,
                    border: true,
                    borderWidth: 1,
                    onPressed: () {
                      final productId = widget.product.urunId;
                      if (productId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Ürün bilgisi bulunamadı.'),
                          ),
                        );
                        return;
                      }
                      setState(() {
                        Navigator.pushNamed(
                          context,
                          '/home/productsDetail',
                          arguments: productId,
                        );
                      });
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
