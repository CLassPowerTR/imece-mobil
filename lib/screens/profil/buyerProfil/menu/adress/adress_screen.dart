part of '../../buyer_profil_screen.dart';

class AdressScreen extends StatefulWidget {
  final User buyerProfil;
  const AdressScreen({super.key, required this.buyerProfil});

  @override
  State<AdressScreen> createState() => _AdressScreenState();
}

class _AdressScreenState extends State<AdressScreen> {
  late Future<List<UserAdress>> _adressFuture;
  bool _isDeleting = false;

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
            onPressed: () async {
              await Navigator.pushNamed(context, '/profil/adress/add',
                  arguments: {
                    'buyerProfil': widget.buyerProfil,
                    'isUpdate': false,
                  });
              setState(() {
                _adressFuture = ApiService.fetchUserAdress().then(
                    (list) => list.map((e) => UserAdress.fromJson(e)).toList());
              });
            },
            child: customText('Adres Ekle', context,
                size: HomeStyle(context: context).bodyLarge.fontSize,
                weight: FontWeight.w600,
                color: HomeStyle(context: context).secondary),
          ),
        ],
      ),
      body: Stack(
        children: [
          FutureBuilder<List<UserAdress>>(
            future: _adressFuture,
            builder: (context, snapshot) {
              if (_isDeleting) {
                // Silme sırasında loading bar zaten Stack ile gösteriliyor, burada tekrar gösterme
                return const SizedBox.shrink();
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildLoadingBar(context),
                    const SizedBox(height: 16),
                  ],
                );
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
                    return AdressCard(
                      adres: adres,
                      onEdit: () async {
                        await Navigator.pushNamed(context, '/profil/adress/add',
                            arguments: {
                              'buyerProfil': widget.buyerProfil,
                              'adres': adres,
                              'isUpdate': true,
                            });
                        setState(() {
                          _adressFuture = ApiService.fetchUserAdress().then(
                              (list) => list
                                  .map((e) => UserAdress.fromJson(e))
                                  .toList());
                        });
                      },
                      onDelete: () async {
                        setState(() {
                          _isDeleting = true;
                        });
                        try {
                          await ApiService.deleteUserAdress(adres.id);
                          setState(() {
                            _adressFuture = ApiService.fetchUserAdress().then(
                                (list) => list
                                    .map((e) => UserAdress.fromJson(e))
                                    .toList());
                          });
                        } catch (e) {
                          showTemporarySnackBar(
                            context,
                            'Adres silinirken bir hata oluştu: $e',
                            type: SnackBarType.error,
                          );
                        } finally {
                          setState(() {
                            _isDeleting = false;
                          });
                        }
                      },
                    );
                  },
                );
              }
            },
          ),
          if (_isDeleting)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: buildLoadingBar(context),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
