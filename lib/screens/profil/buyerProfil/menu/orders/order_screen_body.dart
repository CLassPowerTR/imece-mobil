part of '../../buyer_profil_screen.dart';

class OrderScreenBody extends ConsumerStatefulWidget {
  const OrderScreenBody({Key? key}) : super(key: key);

  @override
  ConsumerState<OrderScreenBody> createState() => _OrderScreenBodyState();
}

class _OrderScreenBodyState extends ConsumerState<OrderScreenBody> {
  late Future<List<dynamic>> _ordersFuture;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _refreshOrders() async {
    final user = ref.read(userProvider);
    setState(() {
      _ordersFuture = ApiService.fetchLogisticOrder(user?.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    // Initialize once, not on every rebuild
    if (!_initialized) {
      _ordersFuture = ApiService.fetchLogisticOrder(user?.id);
      _initialized = true;
    }

    return FutureBuilder<List<dynamic>>(
      future: _ordersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Skeleton loading - shimmer
          return _buildOrderSkeleton(context);
        } else if (snapshot.hasError) {
          return _buildErrorState(context);
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return EmptyOrdersState(
            onGoToProducts: () {
              Navigator.pushNamed(context, '/products');
            },
          );
        } else {
          final orders = snapshot.data!;
          return RefreshIndicator(
            color: AppColors.primary(context),
            backgroundColor: AppColors.surface(context),
            onRefresh: _refreshOrders,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
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
                final String faturaAdresText =
                    (item['fatura_adresi_string'] ?? '-').toString();

                return OrderCard(
                  item: item,
                  siparisNo: siparisNo,
                  durum: durum,
                  toplamTutar: toplamTutar,
                  siparisTarihi: siparisTarihi,
                  faturaAdresText: faturaAdresText,
                );
              },
            ),
          );
        }
      },
    );
  }

  Widget _buildOrderSkeleton(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.outline(context).withOpacity(0.12),
      highlightColor: AppColors.surface(context),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 120,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 26,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 100,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 100,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Container(
                      width: 70,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 64,
              color: AppColors.error(context).withOpacity(0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'Siparişler Yüklenemedi',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'İnternet bağlantınızı kontrol edip tekrar deneyin.',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.onSurfaceVariant(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _refreshOrders,
              icon: const Icon(Icons.refresh),
              label: Text(
                'Tekrar Dene',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary(context),
                foregroundColor: AppColors.onPrimary(context),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
