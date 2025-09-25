part of '../../buyer_profil_screen.dart';

class OrderScreenBody extends ConsumerStatefulWidget {
  const OrderScreenBody({Key? key}) : super(key: key);

  @override
  ConsumerState<OrderScreenBody> createState() => _OrderScreenBodyState();
}

class _OrderScreenBodyState extends ConsumerState<OrderScreenBody> {
  late Future<List<dynamic>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    // userProvider'ı initState'de ref ile alamayız, build'de alacağız.
    // _ordersFuture'ı build içinde başlatacağız.
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    _ordersFuture = ApiService.fetchLogisticOrder(user?.id); // id gönderiyoruz
    return FutureBuilder<List<dynamic>>(
      future: _ordersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: buildLoadingBar(context));
        } else if (snapshot.hasError) {
          return Center(child: Text('Hata: \\${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Sipariş bulunamadı.'));
        } else {
          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final item = orders[index];
              final String siparisNo = item['siparis_id']?.toString() ?? '-';
              final String durum = item['durum']?.toString() ?? '-';
              final String toplamTutar =
                  (item['toplam_fiyat'] ?? item['toplam'] ?? '-').toString();
              final String siparisTarihi =
                  (item['siparis_verilme_tarihi'] ?? item['tarih'] ?? '-')
                      .toString();
              final int? faturaAdresiID =
                  (item['fatura_adresi'] ?? item['fatura_adres']) as int?;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Üst çizgi
                    Container(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 12,
                        children: [
                          // Sipariş id
                          Text(
                            'Sipariş id: #$siparisNo',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Satır 1: Durum - Toplam Tutar
                          Row(
                            children: [
                              Expanded(
                                child: _OrderInfoTile(
                                  label: 'Durum',
                                  value: durum,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _OrderInfoTile(
                                  label: 'Toplam tutar',
                                  value: toplamTutar,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Satır 2: Sipariş Tarihi - Fatura Adresi
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _OrderInfoTile(
                                  label: 'Sipariş tarihi',
                                  value: siparisTarihi,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          FutureBuilder<UserAdress>(
                            future: faturaAdresiID != null
                                ? ApiService.fetchUserAdressById(faturaAdresiID)
                                : Future<UserAdress>.value(
                                    UserAdress(
                                      id: 0,
                                      ulke: '-',
                                      il: '-',
                                      ilce: '-',
                                      mahalle: '-',
                                      postaKodu: '-',
                                      adresSatiri1: '-',
                                      adresSatiri2: '-',
                                      baslik: '-',
                                      adresTipi: '-',
                                      varsayilanAdres: false,
                                      createdAt: DateTime.now(),
                                      updatedAt: DateTime.now(),
                                      kullanici: 0,
                                    ),
                                  ),
                            builder: (context, adresSnap) {
                              if (adresSnap.connectionState ==
                                  ConnectionState.waiting) {
                                return _OrderInfoTile(
                                  label: 'Fatura Adresi',
                                  value: 'Yükleniyor...',
                                  maxLines: 3,
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.secondary(context),
                                    fontSize: AppTextSizes.bodyMedium(context),
                                  ),
                                );
                              } else if (adresSnap.hasError) {
                                return _OrderInfoTile(
                                  label: 'Fatura Adresi',
                                  value: '-',
                                  maxLines: 3,
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: AppTextSizes.bodyMedium(context),
                                  ),
                                );
                              } else if (!adresSnap.hasData) {
                                return _OrderInfoTile(
                                  label: 'Fatura Adresi',
                                  value: '-',
                                  maxLines: 3,
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: AppTextSizes.bodyMedium(context),
                                  ),
                                );
                              }
                              final adres = adresSnap.data!;
                              final String adresText = [
                                adres.adresSatiri1,
                                '${adres.mahalle} ${adres.ilce}',
                                '${adres.il}/${adres.ulke}',
                                'PK: ${adres.postaKodu}',
                              ]
                                  .where((e) =>
                                      e != null &&
                                      e.toString().trim().isNotEmpty)
                                  .join(', ');
                              return _OrderInfoTile(
                                label: 'Fatura Adresi',
                                value: adresText,
                                maxLines: 4,
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: AppTextSizes.bodyMedium(context),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: null,
                              child: const Text('Daha detaylı gör'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}

class _OrderInfoTile extends StatelessWidget {
  final String label;
  final String value;
  TextStyle? textStyle;
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
