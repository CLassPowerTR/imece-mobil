import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:imecehub/core/widgets/adressCard.dart';
import 'package:imecehub/core/widgets/container.dart';
import 'package:imecehub/core/widgets/richText.dart';
import 'package:imecehub/core/widgets/sepetProductsCard.dart';
import 'package:imecehub/core/widgets/showTemporarySnackBar.dart';
import 'package:imecehub/core/widgets/text.dart';
import 'package:imecehub/core/widgets/textButton.dart';
import 'package:imecehub/models/userAdress.dart';
import 'package:imecehub/models/users.dart';
import 'package:imecehub/providers/auth_provider.dart';
import 'package:imecehub/screens/home/home_screen.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';
import 'package:imecehub/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:u_credit_card/u_credit_card.dart';
import 'package:imecehub/models/products.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imecehub/core/widgets/buildLoadingBar.dart';

part 'widget/cart_view_header.dart';
part 'widget/cart_view_body.dart';

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  int tryLoginCount = 0;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: buildLoadingBar(context),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
              body: Center(
                  child: Column(
            children: [
              Text('Hata Oluştu.\nLütfen Tekrar Deneyiniz.'),
              TextButton(
                onPressed: () async {
                  setState(() {
                    tryLoginCount++;
                  });
                },
                child: Text('Tekrar Dene'),
              )
            ],
          )));
        } else if (snapshot.hasData) {
          final isLoggedIn = snapshot.data!;
          if (!isLoggedIn) {
            return _isNotLoggin(context, ref);
          }
          return Scaffold(
              appBar: _CartScreenHeader(context), body: _CartViewBody());
        } else {
          return const Scaffold(body: Center(child: Text('Bilinmeyen hata')));
        }
      },
    );
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
            customText('Lütfen giriş yapınız!', context,
                textAlign: TextAlign.center,
                size: HomeStyle(context: context).bodyLarge.fontSize,
                weight: FontWeight.bold),
            textButton(context, 'Giriş Yap', onPressed: () {
              ref.read(bottomNavIndexProvider.notifier).state = 3;
              //Navigator.pushReplacementNamed(context, '/home');
            })
          ],
        ),
      )),
    );
  }

  Future<bool> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accesToken') ?? '';
    return token.isNotEmpty;
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
          textButton(context, 'Giriş Yap', onPressed: () {
            ref.read(bottomNavIndexProvider.notifier).state = 3;
            //Navigator.pushReplacementNamed(context, '/home');
          })
        ],
      ),
    )),
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
