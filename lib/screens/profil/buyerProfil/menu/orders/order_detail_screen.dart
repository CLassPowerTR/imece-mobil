import 'package:flutter/material.dart';
import 'package:imecehub/core/constants/app_colors.dart';
import 'package:imecehub/core/constants/app_paddings.dart';
import 'package:imecehub/core/constants/app_radius.dart';
import 'package:imecehub/core/constants/app_textSizes.dart';
import 'package:imecehub/core/constants/app_textStyle.dart';
import 'package:imecehub/core/widgets/container.dart';
import 'package:imecehub/core/widgets/shadow.dart';
import 'package:imecehub/core/widgets/showTemporarySnackBar.dart';
import 'package:imecehub/core/widgets/text.dart';
import 'package:imecehub/core/widgets/buildLoadingBar.dart';
import 'package:imecehub/core/widgets/buttons/turnBackTextIcon.dart';
import 'package:imecehub/services/api_service.dart';
import 'package:imecehub/models/products.dart';

class OrderDetailScreen extends StatelessWidget {
  final Map<String, dynamic> item;
  const OrderDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final String siparisId = (item['siparis_id'] ?? item['id'] ?? '-')
        .toString();
    final String siparisTarihi =
        (item['siparis_verilme_tarihi'] ?? item['tarih'] ?? '-').toString();
    final String durumRaw = (item['durum'] ?? '-').toString();
    final String faturaAdresText = (item['fatura_adresi_string'] ?? '-')
        .toString();
    final _StatusVisual status = _mapOrderStatus(durumRaw, context);
    final String toplamFiyat = (item['toplam_fiyat'] ?? item['toplam'] ?? '-')
        .toString();
    final int urunSayisi = item['urunler'] is List
        ? (item['urunler'] as List).length
        : (int.tryParse((item['urun_sayisi'] ?? '0').toString()) ?? 0);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: TurnBackTextIcon(),
        leadingWidth: MediaQuery.of(context).size.width * 0.3,
        title: customText(
          'Sipariş Detayları',
          context,
          style: AppTextStyle.bodyLargeBold(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppPaddings.all12,
        child: Column(
          spacing: 12,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface(context),
                borderRadius: AppRadius.r10,
                boxShadow: [boxShadow(context, blurRadius: 2)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Üst blok
                  Container(
                    margin: const EdgeInsets.all(12),
                    padding: AppPaddings.all12,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: AppRadius.r8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.local_shipping_outlined,
                                color: AppColors.primary(context),
                                size: AppTextSizes.bodyLarge(context),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sipariş #$siparisId',
                                      style: AppTextStyle.titlePrimary(context),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      siparisTarihi,
                                      style: AppTextStyle.bodySmallMuted(
                                        context,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: AppPaddings.all8,
                          decoration: BoxDecoration(
                            color: status.color.withOpacity(0.15),
                            borderRadius: AppRadius.r8,
                          ),
                          child: Text(
                            status.label,
                            style: AppTextStyle.bodyMedium(context).copyWith(
                              color: status.color,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Alt blok
                  Container(
                    margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    padding: AppPaddings.all12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      spacing: 12,
                      children: [
                        _MetricTile(
                          value: '$toplamFiyat TL',
                          label: 'Toplam tutar',
                          valueStyle: AppTextStyle.bodyLargeBold(
                            context,
                          ).copyWith(color: AppColors.secondary(context)),
                        ),
                        _MetricTile(
                          value: urunSayisi.toString(),
                          label: 'Ürün sayısı',
                        ),
                        _MetricTile(value: status.label, label: 'Durum'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _infoCard(
              context,
              title: 'Alıcı Bilgileri',
              icon: Icons.person_outline,
              value: item['alici_ad_soyad'],
              item: null,
            ),
            _infoCard(
              context,
              title: 'Fatura Adresi',
              icon: Icons.location_on_outlined,
              value: faturaAdresText,
              item: null,
            ),
            _infoCard(
              context,
              title: 'Ürünler',
              icon: Icons.production_quantity_limits,
              value: null,
              item: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: item['urunler'].length,
                itemBuilder: (context, index) {
                  final urun = item['urunler'][index];
                  return _orderProcutsInfoCard(context, urun);
                },
              ),
            ),
            _infoCard(
              context,
              title: 'Ek Bilgiler',
              icon: null,
              value: null,
              item: Row(
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Sipariş ID\n',
                            style: AppTextStyle.bodySmallMuted(context),
                          ),
                          TextSpan(
                            text: siparisId,
                            style: AppTextStyle.bodyMediumBold(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Sipariş Tarihi\n',
                            style: AppTextStyle.bodySmallMuted(context),
                          ),
                          TextSpan(
                            text: siparisTarihi,
                            style: AppTextStyle.bodyMediumBold(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          ],
        ),
      ),
    );
  }

  Container _orderProcutsInfoCard(BuildContext context, urun) {
    return container(
      context,
      padding: AppPaddings.all12,
      margin: const EdgeInsets.symmetric(vertical: 6),
      borderRadius: AppRadius.r8,
      color: AppColors.cardColor(context),
      blurRadius: 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 16,
              children: [
                customText(
                  '${urun['urun_bilgileri']['urun_adi']}',
                  context,
                  style: AppTextStyle.bodyMediumBold(context),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                customText(
                  '${urun['urun_bilgileri']['aciklama']}',
                  context,
                  style: AppTextStyle.bodySmallMuted(context),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                customText(
                  'Miktar: ${urun['miktar']}',
                  context,
                  maxLines: 2,
                  style: AppTextStyle.bodySmallMuted(context),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customText(
                  '${urun['fiyat']} TL',
                  context,
                  maxLines: 2,
                  style: AppTextStyle.bodyLargeBold(
                    context,
                  ).copyWith(color: AppColors.secondary(context)),
                ),
                TextButton.icon(
                  iconAlignment: IconAlignment.end,
                  icon: Icon(
                    Icons.arrow_right_alt,
                    size: AppTextSizes.bodyLarge(context),
                  ),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      barrierColor: Colors.black54,
                      builder: (_) => Center(
                        child: SizedBox(
                          width: 200,
                          child: buildLoadingBar(context),
                        ),
                      ),
                    );
                    try {
                      final String id = urun['urun_bilgileri']['urun_id']
                          .toString();
                      final Product product = await ApiService.fetchProduct(
                        int.parse(id),
                      );
                      Navigator.of(context).pop();
                      if (product != null) {
                        Navigator.pushNamed(
                          context,
                          '/products/productsDetail',
                          arguments: product,
                        );
                      }
                      if (product == null) {
                        showTemporarySnackBar(
                          context,
                          'Ürün bulunamadı',
                          type: SnackBarType.info,
                        );
                      }
                    } catch (e) {
                      showTemporarySnackBar(
                        context,
                        'Hata: $e',
                        type: SnackBarType.error,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  label: customText(
                    'İncele',
                    context,
                    maxLines: 1,
                    style: AppTextStyle.bodySmallMuted(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _infoCard(
    BuildContext context, {
    required String title,
    required IconData? icon,
    required String? value,
    required Widget? item,
  }) {
    return container(
      context,
      color: AppColors.surface(context),
      padding: AppPaddings.all12,
      borderRadius: AppRadius.r10,
      blurRadius: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          RichText(
            maxLines: 4,
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: icon != null
                      ? Icon(
                          icon,
                          color: AppColors.primary(context),
                          size: AppTextSizes.bodyLarge(context),
                        )
                      : SizedBox(height: 0, width: 0),
                ),
                WidgetSpan(child: SizedBox(width: 8)),
                TextSpan(
                  text: title,
                  style: AppTextStyle.bodyLargeBold(context),
                ),
              ],
            ),
          ),
          if (value != null)
            customText(
              value,
              context,
              maxLines: 5,
              style: AppTextStyle.bodyMedium(context),
            ),
          if (item != null) item,
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String value;
  final String label;
  final TextStyle? valueStyle;
  const _MetricTile({
    required this.value,
    required this.label,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: valueStyle ?? AppTextStyle.bodyLargeBold(context),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyle.bodySmallMuted(context),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _StatusVisual {
  final String label;
  final Color color;
  const _StatusVisual({required this.label, required this.color});
}

_StatusVisual _mapOrderStatus(String raw, BuildContext context) {
  final upper = raw.trim().toUpperCase();
  switch (upper) {
    case 'BEKLEMEDE':
      return const _StatusVisual(label: 'Beklemede', color: Colors.red);
    case 'KARGOLANDI':
      return const _StatusVisual(label: 'Kargolandı', color: Colors.orange);
    case 'TAMAMLANDI':
      return const _StatusVisual(label: 'Tamamlandı', color: Colors.green);
    case 'IPTAL':
      return const _StatusVisual(label: 'İptal', color: Colors.red);
    case 'HATA':
      return _StatusVisual(label: 'Hata', color: Colors.red.shade300);
    case 'GERI_ODENDI':
      return const _StatusVisual(label: 'Geri ödendi', color: Colors.teal);
    case 'KARGO_HATASI':
      return const _StatusVisual(
        label: 'Kargo hatası',
        color: Colors.deepOrange,
      );
    default:
      return _StatusVisual(
        label: raw,
        color: Theme.of(context).colorScheme.primary,
      );
  }
}
