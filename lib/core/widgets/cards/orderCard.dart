import 'package:flutter/material.dart';
import 'package:imecehub/core/constants/app_colors.dart';
import 'package:imecehub/core/constants/app_paddings.dart';
import 'package:imecehub/core/constants/app_radius.dart';
import 'package:imecehub/core/constants/app_textSizes.dart';
import 'package:imecehub/core/constants/app_textStyle.dart';
import 'package:imecehub/core/widgets/shadow.dart';
import 'package:imecehub/core/widgets/text.dart';

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
          label: 'Kargo hatası', color: Colors.deepOrange);
    default:
      return _StatusVisual(
          label: raw, color: Theme.of(context).colorScheme.primary);
  }
}

class OrderCard extends StatelessWidget {
  final String siparisNo;
  final String durum;
  final String toplamTutar;
  final String siparisTarihi;
  final String faturaAdresText;
  final dynamic item;
  const OrderCard({
    super.key,
    required this.siparisNo,
    required this.durum,
    required this.toplamTutar,
    required this.siparisTarihi,
    required this.faturaAdresText,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final status = _mapOrderStatus(durum, context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: AppRadius.r10,
        boxShadow: [
          boxShadow(context, blurRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: AppPaddings.all12,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.secondary(context),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
          ),
          Padding(
            padding: AppPaddings.all12,
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                Row(
                  spacing: 12,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Sipariş\n#$siparisNo',
                        style: AppTextStyle.bodyLargeBold(context),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: AppPaddings.all8,
                        decoration: BoxDecoration(
                          color: status.color.withOpacity(0.3),
                          borderRadius: AppRadius.r8,
                        ),
                        child: customText(status.label, context,
                            size: AppTextSizes.bodyMedium(context),
                            color: status.color,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            weight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          customText('${siparisTarihi}', context,
                              color: AppColors.primary(context),
                              textAlign: TextAlign.right,
                              size: AppTextSizes.bodyMedium(context)),
                          customText('${toplamTutar} TL', context,
                              color: AppColors.secondary(context),
                              weight: FontWeight.bold,
                              textAlign: TextAlign.right,
                              size: AppTextSizes.bodyMedium(context)),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(width: 12),
                _OrderInfoTile(
                  label: 'Fatura Adresi',
                  value: faturaAdresText,
                  maxLines: 4,
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: AppTextSizes.bodyMedium(context),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        '/profil/orders/detail',
                        arguments: item as Map<String, dynamic>,
                      );
                    },
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      size: AppTextSizes.bodyLarge(context),
                      color: AppColors.secondary(context),
                    ),
                    iconAlignment: IconAlignment.end,
                    label: customText(
                      'Daha detaylı gör',
                      context,
                      style: AppTextStyle.titleSecondary(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderInfoTile extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? textStyle;

  final int? maxLines;

  _OrderInfoTile({
    required this.label,
    required this.value,
    this.maxLines,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.primary.withOpacity(0.6),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: maxLines ?? 3,
          overflow: TextOverflow.ellipsis,
          style: textStyle ??
              theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}
