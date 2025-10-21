part of '../home_screen.dart';

class _HomeBottomNavigationBarTest extends ConsumerStatefulWidget {
  const _HomeBottomNavigationBarTest({super.key});

  @override
  ConsumerState<_HomeBottomNavigationBarTest> createState() =>
      _HomeBottomNavigationBarTestState();
}

class _HomeBottomNavigationBarTestState
    extends ConsumerState<_HomeBottomNavigationBarTest> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
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
          currentIndex: ref.watch(bottomNavIndexProvider),
          items: [
            _buildBottomNavigationBarItem(
              context,
              'Anasayfa',
              'assets/vectors/homePage.svg',
              0,
              selectedIndex,
            ),
            _buildBottomNavigationBarItem(
              context,
              'Ürünler',
              'assets/vectors/urunler.svg',
              1,
              selectedIndex,
            ),
            _buildBottomNavigationBarItem(
              context,
              'Sepetim',
              'assets/vectors/sepet.svg',
              2,
              selectedIndex,
            ),
            _buildBottomNavigationBarItem(
              context,
              'Profilim',
              'assets/vectors/profil.svg',
              3,
              selectedIndex,
            ),
          ],
          type: BottomNavigationBarType.fixed,
          onTap: (index) =>
              ref.read(bottomNavIndexProvider.notifier).setIndex(index),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
    BuildContext context,
    String label,
    String iconPath,
    int index,
    int selectedIndex,
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
