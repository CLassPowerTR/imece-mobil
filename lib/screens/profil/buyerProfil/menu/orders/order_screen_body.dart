part of '../../buyer_profil_screen.dart';

class OrderScreenBody extends StatefulWidget {
  const OrderScreenBody({Key? key}) : super(key: key);

  @override
  State<OrderScreenBody> createState() => _OrderScreenBodyState();
}

class _OrderScreenBodyState extends State<OrderScreenBody> {
  late Future<List<dynamic>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = ApiService.fetchLogisticOrder();
  }

  @override
  Widget build(BuildContext context) {
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
              return ListTile(
                leading: const Icon(Icons.local_shipping),
                title: Text(item['siparis_no']?.toString() ?? 'Sipariş'),
                subtitle: Text('Durum: \\${item['durum'] ?? '-'}'),
              );
            },
          );
        }
      },
    );
  }
}
