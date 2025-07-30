part of '../buyer_profil_screen.dart';

class CouponsScreen extends StatefulWidget {
  const CouponsScreen({Key? key}) : super(key: key);

  @override
  State<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  late Future<List<dynamic>> _couponsFuture;

  @override
  void initState() {
    super.initState();
    _couponsFuture = ApiService.fetchUserCoupons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: MediaQuery.of(context).size.width * 0.3,
        leading: TurnBackTextIcon(),
        centerTitle: true,
        title: customText('Kuponlarım', context,
            size: HomeStyle(context: context).bodyLarge.fontSize,
            weight: FontWeight.w600),
        actions: [
          TextButton(
              onPressed: () {},
              child: customText('Kupon Ekle', context,
                  color: HomeStyle(context: context).secondary,
                  weight: FontWeight.w600,
                  size: 16)),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _couponsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return buildLoadingBar(context);
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: \\${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Mevcutta Kupon bulunamadı.'));
          } else {
            final kuponlar = UserCoupon.fromList(snapshot.data!);
            return ListView.builder(
              itemCount: kuponlar.length,
              itemBuilder: (context, index) {
                final item = kuponlar[index];
                return ListTile(
                  leading: const Icon(Icons.card_giftcard),
                  title: Text(item.altLimit.toString()),
                  subtitle: Text('İndirim: ${item.miktar}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
