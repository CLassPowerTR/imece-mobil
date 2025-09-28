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
          );
        }
      },
    );
  }
}
