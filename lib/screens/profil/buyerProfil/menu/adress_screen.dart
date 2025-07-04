part of '../buyer_profil_screen.dart';

class AdressScreen extends StatefulWidget {
  const AdressScreen({Key? key}) : super(key: key);

  @override
  State<AdressScreen> createState() => _AdressScreenState();
}

class _AdressScreenState extends State<AdressScreen> {
  late Future<List<UserAdress>> _adressFuture;

  @override
  void initState() {
    super.initState();
    _adressFuture = ApiService.fetchUserAdress()
        .then((list) => list.map((e) => UserAdress.fromJson(e)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 4,
        shadowColor: Colors.grey[300],
        leadingWidth: MediaQuery.of(context).size.width * 0.3,
        leading: TurnBackTextIcon(),
        title: customText('Adreslerim', context,
            size: HomeStyle(context: context).bodyLarge.fontSize,
            weight: FontWeight.w600),
        actions: [
          TextButton(
            onPressed: () {},
            child: customText('Adres Ekle', context,
                size: HomeStyle(context: context).bodyLarge.fontSize,
                weight: FontWeight.w600,
                color: HomeStyle(context: context).secondary),
          ),
        ],
      ),
      body: FutureBuilder<List<UserAdress>>(
        future: _adressFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: \\${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Adres bulunamadı.'));
          } else {
            final adresler = snapshot.data!;
            return ListView.builder(
              itemCount: adresler.length,
              itemBuilder: (context, index) {
                final adres = adresler[index];
                return AdressCard(adres: adres);
              },
            );
          }
        },
      ),
    );
  }
}
