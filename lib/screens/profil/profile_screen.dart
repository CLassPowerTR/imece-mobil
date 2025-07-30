import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imecehub/core/widgets/text.dart';
import 'package:imecehub/core/widgets/textButton.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';
import 'package:imecehub/screens/profil/buyerProfil/buyer_profil_screen.dart';
import 'package:imecehub/screens/profil/sellerProfil/seller_profil_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imecehub/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:imecehub/models/users.dart';
import 'dart:async';

import '../../core/widgets/showTemporarySnackBar.dart';
import 'package:imecehub/core/widgets/buildLoadingBar.dart';
part 'profileNotLogin.dart';

part 'SignUp/sign_up_view_header.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

class ProfileScreen extends ConsumerStatefulWidget {
  final bool? refresh;
  const ProfileScreen({super.key, this.refresh = false});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> with RouteAware {
  String accesToken = '';
  bool? _lastLoginState;
  User? _lastUser;

  @override
  void initState() {
    super.initState();
    _loadAndCache();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Geri dönülünce verileri yenile
    _loadAndCache();
    super.didPopNext();
  }

  Future<void> _loadAndCache() async {
    final isLoggedIn = await _checkLogin();
    User? user = ref.read(userProvider);

    // Eğer login ve user null ise, kullanıcıyı API'den çek
    if (isLoggedIn && user == null) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accesToken') ?? '';
      await ref.read(userProvider.notifier).fetchUserMe();
      user = ref.read(userProvider);
    }

    if (_lastLoginState != isLoggedIn || _lastUser != user) {
      setState(() {
        _lastLoginState = isLoggedIn;
        _lastUser = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ekranda eski veri varsa onu göster
    if (_lastLoginState == null) {
      // İlk yüklenme
      return Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.white,
        body: Center(
          child: buildLoadingBar(context),
        ),
      );
    }
    if (!_lastLoginState!) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: ProfileNotLogin(),
      );
    }
    if (_lastUser == null) {
      return ProfileNotLogin();
    }
    if (_lastUser!.aliciProfili == null && _lastUser!.saticiProfili != null) {
      return SellerProfilScreen(
        sellerProfil: _lastUser!,
        myProfile: true,
      );
    } else if (_lastUser!.saticiProfili == null &&
        _lastUser!.aliciProfili != null) {
      return BuyerProfilScreen(buyerProfil: _lastUser!);
    } else {
      return Builder(
        builder: (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showTemporarySnackBar(context, 'Profil bulunamadı.');
          });
          return ProfileNotLogin();
        },
      );
    }
  }

  Future<bool> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accesToken') ?? '';
    return token.isNotEmpty;
  }
}
