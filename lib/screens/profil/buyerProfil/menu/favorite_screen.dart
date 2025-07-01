part of '../buyer_profil_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 4,
          shadowColor: Colors.grey[300],
          leadingWidth: MediaQuery.of(context).size.width * 0.3,
          title: customText('Favorilerim', context,
              size: HomeStyle(context: context).bodyLarge.fontSize,
              weight: FontWeight.w600),
          leading: TextButton.icon(
            style: TextButton.styleFrom(
              minimumSize: const Size(0, kToolbarHeight),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              size: 20,
              color: HomeStyle(context: context).secondary,
            ),
            label: customText(
              'Geri Dön',
              context,
              weight: FontWeight.w600,
              color: HomeStyle(context: context).secondary,
              size: 14,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Favori verilerini çek ve göster
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: ApiService.fetchUserFavorites(null, null, null),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Hata: \\${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      final favList = snapshot.data!;
                      if (favList.isEmpty) {
                        return Center(child: Text('Favori ürün bulunamadı!'));
                      }
                      return ListView.builder(
                        itemCount: favList.length,
                        itemBuilder: (context, index) {
                          final item = favList[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 6),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(item.toString()),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(child: Text('Veri bulunamadı.'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
