part of 'comments_screen.dart';

class SellerCommentsScreen extends StatelessWidget {
  final User? user;
  const SellerCommentsScreen({super.key, this.user});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: ApiService.fetchSellersComments(user?.id, null),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: buildLoadingBar(context));
        } else if (snapshot.hasError) {
          return Center(child: Text('Hata: \\${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Mağaza yorumu bulunamadı.'));
        } else {
          final yorumlar = snapshot.data!;
          return ListView.builder(
            itemCount: yorumlar.length,
            itemBuilder: (context, index) {
              final item = yorumlar[index];
              return ListTile(
                leading: const Icon(Icons.store),
                title: Text(item['yorum']?.toString() ?? 'Yorum'),
                subtitle: Text('Puan: \\${item['puan'] ?? '-'}'),
              );
            },
          );
        }
      },
    );
  }
}
