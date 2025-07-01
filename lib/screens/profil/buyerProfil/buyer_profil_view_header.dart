part of 'buyer_profil_screen.dart';

class BuyerProfilViewHeader extends StatelessWidget
    implements PreferredSizeWidget {
  final User buyerProfil;
  const BuyerProfilViewHeader({super.key, required this.buyerProfil});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          title: customText('Hesabım', context,
              size: HomeStyle(context: context).bodyLarge.fontSize,
              weight: FontWeight.w600),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 4,
          automaticallyImplyLeading: false,
          shadowColor: Colors.grey[300],
          actions: [
            IconButton(
              icon: Icon(Icons.notification_add),
              onPressed: () {},
              // TODO: Navigator.pushNamed(context, '/profil/notification')
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 8);
}
