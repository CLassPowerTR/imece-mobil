part of '../buyer_profil_screen.dart';

class FollowScreen extends StatefulWidget {
  const FollowScreen({Key? key}) : super(key: key);

  @override
  State<FollowScreen> createState() => _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen> {
  late Future<List<dynamic>> _followFuture;

  @override
  void initState() {
    super.initState();
    _followFuture = ApiService.fetchUserFollow();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Takip Ettiklerim'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _followFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: buildLoadingBar(context));
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: \\${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Takip edilen bulunamadı.'));
          } else {
            final takipEdilenler = snapshot.data!;
            return ListView.builder(
              itemCount: takipEdilenler.length,
              itemBuilder: (context, index) {
                final item = takipEdilenler[index];
                final saticiId = item['satici'];
                return FutureBuilder<User>(
                  future: ApiService.fetchUserId(saticiId),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Scaffold(body: buildLoadingBar(context));
                    } else if (userSnapshot.hasError) {
                      return Center(
                          child: Text('Hata: \\${userSnapshot.error}'));
                    } else if (!userSnapshot.hasData) {
                      return Center(child: Text('Kullanıcı bulunamadı'));
                    } else {
                      final user = userSnapshot.data!;
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/profil/sellerProfile',
                            arguments: [user, false],
                          );
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              user.saticiProfili!.profilBanner!,
                            ),
                          ),
                          title: Text(user.firstName.isNotEmpty
                              ? user.firstName
                              : user.username),
                          subtitle: Text('Satıcı ID: $saticiId'),
                        ),
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
