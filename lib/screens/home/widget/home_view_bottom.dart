
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
    final itemsData = <Map<String, String>>[
      {'label': 'Anasayfa', 'iconPath': 'assets/vectors/homePage.svg'},
      {'label': 'Ürünler', 'iconPath': 'assets/vectors/urunler.svg'},
      {'label': 'Sepetim', 'iconPath': 'assets/vectors/sepet.svg'},
      {'label': 'Hesabım', 'iconPath': 'assets/vectors/profil.svg'},
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
      padding: AppPaddings.h10v10,
      child: ClipRRect(
        borderRadius: AppRadius.r16,
        child: BottomNavigationBar(
          backgroundColor: AppColors.surface(context),
          selectedItemColor: AppColors.onPrimaryContainer(context),
          unselectedItemColor: AppColors.primary(context),
          selectedLabelStyle: TextStyle(
            color: AppColors.onPrimaryContainer(context),
          ),
          unselectedLabelStyle: TextStyle(
            color: AppColors.primary(context),
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
    final primary = AppColors.primary(context);
    final secondary = AppColors.secondary(context);
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
