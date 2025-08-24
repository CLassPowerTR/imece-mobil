part of 'buyer_profil_screen.dart';

class _topProfile extends StatelessWidget {
  final User buyerProfil;
  final double height;
  final double width;
  const _topProfile({
    super.key,
    required this.buyerProfil,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height * 0.3,
      width: width,
      child: OverflowBox(
        maxHeight: height * 0.4,
        maxWidth: width,
        minHeight: height * 0.4,
        minWidth: width,
        child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  HomeStyle(context: context).secondary.withOpacity(0.5),
                  HomeStyle(context: context).secondary,
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                      (buyerProfil.profilFotograf == null ||
                              (buyerProfil.profilFotograf?.isEmpty ?? true))
                          ? NotFound.defaultProfileImageUrl
                          : buyerProfil.profilFotograf!),
                ),
                Builder(builder: (context) {
                  if (buyerProfil.firstName == '' &&
                      buyerProfil.lastName == '') {
                    return customText(buyerProfil.username, context,
                        weight: FontWeight.bold,
                        maxLines: 2,
                        size:
                            HomeStyle(context: context).headlineSmall.fontSize);
                  }
                  return customText(
                      buyerProfil.firstName + ' ' + buyerProfil.lastName,
                      context,
                      weight: FontWeight.bold,
                      maxLines: 2,
                      size: HomeStyle(context: context).headlineSmall.fontSize);
                }),
                if (buyerProfil.email != null)
                  customText(buyerProfil.email!, context,
                      color:
                          HomeStyle(context: context).primary.withOpacity(0.5),
                      maxLines: 2,
                      size: HomeStyle(context: context).bodyMedium.fontSize),
                customText(
                    color: HomeStyle(context: context).primary.withOpacity(0.5),
                    '${buyerProfil.rol == 'alici' ? 'Alıcı' : ''}',
                    context)
              ],
            )),
      ),
    );
  }
}

class _logoutButton extends StatelessWidget {
  final VoidCallback? onLogout;
  const _logoutButton({super.key, this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: TextButton(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(
              EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
          overlayColor: WidgetStateProperty.all(
              HomeStyle(context: context).outline.withOpacity(0.08)),
        ),
        onPressed: () async {
          try {
            final result = await ApiService.fetchUserLogout();
            showTemporarySnackBar(
                context, result ?? 'Başarıyla çıkış yapıldı.');
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
  const _userMenu({super.key, required this.buyerProfil});

  static const List<Map<String, dynamic>> menuItemsInfo = [
    {
      'title': 'Profilim',
      'icon': Icons.person_outline_sharp,
      'color': '#15d7fa',
      'route': null,
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
      'route': null,
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
      'title': 'Ayarlar',
      'icon': Icons.settings_outlined,
      'color': '#000000',
      'route': null,
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
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                alignment: Alignment.centerLeft,
                splashFactory: NoSplash.splashFactory,
                overlayColor: WidgetStateProperty.all(
                    HomeStyle(context: context).secondary),
              ),
              onPressed: () {
                final route = menuItemsInfo[i]['route'] as String?;
                if (route != null) {
                  if (route == '/profil/adress') {
                    Navigator.pushNamed(context, route,
                        arguments: {'buyerProfil': buyerProfil});
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
                      Icon(menuItemsInfo[i]['icon'],
                          size: 22,
                          color: Color(int.parse(menuItemsInfo[i]['color']
                              .replaceAll('#', '0xff')))),
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
