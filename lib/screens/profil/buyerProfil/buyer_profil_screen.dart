import 'package:flutter/material.dart';
import 'package:imecehub/core/widgets/text.dart';
import 'package:imecehub/core/widgets/textButton.dart';
import 'package:imecehub/models/users.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';
import 'package:imecehub/services/api_service.dart';
import 'package:imecehub/core/widgets/showTemporarySnackBar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:imecehub/screens/home/home_screen.dart';

part 'buyer_profil_view_header.dart';
part 'buyer_profil_view_body.dart';
part 'buyer_profil_widgets_views.dart';
part 'menu/favorite_screen.dart';

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
      appBar: BuyerProfilViewHeader(buyerProfil: widget.buyerProfil),
      body: BuyerProfilViewBody(
        buyerProfil: widget.buyerProfil,
      ),
    );
  }
}
