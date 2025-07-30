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
          leading: TurnBackTextIcon(),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Favori verilerini çek ve göster
            Expanded(
              child: FutureBuilder<dynamic>(
                future: ApiService.fetchUserFavorites(null, null, null, null),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Scaffold(body: buildLoadingBar(context));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Hata: \\${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final favList = snapshot.data!;
                    if (favList.isEmpty) {
                      return Center(child: Text('Favori ürün bulunamadı!'));
                    }
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.builder(
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
                      ),
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
    );
  }
}
