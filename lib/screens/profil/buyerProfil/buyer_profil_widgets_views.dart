part of 'buyer_profil_screen.dart';

const String defaultProfileImageUrl =
    'https://thumbs.dreamstime.com/b/default-profile-picture-icon-high-resolution-high-resolution-default-profile-picture-icon-symbolizing-no-display-picture-360167031.jpg';

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
      height: height * 0.1,
      width: width,
      child: OverflowBox(
        maxHeight: height * 0.22,
        maxWidth: width,
        minHeight: height * 0.2,
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
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                      (buyerProfil.profilFotograf == null ||
                              (buyerProfil.profilFotograf?.isEmpty ?? true))
                          ? defaultProfileImageUrl
                          : buyerProfil.profilFotograf!),
                ),
                Builder(builder: (context) {
                  if (buyerProfil.firstName == '' &&
                      buyerProfil.lastName == '') {
                    return customText(buyerProfil.username, context,
                        weight: FontWeight.bold,
                        size:
                            HomeStyle(context: context).headlineSmall.fontSize);
                  }
                  return customText(
                      buyerProfil.firstName + ' ' + buyerProfil.lastName,
                      context,
                      weight: FontWeight.bold,
                      size: HomeStyle(context: context).headlineSmall.fontSize);
                }),
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
      decoration: BoxDecoration(
        border:
            Border.all(color: HomeStyle(context: context).outline, width: 1.2),
        borderRadius: BorderRadius.circular(8),
      ),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout_outlined,
              color: Colors.red,
              size: HomeStyle(context: context).headlineSmall.fontSize,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: customText(
                  'Çıkış Yap',
                  context,
                  size: HomeStyle(context: context).bodyLarge.fontSize,
                  color: HomeStyle(context: context).primary,
                ),
              ),
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

  static const List<String> menuItems = [
    'Siparişlerim',
    'Değerlendirmelerim',
    'İndirim Kuponlarım',
    'Takip ettiklerim',
    'Adres Bilgilerim',
    'Kartlarım',
    'Favorilerim',
  ];

  static const List<IconData> menuIcons = [
    Icons.shopping_bag_outlined, // Siparişlerim
    Icons.star_rate_outlined, // Değerlendirmelerim
    Icons.card_giftcard_outlined, // İndirim Kuponlarım
    Icons.person_outline_sharp, // Takip ettiklerim
    Icons.location_on_outlined, // Adres Bilgilerim
    Icons.credit_card_outlined, // Kartlarım
    Icons.favorite_border, // Favorilerim
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < menuItems.length; i++) ...[
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
                switch (i) {
                  case 0:
                    Navigator.pushNamed(context, '/profil/orders');
                    break;
                  case 1:
                    Navigator.pushNamed(context, '/profil/comments');
                    break;
                  case 2:
                    Navigator.pushNamed(context, '/profil/coupons');
                    break;
                  case 3:
                    Navigator.pushNamed(context, '/profil/follow');
                    break;
                  case 4:
                    Navigator.pushNamed(context, '/profil/adress',
                        arguments: {'buyerProfil': buyerProfil});
                    break;
                  case 5:
                    Navigator.pushNamed(context, '/profil/cards');
                    break;
                  default:
                    Navigator.pushNamed(context, '/profil/favorite');
                    break;
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(menuIcons[i], size: 22, color: Colors.grey[700]),
                      SizedBox(width: 12),
                      customText(menuItems[i], context),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
                ],
              ),
            ),
            if (i != menuItems.length - 1)
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
