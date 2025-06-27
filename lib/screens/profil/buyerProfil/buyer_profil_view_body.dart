part of 'buyer_profil_screen.dart';

class BuyerProfilViewBody extends ConsumerStatefulWidget {
  final User buyerProfil;

  const BuyerProfilViewBody({super.key, required this.buyerProfil});

  @override
  ConsumerState<BuyerProfilViewBody> createState() =>
      _BuyerProfilViewBodyState();
}

class _BuyerProfilViewBodyState extends ConsumerState<BuyerProfilViewBody> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: kToolbarHeight),
          _topProfile(
            buyerProfil: widget.buyerProfil,
            height: height,
            width: width,
          ),
          SizedBox(height: 32),
          _userMenu(),
          SizedBox(height: 32),
          _logoutButton(
            onLogout: () {
              ref.read(bottomNavIndexProvider.notifier).state = 3;
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (route) => false,
                  arguments: {'refresh': true});
            },
          ),
          SizedBox(height: height * 0.2),
        ],
      ),
    );
  }
}
