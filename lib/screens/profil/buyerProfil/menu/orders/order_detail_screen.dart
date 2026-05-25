import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
import 'package:imecehub/providers/products_provider.dart';

class OrderDetailScreen extends ConsumerWidget {
  final Map<String, dynamic> item;
  const OrderDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    margin: EdgeInsets.all(12),
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
                              SizedBox(width: 8),
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
                                    SizedBox(height: 4),
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
                        SizedBox(width: 12),
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
                    margin: EdgeInsets.fromLTRB(12, 0, 12, 12),
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
            // Sipariş Yolculuğu - Step Indicator
            _OrderStepIndicator(durumRaw: durumRaw),
            // Sipariş İptal (sadece BEKLEMEDE durumunda)
            if (durumRaw.toUpperCase() == 'BEKLEMEDE')
              _CancelOrderSection(siparisId: siparisId),
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
                  return _orderProcutsInfoCard(context, ref, urun);
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

  Container _orderProcutsInfoCard(BuildContext context, WidgetRef ref, urun) {
    return container(
      context,
      padding: AppPaddings.all12,
      margin: EdgeInsets.symmetric(vertical: 6),
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
                    final rawId = urun['urun_bilgileri']?['urun_id'];
                    final productId = int.tryParse(rawId?.toString() ?? '');
                    if (productId == null) {
                      showTemporarySnackBar(
                        context,
                        'Ürün bulunamadı',
                        type: SnackBarType.info,
                      );
                      return;
                    }
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
                      final product = await ref.read(
                        productProvider(productId).future,
                      );
                      Navigator.of(context).pop();
                      Navigator.pushNamed(
                        context,
                        '/products/productsDetail',
                        arguments: product.urunId ?? 0,
                      );
                    } catch (e) {
                      Navigator.of(context).pop();
                      showTemporarySnackBar(
                        context,
                        'Hata: $e',
                        type: SnackBarType.error,
                      );
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
        SizedBox(height: 4),
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

/// Sipariş Yolculuğu - Dikey Step Indicator
class _OrderStepIndicator extends StatelessWidget {
  final String durumRaw;

  const _OrderStepIndicator({required this.durumRaw});

  int _getStepIndex() {
    final upper = durumRaw.trim().toUpperCase();
    if (upper.contains('IPTAL') || upper.contains('HATA') || upper.contains('GERI_ODENDI')) {
      return -1; // İptal/Hata durumu
    }
    if (upper == 'BEKLEMEDE') return 0;
    if (upper.contains('KARGOYA') || upper.contains('KARGOLANMAYI') || upper.contains('HAZIRLANIYOR')) return 1;
    if (upper == 'KARGOLANDI') return 2;
    if (upper == 'TAMAMLANDI' || upper.contains('TESLİM') || upper.contains('TESLIM')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = _getStepIndex();

    // İptal/Hata durumunda step indicator gösterme
    if (currentStep == -1) return const SizedBox.shrink();

    final steps = [
      _StepData(
        title: 'Sipariş Alındı',
        description: 'Siparişiniz sisteme kaydedildi.',
        icon: Icons.check_circle_outline,
      ),
      _StepData(
        title: 'Hazırlanıyor',
        description: 'Ürünleriniz hazırlanıp paketleniyor.',
        icon: Icons.inventory_2_outlined,
      ),
      _StepData(
        title: 'Kargolandı',
        description: 'Paketiniz kargo firmasına teslim edildi.',
        icon: Icons.local_shipping_outlined,
      ),
      _StepData(
        title: 'Teslim Edildi',
        description: 'Siparişiniz size ulaştırıldı.',
        icon: Icons.where_to_vote_outlined,
      ),
    ];

    return Container(
      padding: AppPaddings.all12,
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: AppRadius.r10,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow(context).withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Icon(Icons.route, size: 18, color: AppColors.primary(context)),
                const SizedBox(width: 8),
                Text(
                  'Sipariş Yolculuğu',
                  style: AppTextStyle.bodyLargeBold(context),
                ),
              ],
            ),
          ),
          ...List.generate(steps.length, (index) {
            final step = steps[index];
            final isCompleted = index <= currentStep;
            final isCurrent = index == currentStep;
            final isLast = index == steps.length - 1;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sol taraf: dot + çizgi
                SizedBox(
                  width: 36,
                  child: Column(
                    children: [
                      // İkon/Dot
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: isCurrent ? 36 : 28,
                        height: isCurrent ? 36 : 28,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? AppColors.primary(context)
                              : AppColors.outline(context).withOpacity(0.2),
                          shape: BoxShape.circle,
                          boxShadow: isCurrent
                              ? [
                                  BoxShadow(
                                    color: AppColors.primary(context).withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
                        ),
                        child: Icon(
                          step.icon,
                          size: isCurrent ? 18 : 14,
                          color: isCompleted
                              ? AppColors.onPrimary(context)
                              : AppColors.outline(context),
                        ),
                      ),
                      // Bağlantı çizgisi
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 32,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          color: isCompleted && index < currentStep
                              ? AppColors.primary(context)
                              : AppColors.outline(context).withOpacity(0.2),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Sağ taraf: başlık + açıklama
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: isCurrent ? 4 : 2,
                      bottom: isLast ? 0 : 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.title,
                          style: GoogleFonts.poppins(
                            fontSize: isCurrent ? 15 : 13,
                            fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
                            color: isCompleted
                                ? AppColors.onSurface(context)
                                : AppColors.onSurfaceVariant(context).withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          step.description,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: isCompleted
                                ? AppColors.onSurfaceVariant(context)
                                : AppColors.onSurfaceVariant(context).withOpacity(0.4),
                          ),
                        ),
                        if (isCurrent)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary(context).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Şu an burada',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary(context),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _StepData {
  final String title;
  final String description;
  final IconData icon;

  const _StepData({
    required this.title,
    required this.description,
    required this.icon,
  });
}

/// Sipariş İptal Bölümü
class _CancelOrderSection extends StatelessWidget {
  final String siparisId;

  const _CancelOrderSection({required this.siparisId});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.error.withOpacity(0.04),
        borderRadius: AppRadius.r10,
        border: Border.all(
          color: colorScheme.error.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: colorScheme.error.withOpacity(0.7),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Sipariş henüz kargoya verilmedi. İptal talebinde bulunabilirsiniz.',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              // TODO: Sipariş iptal API entegrasyonu
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Text(
                    'Sipariş İptali',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  content: Text(
                    'Sipariş #$siparisId iptal edilecek. Devam etmek istediğinizden emin misiniz?',
                    style: GoogleFonts.poppins(),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(
                        'Vazgeç',
                        style: GoogleFonts.poppins(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('İptal talebi gönderildi.'),
                            backgroundColor: colorScheme.primary,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.error,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'İptal Et',
                        style: GoogleFonts.poppins(color: colorScheme.onError),
                      ),
                    ),
                  ],
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.error,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: Text(
              'İptal Et',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
