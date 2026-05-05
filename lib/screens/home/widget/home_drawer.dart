part of '../home_screen.dart';

class HomeDrawer extends ConsumerStatefulWidget {
  const HomeDrawer({super.key});

  @override
  ConsumerState<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends ConsumerState<HomeDrawer> {
  late Future<List<Category>> _futureCategory;

  @override
  void initState() {
    super.initState();
    _futureCategory = ApiService.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final themeData = HomeStyle(context: context);

    return Drawer(
      backgroundColor: themeData.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              bottom: 20,
              left: 20,
              right: 20,
            ),
            color: themeData.primary,
            child: user == null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white70,
                            radius: 24,
                            child: Icon(Icons.person, color: themeData.primary, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: "Giriş yap",
                                style: themeData.titleSmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: "\nHesabım & Siparişlerim",
                                    style: themeData.bodySmall.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                            ),
                          ),
                      )],
                      ),    
                      
                      
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 24,
                            child: Icon(Icons.person, color: themeData.primary, size: 30),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "${user.firstName} ${user.lastName}",
                              style: themeData.titleMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Hesabım & Siparişlerim",
                        style: themeData.bodyMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
          // Body
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Text(
                    "Kategoriler",
                    style: themeData.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: DesignTokens.textSecondary,
                    ),
                  ),
                ),
                FutureBuilder<List<Category>>(
                  future: _futureCategory,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text("Hata: ${snapshot.error}"),
                      );
                    } else if (snapshot.hasData) {
                      final categories = snapshot.data!;
                      return Column(
                        children: categories.map((category) {
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                            title: Text(
                              category.altKategoriAdi.toString(),
                              style: themeData.bodyMedium.copyWith(
                                color: DesignTokens.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context); // close drawer
                              Navigator.pushNamed(
                                context,
                                '/home/category',
                                arguments: category.kategoriId,
                              );
                            },
                          );
                        }).toList(),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
