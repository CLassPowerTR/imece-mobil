
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
                ? Column(
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
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Text(
                    "Kategoriler",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                        padding: EdgeInsets.all(20.0),
                        child: Text("Hata: ${snapshot.error}"),
                      );
                    } else if (snapshot.hasData) {
                      final categories = snapshot.data!;
                      return Column(
                        children: categories.map((category) {
                          return ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 20),
                            title: Text(
                              category.altKategoriAdi.toString(),
                              style: AppTextStyle.bodyMedium(context).copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
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
