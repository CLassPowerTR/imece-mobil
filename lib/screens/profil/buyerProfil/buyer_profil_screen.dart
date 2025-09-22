import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:imecehub/core/constants/app_colors.dart';
import 'package:imecehub/core/constants/app_paddings.dart';
import 'package:imecehub/core/constants/app_radius.dart';
import 'package:imecehub/core/constants/app_textSizes.dart';
import 'package:imecehub/core/function/actions.dart';
import 'package:imecehub/core/variables/url.dart';
import 'package:imecehub/core/widgets/adressCard.dart';
import 'package:imecehub/core/widgets/buildLoadingBar.dart';
import 'package:imecehub/core/widgets/creditCart.dart';
import 'package:imecehub/core/widgets/followsCard.dart';
import 'package:imecehub/core/widgets/text.dart';
import 'package:imecehub/core/widgets/textField.dart';
import 'package:imecehub/core/widgets/textButton.dart';
import 'package:imecehub/core/widgets/turnBackTextIcon.dart';
import 'package:imecehub/models/userAdress.dart';
import 'package:imecehub/models/userCoupons.dart';
import 'package:imecehub/models/users.dart';
import 'package:imecehub/providers/auth_provider.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';
import 'package:imecehub/services/api_service.dart';
import 'package:imecehub/core/widgets/showTemporarySnackBar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imecehub/screens/home/home_screen.dart';
import 'package:imecehub/core/widgets/productsCard.dart';
import 'package:imecehub/models/products.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'buyer_profil_view_header.dart';
part 'buyer_profil_view_body.dart';
part 'buyer_profil_widgets_views.dart';
part 'menu/favorite_screen.dart';
part 'menu/orders/orders_screen.dart';
part 'menu/follow_screen.dart';
part 'menu/coupons_screen.dart';
part 'menu/groups_screen.dart';
part 'menu/profile/myProfile_screen.dart';
part 'menu/profile/myProfile_edit_screen.dart';
part 'menu/settings_screen.dart';
part 'menu/adress/adress_screen.dart';
part 'menu/cards_screen.dart';
part 'menu/orders/order_screen_body.dart';

class BuyerProfilScreen extends StatefulWidget {
  final User buyerProfil;

  const BuyerProfilScreen({super.key, required this.buyerProfil});

  @override
  State<BuyerProfilScreen> createState() => _BuyerProfilScreenState();
}

class _BuyerProfilScreenState extends State<BuyerProfilScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: BuyerProfilViewHeader(buyerProfil: widget.buyerProfil),
      body: BuyerProfilViewBody(
        buyerProfil: widget.buyerProfil,
      ),
    );
  }
}
