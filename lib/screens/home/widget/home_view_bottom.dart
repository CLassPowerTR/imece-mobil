part of '../home_screen.dart';

class _HomeBottomNavigationBarTest extends ConsumerStatefulWidget {
  const _HomeBottomNavigationBarTest();

  @override
  ConsumerState<_HomeBottomNavigationBarTest> createState() =>
      _HomeBottomNavigationBarTestState();
}

class _HomeBottomNavigationBarTestState
    extends ConsumerState<_HomeBottomNavigationBarTest> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final bool isSeller = user?.rol == 'satici';

    final itemsData = <Map<String, String>>[
      {'label': 'Anasayfa', 'iconPath': 'assets/vectors/homePage.svg'},
      {'label': 'Ürünler', 'iconPath': 'assets/vectors/urunler.svg'},
      if (!isSeller)
        {'label': 'Sepetim', 'iconPath': 'assets/vectors/sepet.svg'},
      {'label': 'Profilim', 'iconPath': 'assets/vectors/profil.svg'},
    ];

    final selectedIndex = ref.watch(bottomNavIndexProvider);
    final safeIndex = selectedIndex < itemsData.length
        ? selectedIndex
        : itemsData.length - 1;

    if (safeIndex != selectedIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(bottomNavIndexProvider.notifier).setIndex(safeIndex);
      });
    }

    return Padding(
      padding: HomeStyle(context: context).bottomNavigationBarPadding,
      child: ClipRRect(
        borderRadius: HomeStyle(
          context: context,
        ).bottomNavigationBarBorderRadius,
        child: BottomNavigationBar(
          backgroundColor: HomeStyle(context: context).surfaceContainer,
          selectedItemColor: HomeStyle(context: context).secondary,
          unselectedItemColor: HomeStyle(context: context).primary,
          selectedLabelStyle: TextStyle(
            color: HomeStyle(context: context).secondary,
          ),
          unselectedLabelStyle: TextStyle(
            color: HomeStyle(context: context).primary,
          ),
          currentIndex: safeIndex,
          items: [
            for (final item in itemsData)
              _buildBottomNavigationBarItem(
                context,
                item['label'] ?? '',
                item['iconPath'] ?? '',
              ),
          ],
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            ref.read(bottomNavIndexProvider.notifier).setIndex(index);
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
    BuildContext context,
    String label,
    String iconPath,
  ) {
    final primary = HomeStyle(context: context).primary;
    final secondary = HomeStyle(context: context).secondary;
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        iconPath,
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(primary, BlendMode.srcIn),
      ),
      activeIcon: SvgPicture.asset(
        iconPath,
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(secondary, BlendMode.srcIn),
      ),
      label: label,
    );
  }
}
