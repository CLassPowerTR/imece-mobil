import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:imecehub/core/constants/app_colors.dart';
import 'package:imecehub/core/constants/app_paddings.dart';
import 'package:imecehub/core/constants/app_radius.dart';
import 'package:imecehub/core/constants/app_textSizes.dart';
import 'package:imecehub/core/variables/url.dart';
import 'package:imecehub/core/widgets/cards/adressCard.dart';
import 'package:imecehub/core/widgets/container.dart';
import 'package:imecehub/core/widgets/richText.dart';
import 'package:imecehub/core/widgets/cards/sepetProductsCard.dart';
import 'package:imecehub/core/widgets/showTemporarySnackBar.dart';
import 'package:imecehub/core/widgets/text.dart';
import 'package:imecehub/core/widgets/buttons/textButton.dart';
import 'package:imecehub/models/userAdress.dart';
import 'package:imecehub/models/users.dart';
import 'package:imecehub/providers/auth_provider.dart';
import 'package:imecehub/providers/products_provider.dart';
import 'package:imecehub/screens/home/home_screen.dart';
import 'package:imecehub/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:u_credit_card/u_credit_card.dart';
import 'package:imecehub/models/products.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imecehub/core/widgets/buildLoadingBar.dart';
import 'package:url_launcher/url_launcher.dart';

part 'widget/cart_view_header.dart';
part 'widget/cart_view_body.dart';

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    // Sepet artık login gerektirmeden açılır
    // Login kontrolü sadece "Satın Al" / sipariş tamamlama butonunda yapılır
    return Scaffold(
      appBar: _CartScreenHeader(context),
      body: _CartViewBody(),
    );
  }
}

Scaffold _isNotLoggin(BuildContext context, WidgetRef ref) {
  return Scaffold(
    body: Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          spacing: 20,
          children: [
            customText('Lütfen giriş yapınız', context),
            textButton(
              context,
              'Giriş Yap',
              onPressed: () {
                ref.read(bottomNavIndexProvider.notifier).setIndex(3);
                //Navigator.pushReplacementNamed(context, '/home');
              },
            ),
          ],
        ),
      ),
    ),
  );
}

Text _appBarHeaderText(String title) {
  return Text(
    title,
    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
  );
}

Text _appBarBodyText(String title) {
  return Text(
    title,
    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
  );
}
