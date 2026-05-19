
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
    _futureCategory = ApiService.fetchCategoriesTree();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Drawer(
      backgroundColor: AppColors.surface(context),
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
            color: AppColors.primary(context),
            child: user == null
                  ? GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/profil/signIn');
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white70,
                                radius: 24,
                                child: Icon(Icons.person, color: AppColors.primary(context), size: 24),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    text: "Giriş yap",
                                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "\nHesabım & Siparişlerim",
                                        style: AppTextStyle.bodySmall(context).copyWith(
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
                      ),
                    )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 24,
                            child: Icon(Icons.person, color: AppColors.primary(context), size: 30),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "${user.firstName} ${user.lastName}",
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Hesabım & Siparişlerim",
                        style: AppTextStyle.bodyMedium(context).copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
          // Body
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                // Ana Menü
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Text(
                    "ANA MENÜ",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Colors.grey.shade400,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                _buildMenuItem(context, "Ana Sayfa", Icons.home_outlined, () {
                  Navigator.pop(context);
                  ref.read(bottomNavIndexProvider.notifier).setIndex(0);
                }),
                _buildMenuItem(context, "Tüm Ürünler", Icons.storefront_outlined, () {
                  Navigator.pop(context);
                  ref.read(bottomNavIndexProvider.notifier).setIndex(1);
                }),
                if (user != null) ...[
                  _buildMenuItem(context, "Favorilerim", Icons.favorite_border, () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/favorites');
                  }),
                  _buildMenuItem(context, "Siparişlerim", Icons.inventory_2_outlined, () {
                    Navigator.pop(context);
                    ref.read(bottomNavIndexProvider.notifier).setIndex(3); // Profile is index 3
                  }),
                ] else ...[
                  _buildMenuItem(context, "Giriş Yap", Icons.login, () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/profil/signIn');
                  }),
                  _buildMenuItem(context, "Kayıt Ol", Icons.person_add_outlined, () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/profil/signUp');
                  }),
                ],
                _buildMenuItem(context, "Sepetim", Icons.shopping_bag_outlined, () {
                  Navigator.pop(context);
                  ref.read(bottomNavIndexProvider.notifier).setIndex(2);
                }),

                const SizedBox(height: 24),

                // Kategoriler
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Text(
                    "KATEGORİLER",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Colors.grey.shade400,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                FutureBuilder<List<Category>>(
                  future: _futureCategory,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const DrawerShimmer();
                    } else if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text("Hata: ${snapshot.error}"),
                      );
                    } else if (snapshot.hasData) {
                      final categories = snapshot.data!;
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: categories.map((root) {
                          final children = root.children ?? [];
                          
                          return Theme(
                            data: Theme.of(context).copyWith(
                              dividerColor: Colors.transparent, // Remove border
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                            ),
                            child: ExpansionTile(
                              tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                              iconColor: Colors.grey.shade600,
                              collapsedIconColor: Colors.grey.shade600,
                              title: Text(
                                root.name.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: Theme.of(context).colorScheme.onSurface,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              children: children.map((sub) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.pushNamed(
                                      context,
                                      '/home/category',
                                      arguments: sub.kategoriId,
                                    );
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                                    child: Text(
                                      sub.name,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        }).toList(),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey.shade700),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
