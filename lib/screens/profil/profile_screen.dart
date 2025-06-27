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
import 'dart:async';

import '../../core/widgets/showTemporarySnackBar.dart';
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
  bool isTimeout = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadAccessToken(force: true);
    _startTimeout();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
    _loadAccessToken(force: true);
  }

  void _startTimeout() {
    _timer?.cancel();
    isTimeout = false;
    _timer = Timer(const Duration(seconds: 5), () {
      if (mounted && userAsyncIsLoading()) {
        setState(() {
          isTimeout = true;
        });
      }
    });
  }

  bool userAsyncIsLoading() {
    final user = ref.read(userProvider);
    return user == null;
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didPopNext() {
    // Geri dönülünce verileri yenile
    _loadAccessToken(force: widget.refresh == true);
    super.didPopNext();
  }

  Future<void> _loadAccessToken({bool force = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accesToken') ?? '';
    setState(() {
      accesToken = token;
    });
    // Eğer force true ise veya provider'da kullanıcı yoksa API'den çek
    if (accesToken.isNotEmpty && (force || ref.read(userProvider) == null)) {
      await ref.read(userProvider.notifier).fetchUserMe(accesToken);
      ref.read(loginStateProvider.notifier).state = true; // örnek olarak login
    }
    _startTimeout();
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(loginStateProvider);
    final user = ref.watch(userProvider);

    // Güvenlik: accesToken yoksa veya boşsa, ya da loginState false ise ProfileNotLogin göster
    if (accesToken.isEmpty || !isLoggedIn) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: ProfileNotLogin(),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _loadAccessToken,
        child: Builder(
          builder: (context) {
            if (user == null) {
              return ProfileNotLogin();
            }
            if (user.aliciProfili == null && user.saticiProfili != null) {
              return SellerProfilScreen(
                sellerProfil: user,
                myProfile: isLoggedIn,
              );
            } else if (user.saticiProfili == null &&
                user.aliciProfili != null) {
              return BuyerProfilScreen(buyerProfil: user);
            } else {
              // Her iki profil de yoksa profil bulunamadı uyarı barı ve giriş ekranı
              return Builder(
                builder: (context) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showTemporarySnackBar(context, 'Profil bulunamadı.');
                  });
                  return ProfileNotLogin();
                },
              );
            }
          },
        ),
      ),
    );
  }
}
