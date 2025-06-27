part of '../home_screen.dart';

class _HomeBottomNavigationBarTest extends ConsumerWidget {
  const _HomeBottomNavigationBarTest({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(bottomNavIndexProvider);
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Padding(
        padding: HomeStyle(context: context).bottomNavigationBarPadding,
        child: ClipRRect(
          borderRadius:
              HomeStyle(context: context).bottomNavigationBarBorderRadius,
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
            currentIndex: selectedIndex,
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
                ref.read(bottomNavIndexProvider.notifier).state = index,
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(BuildContext context,
      String label, String iconPath, int index, int selectedIndex) {
    final color = selectedIndex == index
        ? HomeStyle(context: context).secondary
        : HomeStyle(context: context).primary;
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        iconPath,
        color: color,
        fit: BoxFit.cover,
      ),
      label: label,
    );
  }
}
