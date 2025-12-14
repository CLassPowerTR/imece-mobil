part of 'buyer_profil_screen.dart';

class _topProfile extends StatelessWidget {
  final User buyerProfil;
  final double height;
  final double width;
  const _topProfile({
    required this.buyerProfil,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    // Performans için değerleri bir kez hesapla
    final theme = HomeStyle(context: context);
    final screenHeight = MediaQuery.of(context).size.height;
    final containerHeight = height * 0.4;
    final topSpacing = screenHeight * 0.06;
    final secondaryColor = theme.secondary;
    final primaryColor = theme.primary;
    final headlineSmallSize = theme.headlineSmall.fontSize;
    final bodyMediumSize = theme.bodyMedium.fontSize;

    // Profil fotoğrafı URL'ini önceden hesapla
    final String profileImageUrl =
        (buyerProfil.profilFotograf == null ||
            (buyerProfil.profilFotograf?.isEmpty ?? true))
        ? NotFound.defaultProfileImageUrl
        : buyerProfil.profilFotograf!;

    // İsim bilgisini önceden hesapla
    final displayName =
        (buyerProfil.firstName == '' && buyerProfil.lastName == '')
        ? buyerProfil.username
        : '${buyerProfil.firstName} ${buyerProfil.lastName}';

    // Rol bilgisini önceden hesapla
    final roleText = buyerProfil.rol == 'alici' ? 'Alıcı' : '';

    return SizedBox(
      height: height * 0.3,
      width: width,
      child: Container(
        height: containerHeight,
        width: width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

            colors: [
              secondaryColor.withOpacity(0.3),
              secondaryColor.withOpacity(0.5),
              secondaryColor.withOpacity(0.7),
              secondaryColor,
              secondaryColor.withGreen(190),
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 3,
          children: [
            SizedBox(height: topSpacing),
            ClipOval(
              child: Container(
                width: 80,
                height: 80,
                color: Colors.white,
                child: Image.network(
                  profileImageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  cacheWidth: 160,
                  cacheHeight: 160,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      NotFound.defaultProfileImageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      cacheWidth: 160,
                      cacheHeight: 160,
                    );
                  },
                ),
              ),
            ),
            customText(
              displayName,
              context,
              weight: FontWeight.bold,
              maxLines: 2,
              size: headlineSmallSize,
            ),
            customText(
              buyerProfil.email,
              context,
              color: primaryColor.withOpacity(0.5),
              maxLines: 2,
              size: bodyMediumSize,
            ),
            if (roleText.isNotEmpty)
              customText(
                roleText,
                context,
                color: primaryColor.withOpacity(0.5),
              ),
          ],
        ),
      ),
    );
  }
}

class _logoutButton extends ConsumerWidget {
  final VoidCallback? onLogout;
  const _logoutButton({this.onLogout});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: TextButton(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          overlayColor: WidgetStateProperty.all(
            HomeStyle(context: context).outline.withOpacity(0.08),
          ),
        ),
        onPressed: () async {
          try {
            final result = await ref.read(userProvider.notifier).logout();
            showTemporarySnackBar(context, result);
          } catch (e) {
            showTemporarySnackBar(context, e.toString());
          } finally {
            if (onLogout != null) {
              onLogout!();
            }
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 15,
          children: [
            Icon(
              Icons.logout_outlined,
              color: Colors.red,
              size: HomeStyle(context: context).headlineSmall.fontSize,
            ),
            customText(
              'Çıkış Yap',
              context,
              weight: FontWeight.w500,
              size: HomeStyle(context: context).bodyLarge.fontSize,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}

class _userMenu extends StatelessWidget {
  final User buyerProfil;
  const _userMenu({required this.buyerProfil});

  static const List<Map<String, dynamic>> menuItemsInfo = [
    {
      'title': 'Profilim',
      'icon': Icons.person_outline_sharp,
      'color': '#15d7fa',
      'route': '/profil/myProfile',
    },
    {
      'title': 'Siparişlerim',
      'icon': Icons.shopping_basket_outlined,
      'color': '#3baa00',
      'route': '/profil/orders',
    },
    {
      'title': 'Değerlendirmelerim',
      'icon': Icons.star_rate_outlined,
      'color': '#ffaa56',
      'route': '/profil/comments',
    },
    {
      'title': 'Dahil Olduğum Gruplar',
      'icon': Icons.group_outlined,
      'color': '#aa56ff',
      'route': '/profil/groups',
    },
    {
      'title': 'İndirim Kuponlarım',
      'icon': Icons.card_giftcard_outlined,
      'color': '#cc6c00',
      'route': '/profil/coupons',
    },
    {
      'title': 'Takip ettiklerim',
      'icon': Icons.person_outline_sharp,
      'color': '#ffaaaa',
      'route': '/profil/follow',
    },
    {
      'title': 'Adres Bilgilerim',
      'icon': Icons.location_on_outlined,
      'color': '#00bfbf',
      'route': '/profil/adress',
    },
    {
      'title': 'Kartlarım',
      'icon': Icons.credit_card_outlined,
      'color': '#ff007f',
      'route': '/profil/cards',
    },
    {
      'title': 'Favorilerim',
      'icon': Icons.favorite_border,
      'color': '#ff0000',
      'route': '/profil/favorite',
    },
    {
      'title': 'Destek',
      'icon': Icons.support_agent_outlined,
      'color': '#ff0000',
      'route': '/profil/support',
    },
    {
      'title': 'Ayarlar',
      'icon': Icons.settings_outlined,
      'color': '#000000',
      'route': '/profil/settings',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < menuItemsInfo.length; i++) ...[
            TextButton(
              style: ButtonStyle(
                padding: WidgetStateProperty.all(
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                alignment: Alignment.centerLeft,
                splashFactory: NoSplash.splashFactory,
                overlayColor: WidgetStateProperty.all(
                  HomeStyle(context: context).secondary,
                ),
              ),
              onPressed: () {
                final route = menuItemsInfo[i]['route'] as String?;
                if (route != null) {
                  if (route == '/profil/adress') {
                    Navigator.pushNamed(
                      context,
                      route,
                      arguments: {'buyerProfil': buyerProfil},
                    );
                  } else {
                    Navigator.pushNamed(context, route);
                  }
                } else {
                  // TODO: route null ise ilgili sayfa eklenecek
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        menuItemsInfo[i]['icon'],
                        size: 22,
                        color: Color(
                          int.parse(
                            menuItemsInfo[i]['color'].replaceAll('#', '0xff'),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      customText(menuItemsInfo[i]['title'], context),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
                ],
              ),
            ),
            if (i != menuItemsInfo.length - 1)
              Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey.shade300,
                indent: 8,
                endIndent: 8,
              ),
          ],
        ],
      ),
    );
  }
}
