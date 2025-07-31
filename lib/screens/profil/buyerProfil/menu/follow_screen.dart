part of '../buyer_profil_screen.dart';

class FollowScreen extends StatefulWidget {
  const FollowScreen({Key? key}) : super(key: key);

  @override
  State<FollowScreen> createState() => _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen> {
  late Future<List<dynamic>> _followFuture;

  Future<List<User>> _getAllFollowedUsers(List<dynamic> takipEdilenler) async {
    List<User> users = [];
    for (var item in takipEdilenler) {
      final saticiId = item['satici'];
      try {
        final user = await ApiService.fetchUserId(saticiId);
        users.add(user);
      } catch (_) {}
    }
    return users;
  }

  @override
  void initState() {
    super.initState();
    _followFuture = ApiService.fetchUserFollow();
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
        title: customText('Takip Ettiklerim', context,
            size: HomeStyle(context: context).bodyLarge.fontSize,
            weight: FontWeight.w600),
        leading: TurnBackTextIcon(),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _followFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox();
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Takip edilen bulunamadı.'));
          } else {
            final takipEdilenler = snapshot.data!;
            return FutureBuilder<List<User>>(
              future: _getAllFollowedUsers(takipEdilenler),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(body: buildLoadingBar(context));
                } else if (userSnapshot.hasError) {
                  return Center(child: Text('Hata: ${userSnapshot.error}'));
                } else if (!userSnapshot.hasData ||
                    userSnapshot.data!.isEmpty) {
                  return const Center(child: Text('Kullanıcı bulunamadı'));
                } else {
                  final users = userSnapshot.data!;
                  return GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: MediaQuery.of(context).size.height * 0.2,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      final saticiId = user.id;
                      return FollowsCard(
                        context,
                        user,
                        saticiId,
                        () async {
                          await Navigator.pushNamed(
                            context,
                            '/profil/sellerProfile',
                            arguments: [user, false],
                          );
                          setState(() {
                            _followFuture = ApiService.fetchUserFollow();
                          });
                        },
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
