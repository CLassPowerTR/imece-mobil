part of 'buyer_profil_screen.dart';

class BuyerProfilViewHeader extends StatelessWidget
    implements PreferredSizeWidget {
  final User buyerProfil;
  const BuyerProfilViewHeader({super.key, required this.buyerProfil});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Hesabım'),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(Icons.notification_add),
          onPressed: () {},
          // TODO: Navigator.pushNamed(context, '/profil/notification')
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
