import 'package:http/http.dart' as http;
import 'package:imecehub/core/variables/url.dart';
import 'seller_profil_screen_library.dart';

part 'views/seller_profil_view_header.dart';
part 'views/seller_profil_view_body.dart';
part 'widgets/seller_profil_fastCenter.dart';
part 'widgets/seller_profile_settings_widgets.dart';

class SellerProfilScreen extends StatefulWidget {
  final User sellerProfil;

  final bool myProfile;

  const SellerProfilScreen({
    super.key,
    required this.sellerProfil,
    required this.myProfile,
  });

  @override
  State<SellerProfilScreen> createState() => _SellerProfilScreenState();
}

class _SellerProfilScreenState extends State<SellerProfilScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _sellerProfilAppBar(context),
      body: SellerProfilBody(
        sellerProfil: widget.sellerProfil,
        myProfile: widget.myProfile,
      ),
    );
  }
}
