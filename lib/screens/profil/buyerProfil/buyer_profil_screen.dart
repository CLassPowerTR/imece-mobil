import 'dart:ui';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imecehub/core/constants/app_colors.dart';
import 'package:imecehub/core/constants/app_paddings.dart';
import 'package:imecehub/core/constants/app_radius.dart';
import 'package:imecehub/core/constants/app_textSizes.dart';
import 'package:imecehub/core/function/actions.dart';
import 'package:imecehub/core/variables/url.dart';
import 'package:imecehub/core/widgets/cards/adressCard.dart';
import 'package:imecehub/core/widgets/buildLoadingBar.dart';
import 'package:imecehub/core/widgets/creditCart.dart';
import 'package:imecehub/core/widgets/cards/followsCard.dart';
import 'package:imecehub/core/widgets/text.dart';
import 'package:imecehub/core/widgets/textField.dart';
import 'package:imecehub/core/widgets/buttons/textButton.dart';
import 'package:imecehub/core/widgets/buttons/turnBackTextIcon.dart';
import 'package:imecehub/models/userAdress.dart';
import 'package:imecehub/models/userCoupons.dart';
import 'package:imecehub/models/users.dart';
import 'package:imecehub/providers/auth_provider.dart';
import 'package:imecehub/providers/products_provider.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';
import 'package:imecehub/services/api_service.dart';
import 'package:imecehub/core/widgets/showTemporarySnackBar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imecehub/screens/home/home_screen.dart';
import 'package:imecehub/core/widgets/cards/productsCard.dart';
import 'package:imecehub/models/products.dart';
import 'package:imecehub/core/widgets/cards/orderCard.dart';
import 'package:imecehub/core/widgets/empty_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

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

class BuyerProfilScreen extends ConsumerWidget {
  final User buyerProfil;

  const BuyerProfilScreen({super.key, required this.buyerProfil});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(userProvider);
    final user = currentUser ?? buyerProfil;

    return Scaffold(body: BuyerProfilViewBody(buyerProfil: user));
  }
}
