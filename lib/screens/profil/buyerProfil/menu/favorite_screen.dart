part of '../buyer_profil_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Geri Dön Butonu
              TextButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.arrow_back),
                label: customText('Geri Dön', context),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                  textStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
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
