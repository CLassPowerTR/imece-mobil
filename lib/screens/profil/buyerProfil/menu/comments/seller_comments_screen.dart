part of 'comments_screen.dart';

class SellerCommentsScreen extends StatefulWidget {
  final User? user;
  const SellerCommentsScreen({super.key, this.user});

  @override
  State<SellerCommentsScreen> createState() => _SellerCommentsScreenState();
}

class _SellerCommentsScreenState extends State<SellerCommentsScreen> {
  late Future<List<dynamic>> _commentsFuture;

  @override
  void initState() {
    super.initState();
    _commentsFuture = ApiService.fetchSellersComments(widget.user?.id, null);
  }

  Future<void> _refreshComments() async {
    setState(() {
      _commentsFuture = ApiService.fetchSellersComments(widget.user?.id, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder<List<dynamic>>(
      future: _commentsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: buildLoadingBar(context));
        } else if (snapshot.hasError) {
          return Center(child: Text('Hata: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const EmptyCommentsState();
        } else {
          final yorumlar = snapshot.data!;
          return RefreshIndicator(
            color: theme.colorScheme.secondary,
            backgroundColor: Colors.white,
            onRefresh: _refreshComments,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: yorumlar.length,
              itemBuilder: (context, index) {
                final item = yorumlar[index];
                return ListTile(
                  leading: const Icon(Icons.store),
                  title: Text(item['yorum']?.toString() ?? 'Yorum'),
                  subtitle: Text('Puan: ${item['puan'] ?? '-'}'),
                );
              },
            ),
          );
        }
      },
    );
  }
}
